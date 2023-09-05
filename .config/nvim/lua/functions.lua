local M = {}

M.current_theme = 'dracula' -- Set the default theme as 'dracula'

M.toggle_theme = function()
    if M.current_theme == 'dracula' then
        vim.cmd('colorscheme PaperColor')
        vim.o.background = 'light'
        M.current_theme = 'PaperColor'
    else
        vim.cmd('colorscheme dracula')
        vim.o.background = 'dark'
        M.current_theme = 'dracula'
    end
end

return M
