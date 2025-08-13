local function spell()
  if vim.wo.spell == true then -- Note that 'spell' is a window option, so: wo
    return '[' .. vim.bo.spelllang .. ']'
  end
  return ''
end

-- in this lualine configuration file, I want a function
-- that returns the currently configured LLM. This
-- information is available in require('gen').GetLLMModel
-- custom function, but we don't know if when executing this
-- lualine configuration file, the `gen.nvim` configuration
-- from GetLLMModel comes, was already loaded

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '▍', right = '┃' },
      section_separators = { left = '', right = '' },
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'branch' },
      lualine_b = { },
      lualine_c = { },
      lualine_x = { 'diff', 'diagnostics' },
      lualine_y = { spell, 'progress', 'searchcount' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename', 'diff' }, -- Also show filename for inactive windows
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = { 'mode'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'buffers' },
      lualine_z = { 'tabs' }
    },
    extensions = { 'nvim-tree' },
  },
}
