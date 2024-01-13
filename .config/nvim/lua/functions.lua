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
    end
end

return M
