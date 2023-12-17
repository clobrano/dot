local M = {}

M.current_theme = 'dracula' -- Set the default theme as 'dracula'

M.toggle_theme = function()
    if M.current_theme == 'dracula' then
        vim.cmd('colorscheme solarized')
        vim.cmd('ListcharsDisable')
        vim.o.background = 'light'
        M.current_theme = 'solarized'
    else
        vim.cmd('colorscheme dracula')
        vim.o.background = 'dark'
        vim.cmd('ListcharsEnable')
        M.current_theme = 'dracula'
    end
end

return M
