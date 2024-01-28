local M = {}

M.current_theme = 'dracula' -- Set the default theme as 'dracula'
M.dark_theme = 'dracula'
M.light_theme = 'melange'
M.font_size = 'h11'

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
M.executeAndPaste = function (command)
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

vim.api.nvim_set_keymap('n', '<leader>mr', "<cmd>lua CreateMarkdownFileWithTitle('Resources')<cr>", { noremap = true, silent = true })

function CreateNoteFromFileName()
    -- if filename starts with a date, then the title is the same date with the format "Mon 12 Jan 2021 Week02"
    -- otherwise, the title is the filename without the extension
    local filename = vim.fn.expand("%:t:r")
    local title = filename
    if string.match(filename, "^%d%d%d%d%-%d%d%-%d%d") then
        year = string.sub(filename, 1, 4)
        month = string.sub(filename, 6, 7)
        day = string.sub(filename, 9, 10)
        -- change Locale to English only for the following command
        os.setlocale("C")
        -- re-format the date as in "Mon 12 Jan 2021 Week02"
        title = os.date("%a %d %b %Y W%V", os.time({year=year, month=month, day=day}))
        -- read the rest of the template from "./Templates/daily-template.md"
        local template = vim.fn.readfile("./Templates/daily-template.md")
        -- write the template in current buffer
        vim.fn.append(1, template)
    end
    -- write the title in current buffer
    vim.fn.append(0, '# ' .. title)
end
vim.api.nvim_set_keymap('n', '<leader>mn', "<cmd>lua CreateNoteFromFileName()<cr>", { noremap = true, silent = true })

function createMarkdownLink()
    -- Get the link URL from the clipboard
    local link_url = vim.fn.trim(vim.fn.getreg('"'))

    -- Find the lowest available link number
    local link_number = 1
    while vim.fn.search(string.format("\\[%d\\]:", link_number), "nw") > 0 do
        link_number = link_number + 1
    end

    -- Append link number to the current word
    vim.api.nvim_put({string.format("[%d]", link_number)}, 'c', true, true)

    -- Move the cursor at the bottom of the page
    vim.cmd("normal! G")

    -- Insert the link reference at the end of the buffer
    vim.api.nvim_put({string.format("[%d]: %s", link_number, link_url)}, 'l', true, true)

    -- Move the cursor at back to the previous position and center the screen
    vim.cmd("normal! ''zz")
end

-- Map a key to trigger the function in visual mode
vim.api.nvim_set_keymap('n', '<leader>ml', "<cmd>lua createMarkdownLink()<cr>", { noremap = true, silent = true })

function letsdo_current_line()
    -- Get the current line content from cursor to end
    local line_content = vim.fn.trim(vim.fn.getline('.'):sub(vim.fn.col('.')))

    -- Run the "letsdo" command with the line content as input
    local command = 'lets goto ' .. vim.fn.shellescape(line_content)
    vim.fn.system(command)
end

-- key mapping for the above function in normal mode
vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua letsdo_current_line()<CR>', { noremap = true, silent = true })

function letsdo_visual_selection()
    -- Get the currently selected text
    local selected_text = vim.fn.getreg(vim.fn.visualmode()) 

    -- Run the "letsdo" command with the selected text as input
    local command = 'letsdo ' .. vim.fn.shellescape(selected_text)
    vim.fn.system(command)
end

-- key mapping for the above function in visual mode
vim.api.nvim_set_keymap('v', '<leader>ld', '<cmd>lua letsdo_visual_selection()<CR>', { noremap = true, silent = true })

-- key mapping to stop the current running "letsdo" command
vim.api.nvim_set_keymap('n', '<leader>ls', '<cmd>!lets stop<cr>', { noremap = true, silent = true })
-- key mapping to show letsdo completed sessions (append a search query to the below command or enter to show today's
-- sessions)
vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>!lets see --ascii<cr>', { noremap = true, silent = true })
return M
