return {
  'folke/trouble.nvim',
  --opts = { icons = false, use_diagnostic_signs = true, },
  opts = {},
  cmd = "Trouble",
  keys = {
        {
          "<leader>tp",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>tb",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        --{
          --"<leader>tS",
          --"<cmd>Trouble symbols toggle focus=false<cr>",
          --desc = "Symbols (Trouble)",
        --},
        --{
          --"<leader>tl",
          --"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          --desc = "LSP Definitions / references / ... (Trouble)",
        --},
        --{
          --"<leader>tL",
          --"<cmd>Trouble loclist toggle<cr>",
          --desc = "Location List (Trouble)",
        --},
        --{
          --"<leader>tQ",
          --"<cmd>Trouble qflist toggle<cr>",
          --desc = "Quickfix List (Trouble)",
        --},
      },
}
