return {
  "atiladefreitas/lazyclip",
  enable = true,
  config = function()
    require("lazyclip").setup({
      -- your custom config here (optional)
      vim.keymap.set('n', '<leader>lc', ':LazyClip<cr>', { desc="[L]azy [C]lip Toggle", noremap=true, silent=true })
    })
  end,
  -- Optional: Load plugin when yanking text
  event = { "TextYankPost" },
}
