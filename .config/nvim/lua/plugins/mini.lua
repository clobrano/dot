return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.files').setup({})
    vim.keymap.set('n', '<leader>em', ':lua MiniFiles.open()<cr>', { silent = true, noremap = true })
  end
}
