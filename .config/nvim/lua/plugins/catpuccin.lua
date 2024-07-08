return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup {
      custom_highlights = function(colors)
        return {
          Todo = { fg = colors.flamingo, bg = colors.none },
          WinSeparator = { fg = colors.flamingo, bg = colors.none },
        }
      end
    }
  end
}
