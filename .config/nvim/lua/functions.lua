local function get_clipboard()
  return vim.fn.getreg('+')
end


function get_text_inside_brackets()
    local line = vim.fn.getline(".")  -- Get the current line
    local col = vim.fn.col(".")       -- Get the current column position

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

    return nil  -- Return nil if no matching brackets are found
end



-- Move the cursor inside a rounded brackets with the task uuid "some task (12345)"
-- the function will get the uuid and jump to the file(s) where the corresponding
-- Taskwarrior task object is defined
function SearchTaskDefinition()
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
        print("No match found: ".. result[1])
    end
end

vim.api.nvim_set_keymap("n", "<leader>fT", ":lua SearchTaskDefinition()<CR>", { noremap = true, silent = true })


-- Add one hashtag '#' at the beginning of the current line
function AddMarkdownHeader()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- Get cursor position
  local line = vim.api.nvim_get_current_line() -- Get current line content
  vim.api.nvim_set_current_line('#' .. line) -- Prepend #
  vim.api.nvim_win_set_cursor(0, { row, col + 1 }) -- Adjust cursor position
end

-- Remove one hashtag '#' from the beginning of the current line
function RemoveMarkdownHeader()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- Get cursor position
  local line = vim.api.nvim_get_current_line() -- Get current line content

  -- Remove leading "#" only if it exists
  if line:sub(1, 1) == '#' then
    vim.api.nvim_set_current_line(line:sub(2)) -- Remove first character
    vim.api.nvim_win_set_cursor(0, { row, math.max(0, col - 1) }) -- Adjust cursor position
  end
end

-- Key mappings in insert mode
vim.api.nvim_set_keymap('n', '<C-i>', '<Cmd>lua AddMarkdownHeader()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<Cmd>lua RemoveMarkdownHeader()<CR>', { noremap = true, silent = true })


-- Wrap the selected text in tryple backtics with the option to add the quote type (e.g. go, bash, ...)
function wrap_with_triple_backticks()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  vim.ui.input({ prompt = "Enter code language: " }, function(lang)
    local opening_backticks = lang and lang ~= "" and "```" .. lang or "```"
    vim.api.nvim_buf_set_lines(0, end_line, end_line, false, {'```'})
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, {opening_backticks})
  end)
end

vim.api.nvim_set_keymap('v', '<leader>`', ":lua wrap_with_triple_backticks()<CR>", { noremap = true, silent = true })


-- Move the cursor in a Mermaid section, the function will create the SVG
vim.api.nvim_create_user_command("MermaidCreateSVG", function(opts)
  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = current_pos[1]
  local col_num = current_pos[2]

  -- Find the start and end of the Mermaid code block
  local start_line, end_line = nil, nil
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of the Mermaid code block
  for i = line_num, 1, -1 do
    if lines[i]:match("```mermaid") then
      start_line = i
      break
    end
  end

  -- Find end of the Mermaid code block
  for i = line_num, #lines do
    if lines[i]:match("```") then
      end_line = i
      break
    end
  end

  -- If we found a valid range, proceed with copying
  if start_line and end_line then
    -- Get the lines of Mermaid code
    local mermaid_code = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)

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
  local buffers = vim.split(opts.args, ", ")  -- Split buffer list
  for _, buf in ipairs(buffers) do
    local sanitized_buf = vim.fn.fnameescape(buf)  -- Escape filenames properly
    vim.cmd("bd " .. sanitized_buf)
  end
end, { nargs = "+", complete = "buffer" })
vim.api.nvim_set_keymap('n', '<leader>bdl', 'Bdelete ', { noremap = true, silent = true })



local function ToggleVirtualText()
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
vim.api.nvim_create_user_command('ToggleVirtualText', ToggleVirtualText, {})


-- Uses the clipboard and the register 'k' to create a Markdown reference link at
-- the bottom of the buffer
-- e.g.
-- [<content of register k>]: <content of the clipboard>
function Add_reference_link()
  -- Step 1: Get the description from the 'k' register and the URL from the default register
  local description = vim.fn.getreg('k')
  local url = get_clipboard()

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
end
vim.api.nvim_create_user_command('RefileDone', refile_done, {})

-- Function to insert the date in the format 'yyyy-mm-dd DDD'
local function insert_date()
  -- Get the current date
  local date = os.date("%Y-%m-%d")      -- yyyy-mm-dd format
  local weekday = os.date("%a"):upper() -- Weekday short name (e.g. 'THU')

  -- Concatenate the date and the weekday
  local formatted_date = date .. " " .. weekday

  -- Insert the formatted date at the current cursor position
  vim.api.nvim_put({ formatted_date }, "c", false, true)
end

-- Bind the function to a command (Optional)
vim.api.nvim_create_user_command('InsertDate', insert_date, {})
vim.api.nvim_set_keymap('n', '<leader>id', '<cmd>lua insert_date()<CR>', { noremap = true, silent = false })

local function insert_date_header()
  -- Get the current date
  local date = os.date("## %Y-%m-%d")      -- yyyy-mm-dd format
  local weekday = os.date("%a"):upper() -- Weekday short name (e.g. 'THU')

  -- Concatenate the date and the weekday
  local formatted_date = date .. " " .. weekday

  -- Insert the formatted date at the current cursor position
  vim.api.nvim_put({ formatted_date }, "c", false, true)
end

-- Bind the function to a command (Optional)
vim.api.nvim_create_user_command('InsertDateHeader', insert_date_header, {})



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
function Open_url_from_markdown_reference()
  -- Step 1: Capture the text inside square brackets
  local selected_text = get_text_inside_brackets()

  -- Ensure the text is properly quoted for Ripgrep
  local search_pattern = vim.fn.shellescape("^\\[" .. selected_text .. "\\]: https://.*$")
  local search_command = "rg -e " .. search_pattern .. " ."

  local handle = io.popen(search_command)
  if handle == nil then
    print("command returned nil handle: " .. search_command)
    return
  end
  local result = handle:read("*a")
  handle:close()

  -- Step 3: Parse the result, find URLs
  local matches = {}
  for line in result:gmatch("[^\r\n]+") do
    local url = line:match("https://%S+")
    if url then
      table.insert(matches, {line = line, url = url})
    end
  end

  if #matches == 0 then
    print("No matching URLs found for '" .. selected_text .. "'")
    return
  end

  -- Step 4: If there are multiple matches, let the user choose
  local chosen_url
  if #matches == 1 then
    chosen_url = matches[1].url
  else
    for i, match in ipairs(matches) do
      print(i .. ": " .. match.line)
    end
    local choice = tonumber(vim.fn.input("Choose a match number: "))
    if choice and matches[choice] then
      chosen_url = matches[choice].url
    else
      print("Invalid choice.")
      return
    end
  end

  -- Step 5: Open the chosen URL in the browser
  if chosen_url then
    local open_command = "xdg-open " .. vim.fn.shellescape(chosen_url)
    print("opening " .. chosen_url)
    os.execute(open_command)
  end
end


-- Map the function to a key in visual mode
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua Open_url_from_markdown_reference()<CR>', { noremap = true, silent = true, desc = 'find Markdown reference link for the text in clipboard' })

function Get_Smart_Weblink()
  local clipboard = get_text_inside_brackets()
  print(clipboard)

  -- PR ID is expected to be "<Project-ShortName> PR<number>"
  local github = {
    OCP_RELEASE = "https://github.com/openshift/release",
    MDR = "https://github.com/medik8s/machine-deletion-remediation",
    SNR = "https://github.com/medik8s/self-node-remediation",
    NHC = "https://github.com/medik8s/node-healthcheck-operator",
    NMO = "https://github.com/medik8s/node-maintenance-operator",
    FAR = "https://github.com/medik8s/fence-agents-remediation",
    DOT_GITHUB = "https://github.com/medik8s/.github",
    M8S_GITHUB = "https://github.com/medik8s/.github",
    M8S_TOOLS = "https://github.com/medik8s/tools",
    CEO = "https://github.com/openshift/cluster-etcd-operator"
  }

  local gitlab = {
    MDR = "https://gitlab.cee.redhat.com/dragonfly/machine-deletion-remediation",
    SNR = "https://gitlab.cee.redhat.com/dragonfly/self-node-remediation",
    NHC = "https://gitlab.cee.redhat.com/dragonfly/node-healthcheck-operator",
    NMO = "https://gitlab.cee.redhat.com/dragonfly/node-maintenance-operator",
    FAR = "https://gitlab.cee.redhat.com/dragonfly/fence-agents-remediation",
    TnoOperator = "https://gitlab.cee.redhat.com/msluiter/tno-operator"
  }

  local tokens = vim.split(clipboard, " ")
  print(vim.inspect(tokens))   -- Use vim.inspect for better output

  local short_name = tokens[1] -- Lua lists are 1-based
  local number = ""
  local base_url = ""
  if #(tokens) == 2 then
    if string.match(tokens[2], "PR") then
      number = tokens[2]:gsub("PR", "")
      base_url = github[short_name] .. "/pull/" .. number
    elseif string.match(tokens[2], "I") then
      number = tokens[2]:gsub("I", "")
      base_url = github[short_name] .. "/issues/" .. number
    elseif string.match(tokens[2], "MR") then
      number = tokens[2]:gsub("MR", "")
      base_url = gitlab[short_name] .. "/-/merge_requests/" .. number
    end
  end

  if base_url == "" then
    -- No PR, nor MR, maybe a Jira ticket?
    base_url = "https://issues.redhat.com/browse/" .. clipboard
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

vim.api.nvim_set_keymap('n', '<leader>1', '<cmd>lua Goto_Weblink()<CR>', { noremap = true, silent = false })

-- Function to find and extract the project name from the current buffer
local function get_project_name_from_buffer()
  -- Get the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get all lines in the buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Iterate through each line
  for _, line in ipairs(lines) do
    -- Check if the line starts with "project:"
    local project_prefix = "project:"
    if line:sub(1, #project_prefix) == project_prefix then
      -- Extract the name following "project:"
      local name = line:sub(#project_prefix + 1):match("^%s*(.-)%s*$")
      -- Return the trimmed name
      return name
    end
  end

  -- If no project tag is found, get the filename if from Tasks folder
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if string.match(vim.fn.expand("%:p:h"), "Tasks") then
    filename = vim.fn.fnamemodify(filename, ":t:r") -- Get the base name of the file

    -- Return the filename
    return filename
  end

  return ""
end

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
    local year = string.sub(filename, 1, 4)
    local month = string.sub(filename, 6, 7)
    local day = string.sub(filename, 9, 10)
    -- change Locale to English only for the following command
    os.setlocale("C")
    -- re-format the date as in "Mon 12 Jan 2021 Week02"
    title = os.date("Week %V", os.time({ year = year, month = month, day = day }))
    -- read the rest of the template from the journaling template
    local template = vim.fn.readfile("./Templates/weekly-template.md")
    -- write the template in current buffer
    vim.fn.append(1, template)
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
  vim.fn.append(1, os.date('created: %Y-%m-%d'))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {'<!-- references -->'})

end

vim.api.nvim_create_user_command('NoteFromFilename', function() CreateNoteFromFileName() end, { nargs = 0 })
vim.api.nvim_set_keymap('n', '<leader>mn', "<cmd>lua CreateNoteFromFileName()<cr>", { noremap = true, silent = true })


function Letsdo_goto()
  --local project = get_project_name_from_buffer()
  local task_description = get_clipboard()
  local command = 'letsdo-taskwarrior-task.sh "' .. task_description .. '"'

  print(vim.inspect(vim.fn.system(command)))
end
vim.api.nvim_set_keymap('n', '<leader>ldb', '<cmd>lua Letsdo_goto()<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>lds', ':!lets stop<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>ldc', ':!lets cancel<CR>', { noremap = true, silent = false })

function QuickNote(description)
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
function SurroundWithMarkdownLink()
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
  local command = { "find", ".", "-type", "f", "-name", filename, "grep", filename }
  local result = vim.system(command, { text = true } ):wait()
  if result.code == 0 then
    print("File " .. filename .. " exists already")
  else
    print("File " .. filename .. " does not exist (" .. result.code .. ")")
    -- Create a Markdown file in the Resources directory
    local filepath = "Resources/" .. selected_text .. ".md"
    if vim.fn.isdirectory('Resources') == 0 then
      -- Personal notes have a different destination name
      filepath = "3-Resources/" .. selected_text .. ".md"
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


local M = {}

M.current_theme = 'catppuccin-frappe' -- Set the default theme as 'dracula'
M.dark_theme = 'catppuccin-frappe'
M.light_theme = 'melange'
M.font_size = 'h11.5'

M.toggle_theme = function()
  if M.current_theme == M.dark_theme then
    vim.cmd('colorscheme ' .. M.light_theme)
    vim.cmd('ListcharsDisable')
    vim.o.background = 'light'
    vim.cmd('set guifont=FiraCode\\ Nerd\\ Font\\ Mono:' .. M.font_size)
    M.current_theme = M.light_theme
  else
    vim.cmd('colorscheme ' .. M.dark_theme)
    vim.o.background = 'dark'
    vim.cmd('ListcharsEnable')
    vim.cmd('set guifont=Source\\ Code\\ Pro:' .. M.font_size)
    M.current_theme = M.dark_theme
  end
end

-- Function to execute and paste result
M.executeAndPaste = function(command)
  -- Save cursor position
  local save_cursor = vim.fn.getpos('.')

  -- Execute your function (replace 'your_function()' with the actual function)
  local result = vim.fn.system(command)

  -- Remove trailing whitespace, including null characters
  result = result:gsub('%s*$', '')
  -- Paste the result after the cursor on the same line
  vim.fn.setline('.', vim.fn.getline('.') .. result)

  -- Restore cursor position
  vim.fn.setpos('.', save_cursor)
end

M.makeGmailSearchLink = function()
  -- Get selected text
  local selected_text = get_clipboard()
  -- Replace spaces with '+' in the selected text
  local replaced_text = string.gsub(selected_text, " ", "+")
  -- Replace the original text with the replaced text
  local search_link = "#email [" ..
      selected_text .. "]" .. "(https://mail.google.com/mail/u/0/#search/" .. replaced_text .. ")"
  local pos = vim.fn.getpos('.')
  vim.fn.setline(pos[2], search_link)
end


-- use require('telescope.builtin').live_grep to search currently selected text
M.searchSelectedText = function()
  -- Get selected text
  local selected_text = vim.fn.getreg(vim.fn.visualmode())
  -- Replace the original text with the replaced text
  require('telescope.builtin').live_grep({ search = selected_text })
end


return M
