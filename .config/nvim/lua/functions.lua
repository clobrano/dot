local function get_clipboard()
  return vim.fn.getreg('+')
end


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
  print("Reference link saved: " .. reference_link)
end

-- Optional: Map the function to a key
vim.api.nvim_set_keymap('n', '<leader>ra', '<cmd>lua Add_reference_link()<CR>', { noremap = true, silent = true })


local function taskwarrior_task(project)
  -- Get the current line number and the line content
  local line_number = vim.fn.line('.')
  local line_content = vim.fn.getline(line_number)

  -- Append the string to the current line
  local new_line = line_content .. " -- pro:" .. project .. " #W"
  vim.fn.setline(line_number, new_line)
end

vim.api.nvim_create_user_command('TaskWarriorTask', function(opts)
  taskwarrior_task(opts.args)
end, { nargs = 1 })


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

function Open_url_from_selected_text()
  -- Step 1: Capture the clipboard
  local selected_text = get_clipboard()

  -- Step 2: Search for matches in the current working directory
  local search_command = "rg --vimgrep '^" .. vim.fn.escape(selected_text, "[]") .. ": https://.*$' ."
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
    print("No matching URLs found for '".. selected_text .. "'")
    return
  end

  -- Step 4: If there are multiple matches, let the user choose
  local chosen_url
  if #matches == 1 then
    chosen_url = matches[1].url
  else
    print("Multiple matches found:")
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
    local open_command = "xdg-open " .. chosen_url
    os.execute(open_command)
  end
end

-- Map the function to a key in visual mode
vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua Open_url_from_selected_text()<CR>', { noremap = true, silent = true })


function Goto_Weblink()
  -- Get the PR ID from clipboard
  -- yank text inside square brakets (to get substrings like [MDR-PR123])
  --Yank_inbracket()
  local clipboard = get_clipboard()

  -- PR ID is expected to be "<Project-ShortName>-PR<number>"
  local github = {
    MDR = "https://github.com/medik8s/machine-deletion-remediation",
    SNR = "https://github.com/medik8s/self-node-remediation",
    NHC = "https://github.com/medik8s/node-healthcheck-operator",
    NMO = "https://github.com/medik8s/node-maintenance-operator",
    FAR = "https://github.com/medik8s/fence-agents-remediation",
    DOT_GITHUB = "https://github.com/medik8s/.github",
    M8S_GITHUB = "https://github.com/medik8s/.github",
    M8S_TOOLS = "https://github.com/medik8s/tools",
  }

  local gitlab = {
    MDR = "https://gitlab.cee.redhat.com/dragonfly/machine-deletion-remediation",
    SNR = "https://gitlab.cee.redhat.com/dragonfly/self-node-remediation",
    NHC = "https://gitlab.cee.redhat.com/dragonfly/node-healthcheck-operator",
    NMO = "https://gitlab.cee.redhat.com/dragonfly/node-maintenance-operator",
    FAR = "https://gitlab.cee.redhat.com/dragonfly/fence-agents-remediation",
  }

  local tokens = vim.split(clipboard, "-")
  print(vim.inspect(tokens))   -- Use vim.inspect for better output

  local short_name = tokens[1] -- Lua lists are 1-based
  local number = ""
  local base_url = ""
  if string.match(tokens[2], "PR") then
    number = tokens[2]:gsub("PR", "")
    base_url = github[short_name] .. "/pull/" .. number
  elseif string.match(tokens[2], "I") then
    number = tokens[2]:gsub("I", "")
    base_url = github[short_name] .. "/issues/" .. number
  elseif string.match(tokens[2], "MR") then
    number = tokens[2]:gsub("MR", "")
    base_url = gitlab[short_name] .. "/-/merge_requests/" .. number
  else
    --print("No PR, nor MR, maybe a Jira ticket?")
    base_url = "https://issues.redhat.com/browse/" .. clipboard
  end
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
  -- write the title in current buffer
  vim.fn.append(0, '# ' .. title)
end

vim.api.nvim_set_keymap('n', '<leader>mn', "<cmd>lua CreateNoteFromFileName()<cr>", { noremap = true, silent = true })


function Letsdo_goto()
  local project = get_project_name_from_buffer()
  local task_description = get_clipboard()

  if project ~= '' then
    task_description = task_description .. ' ' .. '@' .. project
  end

  local command = 'lets goto ' .. vim.fn.shellescape(task_description)
  print(command, vim.inspect(vim.fn.system(command)))
end

vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua Letsdo_goto()<CR>', { noremap = true, silent = false })

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
  print(search_link)
end


-- use require('telescope.builtin').live_grep to search currently selected text
M.searchSelectedText = function()
  -- Get selected text
  local selected_text = vim.fn.getreg(vim.fn.visualmode())
  -- Replace the original text with the replaced text
  require('telescope.builtin').live_grep({ search = selected_text })
end


return M
