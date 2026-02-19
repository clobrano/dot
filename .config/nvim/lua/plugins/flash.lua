return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,
      },
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
  },
  config = function(_, opts)
    require("flash").setup(opts)
    vim.api.nvim_create_user_command("FlashToggle", function()
      require("flash").toggle()
    end, { desc = "Toggle Flash Search" })
  end,
}
