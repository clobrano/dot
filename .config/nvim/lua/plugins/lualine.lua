local function spell()
  if vim.wo.spell == true then -- Note that 'spell' is a window option, so: wo
    return '[' .. vim.bo.spelllang .. ']'
  end
  return ''
end

return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
        },
        sections = {
            lualine_a = {'branch'},
            lualine_b = { {'filename', path = 1} },
            lualine_c = {},
            lualine_x = {'diff', 'diagnostics', spell, 'filetype', 'fileformat', 'encoding'},
            lualine_y = {'progress', 'searchcount'},
            lualine_z = {'location'}
        },
    },
}
