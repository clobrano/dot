return {
  'kdheepak/tabline.nvim',
  config = function()
    require('tabline').setup {
      show_bufnr = true
    }
  end
}
