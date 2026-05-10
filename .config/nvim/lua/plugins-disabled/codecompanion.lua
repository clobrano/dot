return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" }
  },
  -- https://github.com/deepseek-ai/awesome-deepseek-integration/blob/main/docs/codecompanion.nvim/README.md
  config = function()
    require('codecompanion').setup({
      adapters = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = "GEMINI_API_KEY",
            }
          })
        end
      },
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
        cmd = { adapter = "gemini" },
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

      vim.keymap.set("n", "<leader>jca", ":CodeCompanionAction<cr>",
        { desc = "[C]odecompanion [A]ction", silent = true, noremap = true }),
      vim.keymap.set("n", "<leader>jcc", ":CodeCompanionChat<cr>",
        { desc = "[C]odecompanion [C]hat", silent = true, noremap = true })

    })
  end
}
