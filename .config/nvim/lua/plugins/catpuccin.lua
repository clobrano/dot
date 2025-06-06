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
    -- Create an autocommand group for clarity (optional but recommended)
    -- Create an autocommand that triggers on the ColorScheme event for 'catppuccin'
    local transparent_augroup = vim.api.nvim_create_augroup("CatppuccinTransparentBackground", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "catppuccin*", -- This ensures it only runs when catppuccin is loaded
      group = transparent_augroup,
      callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
      end
    })
  end
}
