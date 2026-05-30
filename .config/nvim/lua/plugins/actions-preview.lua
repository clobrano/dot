return {
  'aznhe21/actions-preview.nvim',
  config = function()
    require('actions-preview').setup {
      telescope = require('telescope.themes').get_dropdown { winblend = 10 },
    }
  end,
}
