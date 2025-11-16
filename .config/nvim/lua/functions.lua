local function get_clipboard()
  return vim.fn.getreg('+')
end


vim.api.nvim_create_user_command("MarkdownFormatHeaderSpaces", function()
  local save_cursor = vim.fn.getpos('.')
  vim.cmd([[
        :%s/\v^(\s*\n)*(### .*\n)(\s*\n)*/\r\r\2/e
        :nohlsearch
      ]])
  vim.cmd([[
        :%s/\v^(\s*\n)*(## .*\n)(\s*\n)*/\r\r\r\2/e
        :nohlsearch
      ]])
  vim.fn.setpos('.', save_cursor)
end, {})
vim.api.nvim_set_keymap('n', '<leader>mf', ":MarkdownFormatHeaderSpaces<cr>",
  { desc = "[M]arkdown [Format] header spaces", noremap = true, silent = true })

-- Function to add # at the beginning of a line.
-- If it's the first symbol, add a space between the symbol and the rest of the text.
function AddHashToLine()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line
  local chars_added = 0

  -- If the line already starts with '#', just prepend another '#'
  if line:sub(1, 1) == '#' then
    new_line = '#' .. line
    chars_added = 1
  else
    -- If the line does not start with '#', prepend '# '
    new_line = '# ' .. line
    chars_added = 2
  end

  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col + chars_added })
end

vim.api.nvim_set_keymap("n", "<leader>ha", ":lua AddHashToLine()<CR>", { noremap = true, silent = true })

-- Function to remove # at the beginning of a line.
-- If '#' is the only symbol, remove the entire line.
-- If '#' is followed by a space, remove both '#' and the space.
function RemoveHashFromLine()
  local line = vim.api.nvim_get_current_line()

  -- Do nothing if the line does not start with '#'
  if line:sub(1, 1) ~= '#' then
    return
  end

  local new_line

  -- If the line is exactly '#', make it an empty line
  if #line == 1 then
    new_line = ''
    -- If the line starts with '# ' (hash followed by a space), remove both
  elseif line:sub(2, 2) == ' ' then
    new_line = line:sub(3) -- Get substring starting from the 3rd character
    -- If the line starts with '#' but not followed by a space (e.g., '#text'), remove only '#'
  else
    new_line = line:sub(2) -- Get substring starting from the 2nd character
  end

  vim.api.nvim_set_current_line(new_line)
end

vim.api.nvim_set_keymap("n", "<leader>hr", ":lua RemoveHashFromLine()<CR>", { noremap = true, silent = true })


local function escape_lua_pattern(s)
  -- Escape characters that are magic in Lua patterns
  return s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

function SendFileToRemote(server_name, remote_root_path)
  local local_file_abs_path = vim.fn.expand('%:p')

  -- Get the local Git repository root
  local git_root_output = vim.fn.system('git rev-parse --show-toplevel')
  local local_git_root = vim.fn.trim(git_root_output)

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Error: Not a Git repository or 'git rev-parse --show-toplevel' failed.", "ErrorMsg" } }, true,
      {})
    return
  end

  -- Calculate the relative path from the local Git root
  -- Escape local_git_root and the trailing slash for Lua pattern matching
  local pattern_to_remove = "^" .. escape_lua_pattern(local_git_root .. "/")
  local relative_path = string.gsub(local_file_abs_path, pattern_to_remove, '')

  -- Construct the scp command
  local scp_command = 'scp ' ..
      vim.fn.shellescape(local_file_abs_path) ..
      ' ' .. server_name .. ':' .. remote_root_path .. '/' .. vim.fn.shellescape(relative_path)

  -- Execute the command
  vim.api.nvim_echo({ { "Executing: " .. scp_command, "Normal" } }, true, {})
  vim.cmd('!' .. scp_command)
  vim.api.nvim_echo({ { "Command DONE" } }, true, {})
end

vim.api.nvim_create_user_command(
  'Scp',
  function(opts)
    local args = vim.split(opts.args, '%s+')
    if #args ~= 2 then
      vim.api.nvim_echo({ { "Usage: :Scp <server_name> <remote_root_path>", "ErrorMsg" } }, true, {})
      return
    end
    SendFileToRemote(args[1], args[2])
  end,
  { nargs = '*', complete = 'file', desc = 'Send current file to remote server via scp' }
)



function FromGithubLinkToMarkdownPRRef()
  -- e.g. https://github.com/<org>/<project>/pull/<number>
  -- will be converted to [<org/<project> PR<number>]
  -- and a Markdown reference link will be created at
  -- the end of the buffer like below:
  -- [<org/<project> PR<number>]: https://github.com/<org>/<project>/pull/<number>

  local github_link = vim.fn.getreg('+') -- Get content from the system clipboard
  if not github_link or github_link == '' then
    vim.notify("Clipboard is empty.", vim.log.levels.WARN, { title = "GitHub Link" })
    return
  end

  -- Regex to extract organization, project, and PR number
  local pattern = "https://github.com/([^/]+)/([^/]+)/pull/(%d+)"
  local org, project, pr_number = string.match(github_link, pattern)

  if not (org and project and pr_number) then
    vim.notify("Clipboard content is not a valid GitHub PR link.", vim.log.levels.ERROR, { title = "GitHub Link" })
    return
  end

  local markdown_label = string.format("[%s/%s PR%s]", org, project, pr_number)
  local markdown_ref = string.format("[%s/%s PR%s]: %s", org, project, pr_number, github_link)

  local bufnr = vim.api.nvim_get_current_buf()
  local last_line = vim.api.nvim_buf_line_count(bufnr)

  -- Insert the markdown reference at the end of the buffer.
  vim.api.nvim_buf_set_lines(bufnr, last_line, last_line, false, { markdown_ref })

  -- Insert the markdown label at the current cursor position
  -- 'c' for character-wise insert, 'false' for inserting before cursor, 'true' for moving cursor to end of paste
  vim.api.nvim_put({ markdown_label }, "c", false, true)

  vim.notify("GitHub PR link converted and reference added.", vim.log.levels.INFO, { title = "GitHub Link" })
end

local function get_text_inside_brackets()
  local line = vim.fn.getline(".") -- Get the current line
  local col = vim.fn.col(".")      -- Get the current column position

  -- Find the closest opening bracket before the cursor
  local left_bracket_pos = nil
  local left_bracket_type = nil
  for i = col - 1, 1, -1 do
    local char = line:sub(i, i)
    if char == "(" or char == "[" or char == "{" then
      left_bracket_pos = i
      left_bracket_type = char
      break
    end
  end

  -- Find the closest closing bracket after the cursor
  local right_bracket_pos = nil
  local right_bracket_type = nil
  for i = col, #line do
    local char = line:sub(i, i)
    if char == ")" or char == "]" or char == "}" then
      right_bracket_pos = i
      right_bracket_type = char
      break
    end
  end

  -- If both positions are found, check if the brackets match and extract the text inside
  if left_bracket_pos and right_bracket_pos then
    -- Ensure the brackets match
    if (left_bracket_type == "(" and right_bracket_type == ")") or
        (left_bracket_type == "[" and right_bracket_type == "]") or
        (left_bracket_type == "{" and right_bracket_type == "}") then
      -- Extract text inside the brackets
      local text_inside = line:sub(left_bracket_pos + 1, right_bracket_pos - 1)
      return text_inside
    end
  end

  return nil -- Return nil if no matching brackets are found
end

-- Move the cursor inside a rounded brackets with the task uuid "some task (12345)"
-- the function will get the uuid and jump to the file(s) where the corresponding
-- Taskwarrior task object is defined
function Task_find_from_uuid()
  --local uuid = get_clipboard()
  local uuid = vim.fn.expand('<cword>')
  if uuid == "" then return end

  local cmd = "rg --glob '!**/Overview.md' -l -e '\\[.\\] .*" .. uuid .. "' ."
  local result = vim.fn.systemlist(cmd)

  if #result == 1 then
    vim.cmd("edit " .. result[1])
    vim.cmd("silent! /" .. uuid)
  elseif #result > 1 then
    vim.ui.select(result, { prompt = "Multiple matches found. Choose a file:" }, function(choice)
      if choice then
        vim.cmd("edit " .. choice)
        vim.cmd("silent! /" .. uuid)
      else
        print("cannot open choice: " .. choice)
      end
    end)
  else
    print("No match found")
  end
end
vim.api.nvim_set_keymap("n", "<leader>tf", ":lua Task_find_from_uuid()<CR>", { noremap = true, silent = true })

-- Move the cursor inside a rounded brackets with the task uuid "some task (12345)"
-- the function will get the uuid and open the corresponding Taskwarrior task object for editing
function Task_edit_from_uuid()
  local uuid = vim.fn.expand('<cword>')
  if uuid == "" then return end

  local command = "task rc:~/.taskworkrc " .. uuid .. " edit"
  vim.api.nvim_echo({ { "Executing: " .. command, "Normal" } }, true, {})
  vim.cmd(':terminal ' .. command)
end
--vim.api.nvim_set_keymap("n", "<leader>te", ":lua Task_edit_from_uuid()<CR>", { noremap = true, silent = true })


function Task_done_from_uuid()
  local uuid = vim.fn.expand('<cword>')
  if uuid == "" then return end

  local command = "task rc:~/.taskworkrc " .. uuid .. " done"
  vim.api.nvim_echo({ { "Executing: " .. command, "Normal" } }, true, {})
  vim.cmd(':terminal ' .. command)
end
vim.api.nvim_set_keymap("n", "<leader>td", ":lua Task_done_from_uuid()<CR>", { noremap = true, silent = true })


function Task_undo_from_uuid()
  --local uuid = get_clipboard()
  local uuid = vim.fn.expand('<cword>')
  if uuid == "" then return end

  local command = "task rc:~/.taskworkrc " .. uuid .. " undo"
  vim.api.nvim_echo({ { "Executing: " .. command, "Normal" } }, true, {})
  vim.cmd(':terminal ' .. command)
end
vim.api.nvim_set_keymap("n", "<leader>tu", ":lua Task_undo_from_uuid()<CR>", { noremap = true, silent = true })


-- Add one hashtag '#' at the beginning of the current line
function AddMarkdownHeader()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- Get cursor position
  local line = vim.api.nvim_get_current_line()            -- Get current line content
  vim.api.nvim_set_current_line('#' .. line)              -- Prepend #
  vim.api.nvim_win_set_cursor(0, { row, col + 1 })        -- Adjust cursor position
end

-- Remove one hashtag '#' from the beginning of the current line
function RemoveMarkdownHeader()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- Get cursor position
  local line = vim.api.nvim_get_current_line()            -- Get current line content

  -- Remove leading "#" only if it exists
  if line:sub(1, 1) == '#' then
    vim.api.nvim_set_current_line(line:sub(2))                    -- Remove first character
    vim.api.nvim_win_set_cursor(0, { row, math.max(0, col - 1) }) -- Adjust cursor position
  end
end

-- Key mappings in insert mode
-- Unnecessary. Add markdown with TAB and <C-u> is the default for move upward by a page, I don't want to override it
--vim.api.nvim_set_keymap('n', '<C-i>', '<Cmd>lua AddMarkdownHeader()<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<C-u>', '<Cmd>lua RemoveMarkdownHeader()<CR>', { noremap = true, silent = true })


-- Wrap the selected text in tryple backtics with the option to add the quote type (e.g. go, bash, ...)
function Wrap_with_triple_backticks()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  vim.ui.input({ prompt = "Enter code language: " }, function(lang)
    local opening_backticks = lang and lang ~= "" and "```" .. lang or "```"
    vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '```' })
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { opening_backticks })
  end)
end

vim.api.nvim_set_keymap('v', '<leader>`', ":lua Wrap_with_triple_backticks()<CR>", { noremap = true, silent = true })


function CopyCodeAndPermalink()
  -- Get the current filetype
  local filetype = vim.bo.filetype
  print('Current filetype: ' .. filetype)

  -- yank current selection in z register
  vim.cmd('normal! `<v`>"ay')
  local saved_selection = vim.fn.getreg('a')

  -- Get Remote link of the selection
  local link = ""
  local original_clipboard_content = vim.fn.getreg('+')

  -- Try to get the link from @upstream first
  local upstream_success, upstream_link = pcall(function()
    vim.cmd("'<,'>GBrowse! @upstream")
    return vim.fn.getreg('+')
  end)

  if upstream_success and upstream_link ~= "" and upstream_link ~= original_clipboard_content then
    link = upstream_link
    print("Got permalink from upstream.")
    if not upstream_success then
      print("Upstream permalink failed: " .. upstream_link)
    else
      print("Upstream permalink not found or failed, trying origin.")
    end
  end

  -- If upstream failed or didn't change the clipboard, try @origin
  -- Restore original clipboard content before trying origin, to accurately check for changes
  vim.fn.setreg('+', original_clipboard_content)
  local origin_success, origin_link = pcall(function()
    vim.cmd("'<,'>GBrowse! @origin")
    return vim.fn.getreg('+')
  end)

  if origin_success and origin_link ~= "" and origin_link ~= original_clipboard_content then
    link = origin_link
    print("Got permalink from origin.")
  else
    if not origin_success then
      print("Failed to get permalink from origin: " .. origin_link)
    else
      print("Failed to get permalink from origin as well.")
    end
  end

  local filetype_to_comment_map = {
    ["c"] = "// ",
    ["cpp"] = "// ",
    ["go"] = "// ",
    ["lua"] = "-- ",
    ["python"] = "# ",
    ["sh"] = "# ",
  }

  local output = ""
  if filetype_to_comment_map[filetype] then
    output = output .. "```" .. filetype .. "\n"
    output = output .. filetype_to_comment_map[filetype] .. link .. "\n"
  else
    output = output .. "```" .. "\n"
    output = output .. "// " .. link .. "\n"
  end

  output = output .. saved_selection .. "\n"
  output = output .. "```"
  vim.fn.setreg('+', output)
end

vim.api.nvim_set_keymap('v', '<leader>cp', ":lua CopyCodeAndPermalink()<CR>",
  { desc = 'Format selected code with its permalink', noremap = true, silent = true })


function Yank_code_block()
  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = current_pos[1]

  -- Find the start and end of the code block
  local start_line, end_line = nil, nil
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of the code block
  for i = line_num, 1, -1 do
    if lines[i]:match("```") then
      start_line = i
      break
    end
  end

  -- Find end of the code block
  for i = line_num, #lines do
    if lines[i]:match("```") then
      end_line = i
      break
    end
  end

  -- If we found a valid range, proceed with yanking
  if start_line and end_line then
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, { end_line, 1000 })
    vim.cmd('normal! y')

    -- Restore original cursor position
    vim.api.nvim_win_set_cursor(0, current_pos)
  end
end

vim.api.nvim_set_keymap('n', '<leader>y`', '<cmd> lua Yank_code_block()<cr>', {
  desc = 'Yank code block',
  noremap = true,
  silent = true
})

function Select_code_block()
  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = current_pos[1]

  -- Find the start and end of the code block
  local start_line, end_line = nil, nil
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of the code block
  for i = line_num, 1, -1 do
    if lines[i]:match("```") then
      start_line = i
      break
    end
  end

  -- Find end of the code block
  for i = line_num, #lines do
    if lines[i]:match("```") then
      end_line = i
      break
    end
  end

  -- If we found a valid range, proceed with yanking
  if start_line and end_line then
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, { end_line, 1000 })

    -- Restore original cursor position
    vim.api.nvim_win_set_cursor(0, current_pos)
  end
end

vim.api.nvim_set_keymap('n', '<leader>v`', '<cmd> lua Select_code_block()<cr>', {
  desc = 'Yank code block',
  noremap = true,
  silent = true
})
local function copy_code_block_to_file(block_type, filepath)
  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = current_pos[1]

  -- Find the start and end of the Mermaid code block
  local start_line, end_line = nil, nil
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of the Mermaid code block
  for i = line_num, 1, -1 do
    if lines[i]:match("```" .. block_type) then
      start_line = i
      break
    end
  end

  -- Find end of the code block
  for i = line_num, #lines do
    if lines[i]:match("```") then
      end_line = i
      break
    end
  end

  -- If we found a valid range, proceed with copying
  if start_line and end_line then
    -- Get the lines of code block
    local code_block = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- Create a temporary file and write the code block into it
    local file = io.open(filepath, "w")
    for _, line in ipairs(code_block) do
      file:write(line .. "\n")
    end
    file:close()
  end
end

vim.api.nvim_create_user_command(
  "PlantUMLCreateASCII",
  function()
    copy_code_block_to_file("plantuml", "/tmp/plantuml.puml")
    local handle = io.popen('cat /tmp/plantuml.puml | plantuml -pipe -utxt | tee /tmp/plantuml.txt | wl-copy')
    if not handle then
      print("failed to run plantuml command")
      return
    end
    handle:close()
    print("plantUML ASCII in clipboard")
  end,
  {}
)

vim.api.nvim_set_keymap('n', '<leader>pc', ":PlantUMLCreateASCII<CR>", { noremap = true, silent = true })

-- Move the cursor in a Mermaid section, the function will create the SVG
vim.api.nvim_create_user_command("MermaidCreateSVG", function(opts)
  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = current_pos[1]

  -- Find the start and end of the code block
  local start_line, end_line = nil, nil
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of the code block
  for i = line_num, 1, -1 do
    if lines[i]:match("```mermaid") then
      start_line = i
      break
    end
  end

  -- Find end of the code block
  for i = line_num, #lines do
    if lines[i]:match("```") then
      end_line = i
      break
    end
  end

  -- If we found a valid range, proceed with copying
  if start_line and end_line then
    -- Get the lines of Mermaid code
    local mermaid_code = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- Create a temporary file and write the Mermaid code into it
    local tmp_file = "/tmp/render-mermaid.md"
    local file = io.open(tmp_file, "w")
    for _, line in ipairs(mermaid_code) do
      file:write(line .. "\n")
    end
    file:close()

    local output = vim.fn.input("Enter full output path: ")

    -- Run the mermaid-cli command
    local command = string.format("~/Apps/node_modules/.bin/mmdc -i %s -o %s", tmp_file, output)
    os.execute(command)

    -- Optionally, print a message
    print("Mermaid image generated!")
  else
    -- If no valid Mermaid block is found, print an error message
    print("No Mermaid code block found at cursor position.")
  end
end, {})


-- Closes a list of buffers. Separate the buffers name by a comma
vim.api.nvim_create_user_command("Bdelete", function(opts)
  local buffers = vim.split(opts.args, ", ")      -- Split buffer list
  for _, buf in ipairs(buffers) do
    local sanitized_buf = vim.fn.fnameescape(buf) -- Escape filenames properly
    vim.cmd("bd " .. sanitized_buf)
  end
end, { nargs = "+", complete = "buffer" })
vim.api.nvim_set_keymap('n', '<leader>bdl', 'Bdelete ', { noremap = true, silent = true })



function ToggleVirtualText()
  local current_vt_config = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = not current_vt_config
  })
  if current_vt_config then
    print("Virtual text OFF")
  else
    print("Virtual text ON")
  end
end

vim.api.nvim_set_keymap('n', '<leader>dt', '<cmd> lua ToggleVirtualText()<cr>',
  { desc = 'Toggle Virtual Text', noremap = true, silent = true })


-- Uses the clipboard and the register 'k' to create a Markdown reference link at
-- the bottom of the buffer
-- e.g.
-- [<content of register k>]: <content of the clipboard>
function Add_reference_link()
  -- Step 1: Get the description from the 'k' register and the URL from the default register
  local description = vim.fn.getreg('k')
  local url = get_clipboard()
  url = url:gsub("[\n\r]", "") -- Strip newlines from the URL

  -- Step 2: Validate that both the description and the URL are not empty
  if description == "" or url == "" then
    print("Both the 'k' register and the default register must contain content.")
    return
  end

  -- Step 3: Save the current cursor position
  local original_cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Step 4: Format the reference link
  local reference_link = description .. ": " .. url

  -- Step 5: Append the reference link to the bottom of the buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, false, { reference_link })

  -- Step 6: Return the cursor to the original position
  vim.api.nvim_win_set_cursor(0, original_cursor_pos)

  -- Step 7: Notify the user
  print("+" .. reference_link)
end

-- Optional: Map the function to a key
vim.api.nvim_set_keymap('n', '<leader>ra', '<cmd>lua Add_reference_link()<CR>', { noremap = true, silent = true })


local function add_square_brackets(line)
  return line:gsub("^%s*([*-])%s*(.*)$", "%1 [ ] %2")
end

-- Create a taskwarrior task from the current line content
local function taskwarrior_task(project)
  -- Get the current line number and the line content
  local line_number = vim.fn.line('.')
  local line_content = vim.fn.getline(line_number)
  local task_content = add_square_brackets(line_content)

  -- Append the string to the current line
  local new_line = task_content .. " -- pro:" .. project .. " #W:"
  vim.fn.setline(line_number, new_line)
end

vim.api.nvim_create_user_command('TaskWarriorTask', function(opts)
  taskwarrior_task(opts.args)
end, { nargs = 1 })

vim.api.nvim_set_keymap('n', '<leader>tw', ':TaskWarriorTask ', { noremap = true, silent = true })


local function refile_done()
  local ME = os.getenv("ME")
  local src = string.format("%s/Orgmode/ReadItLater.org", ME)
  local dst = string.format("%s/Orgmode/ReadItLater_archive.org", ME)
  local command = string.format("python ~/workspace/script-fu/refile_done.py %s %s", src, dst)
  local result = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    print("Error: " .. result)
  else
    print(result)
  end

  src = string.format("%s/Orgmode/Orgmode.org", ME)
  dst = string.format("%s/Orgmode/Orgmode_archive.org", ME)
  command = string.format("python ~/workspace/script-fu/refile_done.py %s %s", src, dst)
  result = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    print("Error: " .. result)
  else
    print(result)
  end
  vim.api.nvim_command('edit!') -- Reload the buffer
end
vim.api.nvim_create_user_command('RefileDone', refile_done, {})


local function insert_date_header()
  local formatted_date = os.date("* _%A %d %B_:")

  -- Insert the formatted date at the current cursor position
  vim.api.nvim_put({ formatted_date }, "c", false, true)
end

-- Bind the function to a command (Optional)
vim.api.nvim_create_user_command('InsertDateHeader', insert_date_header, {})
vim.api.nvim_set_keymap('n', '<leader>idh', '<cmd>InsertDateHeader<cr>', { noremap = true, silent = true, desc = '[I]nsert [D]ate [H]eader' })



function Yank_inbracket()
  vim.api.nvim_feedkeys('vi]y', 'n', true)
end

function Select_inbracket()
  vim.api.nvim_feedkeys('vi]', 'n', true)
end

vim.api.nvim_set_keymap('n', '<leader><leader>3', '<cmd>lua Select_inbracket()<CR>', { noremap = true, silent = false })

function Select_outbracket()
  vim.api.nvim_feedkeys('va]', 'n', true)
end

vim.api.nvim_set_keymap('n', '<leader>3', '<cmd>lua Select_outbracket()<CR>', { noremap = true, silent = false })


-- Open_url_from_selected_text searches for lines matching the format:
-- [<selected text>]: <url>
-- If it can find it, it opens the link in the browser
function Open_markdown_reference_url()
  -- Step 1: Capture the text inside square brackets
  local selected_text = get_text_inside_brackets()

  -- Ensure the text is properly quoted for Ripgrep
  local search_pattern = vim.fn.shellescape("^\\[" .. selected_text .. "\\]: https://.*$")
  local search_command = "rg -e " .. search_pattern .. " ."
  print(search_command)

  local result = vim.fn.systemlist(search_command)
  if #result == 0 then
    print("No matches")
    return
  end
  vim.ui.select(result, { prompt = "Choose one:" }, function(choice)
    if choice then
      local url = choice:match("https://%S+")
      if url then
        local open_command = "xdg-open " .. vim.fn.shellescape(url)
        print("opening " .. url)
        os.execute(open_command)
      end
    else
      if choice ~= nil then
        print("cannot open choice: " .. choice[1])
      else
        print("cannot open choice")
      end
      return
    end
  end)
end

-- Map the function to a key in visual mode
vim.api.nvim_set_keymap('n', '<leader>1', '<cmd>lua Open_markdown_reference_url()<CR>',
  { noremap = true, silent = true, desc = 'find Markdown reference link for the text in clipboard' })

function Get_Smart_Weblink()
  local target_text = get_text_inside_brackets()
  print(target_text)

  local tokens = vim.split(target_text, " ")
  print(vim.inspect(tokens))    -- Use vim.inspect for better output

  local org_project = tokens[1] -- Lua lists are 1-based
  local number = ""
  local base_url = ""
  if #(tokens) == 2 then
    if string.match(tokens[2], "PR") then
      number = tokens[2]:gsub("PR", "")
      base_url = "https://github.com/" .. org_project .. "/pull/" .. number
    elseif string.match(tokens[2], "I") then
      number = tokens[2]:gsub("I", "")
      base_url = "https://github.com/" .. org_project .. "/issues/" .. number
    elseif string.match(tokens[2], "MR") then
      number = tokens[2]:gsub("MR", "")
      base_url = "https://gitlab.cee.redhat.com" .. org_project .. "/-/merge_requests/" .. number
    end
  end

  if base_url == "" then
    -- No PR, nor MR, maybe a Jira ticket?
    base_url = "https://issues.redhat.com/browse/" .. target_text
  end
  vim.fn.system('echo "' .. base_url .. '" | wl-copy')
  return base_url
end

vim.api.nvim_set_keymap('n', '<leader>4', '<cmd>lua Get_Smart_Weblink()<CR>', { noremap = true, silent = false })

function Goto_Weblink()
  local base_url = Get_Smart_Weblink()
  local command = "xdg-open " .. base_url

  print(command)
  vim.fn.system(command)
end

vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua Goto_Weblink()<CR>', { noremap = true, silent = false })


function ReplaceSpacesWithHypens()
  local clipboard = get_clipboard()
  local replaced_text = string.gsub(clipboard, " ", "-")
  local pos = vim.fn.getpos('.')
  vim.fn.setline(pos[2], replaced_text)
  print(replaced_text)
end

-- key mapping for the above function in normal mode
vim.api.nvim_set_keymap('n', '<leader>rs', '<cmd>lua ReplaceSpacesWithHypens()<CR>',
  { noremap = true, silent = true, desc = 'Replace space with Hyphens in the clipboard text' })



function CreateNoteFromFileName()
  -- if filename starts with a date, then the title is the same date with the format "Mon 12 Jan 2021 Week02"
  -- otherwise, the title is the filename without the extension
  local filename = vim.fn.expand("%:t:r")
  local title = filename
  -- template for weekly notes
  if string.match(filename, "^%d%d%d%d%-%d%d%-%d%d") then
    -- Only for Work notes
    if vim.fn.isdirectory('Resources') ~= 0 then
      local year = string.sub(filename, 1, 4)
      local month = string.sub(filename, 6, 7)
      local day = string.sub(filename, 9, 10)
      -- change Locale to English only for the following command
      os.setlocale("C")
      -- re-format the date as in "Mon 12 Jan 2021 Week02"
      title = tostring(os.date("Week %V", os.time({ year = year, month = month, day = day })))
      -- read the rest of the template from the journaling template
      local template = vim.fn.readfile("./Templates/weekly-template.md")

      -- write the template in current buffer
      vim.fn.append(1, template)
    end
  end
  -- template for files in Task folder
  if string.match(vim.fn.expand("%:p:h"), "Tasks") then
    -- read the template from the task template
    local template = vim.fn.readfile("./Templates/task-template.md")
    -- write the template in current buffer
    vim.fn.append(1, template)
  end

  -- write the title and reference in current buffer
  vim.fn.append(0, '# ' .. title)
  vim.fn.append(1, '```')
  vim.fn.append(2, os.date('Created: %Y-%m-%d'))
  vim.fn.append(3, '```')
  vim.fn.append(4, '')
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { '<!-- references -->' })
end

vim.api.nvim_create_user_command('NoteFromFilename', function() CreateNoteFromFileName() end, { nargs = 0 })
vim.api.nvim_set_keymap('n', '<leader>mn', "<cmd>lua CreateNoteFromFileName()<cr>", { noremap = true, silent = true })


function Letsdo_goto()
  local task_description = get_clipboard()
  local command = 'letsdo-taskwarrior-task.sh "' .. task_description .. '"'

  print(vim.inspect(vim.fn.system(command)))
end

vim.api.nvim_set_keymap('n', '<leader>ldb', '<cmd>lua Letsdo_goto()<CR>',
  { desc = "Lets do begin", noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>lds', ':!lets stop<CR>', { desc = "Lets stop", noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>ldc', ':!lets cancel<CR>', { desc = "Lets cancel", noremap = true, silent = false })

function QuickNote()
  local command = 'neovim-quick-note.sh'
  print(vim.inspect(vim.fn.system(command)))
end

vim.api.nvim_set_keymap('n', '<leader>qn', "<cmd>lua QuickNote()<cr>", { noremap = true, silent = true })

function QuickTask()
  local command = 'taskwarrior-quick-task.sh'
  print(vim.inspect(vim.fn.system(command)))
end

vim.api.nvim_set_keymap('n', '<leader>qt', "<cmd>lua QuickTask()<cr>", { noremap = true, silent = true })





-- key mapping to stop the current running "letsdo" command
vim.api.nvim_set_keymap('n', '<leader>ls', '<cmd>!lets stop<cr>', { noremap = true, silent = true })
-- key mapping to show letsdo completed sessions (append a search query to the below command or enter to show today's
-- sessions)
vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>!lets see --ascii<cr>', { noremap = true, silent = true })


function Get_title_from_url()
  -- Get the URL from the selection
  local url = vim.fn.getreg(vim.fn.visualmode())
  -- Get the title of the page from the URL
  -- wget -qO- "$1" | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' | recode html..ascii 2>/dev/null
  local get_page = 'wget -qO- ' .. vim.fn.shellescape(url)
  local extract_title = "perl -l -0777 -ne 'print $1 if /<title.*?>\\s*(.*?)\\s*<\\/title/si'"
  local escape_title = 'recode html..ascii 2>/dev/null'
  local command = get_page .. '|' .. extract_title .. '|' .. escape_title
  local title = vim.fn.system(command)
  if title == '' then
    print("can't get the title", title)
    return
  end
  -- Remove trailing whitespace, including null characters and newline
  title = title:gsub('%s*$', '')
  -- Paste the title after the cursor on the same line
  local pos = vim.fn.getpos('.')
  vim.fn.append(pos[2], title)
end

vim.api.nvim_set_keymap('v', '<leader>gt', '<cmd>lua Get_title_from_url()<cr>', { noremap = true, silent = true })

function Markdown_link_from_url()
  -- Get the URL from the selection
  local url = vim.fn.getreg(vim.fn.visualmode())
  -- Get the title of the page from the URL
  -- wget -qO- "$1" | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' | recode html..ascii 2>/dev/null
  local get_page = 'wget -qO- ' .. vim.fn.shellescape(url)
  local extract_title = "perl -l -0777 -ne 'print $1 if /<title.*?>\\s*(.*?)\\s*<\\/title/si'"
  local escape_title = 'recode html..ascii 2>/dev/null'
  local command = get_page .. '|' .. extract_title .. '|' .. escape_title
  local title = vim.fn.system(command)
  if title == '' then
    print("can't get the title")
    return
  end
  -- Remove trailing whitespace, including null characters and newline
  title = title:gsub('%s*$', '')
  url = url:gsub('%s*$', '')
  -- Paste the title after the cursor on the same line
  local link = '[' .. title .. '](' .. url .. ')'
  -- replace current selection and replace it with the link
  local pos = vim.fn.getpos('.')
  vim.fn.setline(pos[2], link)
end

-- link title
vim.api.nvim_set_keymap('v', '<leader>lt', '<cmd>lua Markdown_link_from_url()<cr>', { noremap = true, silent = true })

-- SurroundWithMarkdownLink add [[]] around the selected text AND creates the file if it doesn't exist
function CreateFileAndWikiLink()
  -- Get the visual selection
  local line1, col1 = unpack(vim.fn.getpos("'<"), 2, 3)
  local line2, col2 = unpack(vim.fn.getpos("'>"), 2, 3)
  local lines = vim.fn.getline(line1, line2)
  if #lines == 1 then
    lines[1] = lines[1]:sub(col1, col2)
  else
    lines[1] = lines[1]:sub(col1)
    lines[#lines] = lines[#lines]:sub(1, col2)
  end
  local selected_text = table.concat(lines, "\n")

  -- Replace the selected text with `[[selected_text]]`
  local modified_text = "[[" .. selected_text .. "]]"
  vim.fn.setline(line1, vim.fn.getline(line1):sub(1, col1 - 1) .. modified_text .. vim.fn.getline(line2):sub(col2 + 1))

  -- Check if the file exists already
  local filename = selected_text .. '.md'
  local result = vim.fs.find(filename, { type = 'file', limit = 1 })
  if #result ~= 0 then
    print("File " .. filename .. " exists already")
  else
    print("File " .. filename .. " does not exist")
    -- Create a Markdown file in the Resources directory
    local filepath = ""
    if vim.fn.isdirectory('3-Resources') ~= 0 then
      filepath = "3-Resources/" .. filename
    elseif vim.fn.isdirectory('Resources') ~= 0 then
      filepath = "Resources/" .. filename
    else
      print("Error: Neither '3-Resources/' nor 'Resources/' directory found. Cannot create file.")
      return
    end

    local file = io.open(filepath, "w")
    if file then
      file:close()
      print("Created Markdown file: " .. filepath)
    else
      print("Failed to create file: " .. filepath)
    end
  end
end

function AppendOutlineReference()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local uuid = vim.fn.system("uuidgen")
  uuid = uuid:gsub("[\n\r]", "") -- Remove newline/carriage return from uuidgen output
  -- Neovim recognize tags only if they start with an alphabet character. Prepending "nor" (Note Outline Ref)
  local new_text = ' [[][ #nor-' .. uuid .. ' ]]'
  local new_line = line .. new_text
  vim.api.nvim_set_current_line(new_line)
  -- Position cursor inside '#' followed by the UUID
  vim.api.nvim_win_set_cursor(0, { row, #line + 7 })
end

vim.api.nvim_set_keymap('n', '<leader>noa', '<cmd>lua AppendOutlineReference()<CR>',
  { desc = '[N]ote [O]utline [A]ppend reference', noremap = true, silent = true })

return M
