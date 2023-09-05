return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
        },
        sections = {
            --lualine_a = {'clobrano#status#workingdirectory'},
            lualine_b = {'branch'},
            lualine_c = { {'filename', path = 1} },
            lualine_x = {'diff', 'diagnostics', 'filetype', 'fileformat', 'encoding'},
            lualine_y = {'progress', 'searchcount'},
            lualine_z = {'location'}
        },
    },
}
