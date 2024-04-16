local function get_visual_selection()
    -- Yank current visual selection into the 'v' register
    --
    -- Note that this makes no effort to preserve this register
    vim.cmd('noau normal! "vy"')
    return vim.fn.getreg('v')
end

function CreateNoteFromFileName()
    -- if filename starts with a date, then the title is the same date with the format "Mon 12 Jan 2021 Week02"
    -- otherwise, the title is the filename without the extension
    local filename = vim.fn.expand("%:t:r")
    local title = filename
    -- template for daily notes
    if string.match(filename, "^%d%d%d%d%-%d%d%-%d%d") then
        local year = string.sub(filename, 1, 4)
        local month = string.sub(filename, 6, 7)
        local day = string.sub(filename, 9, 10)
        -- change Locale to English only for the following command
        os.setlocale("C")
        -- re-format the date as in "Mon 12 Jan 2021 Week02"
        title = os.date("%a %d %b %Y W%V", os.time({ year = year, month = month, day = day }))
        -- read the rest of the template from "./Templates/daily-template.md"
        local template = vim.fn.readfile("./Templates/daily-template.md")
        -- write the template in current buffer
        vim.fn.append(1, template)
    end
    -- template for files in Task folder
    if string.match(vim.fn.expand("%:p:h"), "T") then
        -- read the template from "./Templates/task-template.md"
        local template = vim.fn.readfile("./Templates/task-template.md")
        -- write the template in current buffer
        vim.fn.append(1, template)
    end
    -- write the title in current buffer
    vim.fn.append(0, '# ' .. title)
end

vim.api.nvim_set_keymap('n', '<leader>mn', "<cmd>lua CreateNoteFromFileName()<cr>", { noremap = true, silent = true })


function Letsdo_current_line()
    -- Get the current line content from cursor to end
    local line_content = vim.fn.trim(vim.fn.getline('.'):sub(vim.fn.col('.')))

    -- Run the "letsdo" command with the line content as input
    local command = 'lets goto ' .. vim.fn.shellescape(line_content)
    vim.fn.system(command)
end

-- key mapping for the above function in normal mode
vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua Letsdo_current_line()<CR>', { noremap = true, silent = true })

function Letsdo_visual_selection()
    -- Get the currently selected text
    local selected_text = get_visual_selection()
    local task = selected_text
    local filename = vim.fn.expand("%:t:r")
    if filename ~= selected_text then
        task = filename .. ":" .. selected_text
    end

    -- Run the "letsdo" command with the selected text as input
    local command = 'letsdo goto ' .. vim.fn.shellescape(task)
    vim.fn.system(command)
end

-- key mapping for the above function in visual mode
vim.api.nvim_set_keymap('v', '<leader>ld', '<cmd>lua Letsdo_visual_selection()<CR>', { noremap = true, silent = false })

-- key mapping to stop the current running "letsdo" command
vim.api.nvim_set_keymap('n', '<leader>ls', '<cmd>!lets stop<cr>', { noremap = true, silent = true })
-- key mapping to show letsdo completed sessions (append a search query to the below command or enter to show today's
-- sessions)
vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>!lets see --ascii<cr>', { noremap = true, silent = true })


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

    print(command)
    print(title)
    -- Paste the title after the cursor on the same line
    local link = '[' .. title .. '](' .. url .. ')'
    vim.fn.append(0, link)
end

-- link title
vim.api.nvim_set_keymap('n', '<leader>lt', '<cmd>lua Markdown_link_from_url()<cr>', { noremap = true, silent = true })

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
    local selected_text = get_visual_selection()
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
