return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" }
  },
  -- https://github.com/deepseek-ai/awesome-deepseek-integration/blob/main/docs/codecompanion.nvim/README.md
  config = function()
    require('codecompanion').setup({
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
      opts = {
        log_level = "DEBUG",
      },
      prompt_library = {
        ["Code Review TBD"] = {
          strategy = "chat",
          description = "review local changes",
          prompts = {
            {
              role = "system",
              content = "You are an experienced developer with Lua and Neovim",
            },
            {
              role = "user",
              content = "Can you explain why ..."
            }
          },
        },
      },

      vim.keymap.set("n", "<leader>Ca", ":CodeCompanionAction<cr>",
        { desc = "[C]odecompanion [A]ction", silent = true, noremap = true }),
    vim.keymap.set("n", "<leader>Cc", ":CodeCompanionChat<cr>",
        { desc = "[C]odecompanion [C]hat", silent = true, noremap = true })

    })
  end
}
