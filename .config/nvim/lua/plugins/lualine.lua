local function spell()
  if vim.wo.spell == true then -- Note that 'spell' is a window option, so: wo
    return '[' .. vim.bo.spelllang .. ']'
  end
  return ''
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '\\', right = '/'},
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = {'branch'},
            lualine_b = { {'filename', path = 1} },
            lualine_c = {},
            lualine_x = {'diff', 'diagnostics', spell},
            lualine_y = {'progress', 'searchcount'},
            lualine_z = {'location'}
        },
    },
}
