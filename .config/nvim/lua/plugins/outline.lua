return  {
  "hedyhli/outline.nvim",
  enabled = true,
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>toc", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    -- Your setup opts here
  },
}
