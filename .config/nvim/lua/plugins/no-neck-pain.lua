return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  config = function()
    require("no-neck-pain").setup({
      width = 140,
      buffers = {
        right = {
          enabled = false,
        },
        scratchPad = {
          enabled = false,
        },
      },
    })
    vim.keymap.set('n', '<leader>nn', ':NoNeckPain<cr>', { noremap = true, desc = "Toggle NoNeckPain" })

  end
}
