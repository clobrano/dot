return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" }
  },
  opts = {
    --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    strategies = {
      --NOTE: Change the adapter as required
      chat = { adapter = "gemini" },
      inline = { adapter = "gemini" },
    },
    opts = {
      log_level = "DEBUG",
    },
  },
}
