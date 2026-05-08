return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    view = {
      merge_tool = {
        layout = "diff4_mixed",
      },
    },
  },
  -- useful default mapping
  -- <leader>b: toggle file view
  -- <leader>e: focus to file view
}
