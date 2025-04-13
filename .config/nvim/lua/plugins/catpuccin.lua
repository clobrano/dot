return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup {
      flavour = "frappe",
      custom_highlights = function(colors)
        return {
          Todo = { fg = colors.flamingo, bg = colors.none },
          WinSeparator = { fg = colors.flamingo, bg = colors.none },
          ["@markup.quote.markdown"] = { fg = colors.overlay2, bold = false },
        }
      end
    }
  end
}
