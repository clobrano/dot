return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup {
      auto_integrations = true,
      custom_highlights = function(colors)
        return {
          Todo = { fg = colors.flamingo, bg = colors.none },
          --WinSeparator = { fg = colors.flamingo, bg = colors.none },
          ["@markup.quote.markdown"] = { fg = colors.subtext1, bold = false },
          -- Quote vertical line color (render-markdown plugin)
          RenderMarkdownQuote = { fg = colors.subtext1 },
          -- Remove the background highlight from the following tags which clashes with Todo-comments plugin
          ["@comment.todo.comment"] = { bg = 'none' },
          ["@comment.warning.comment"] = { bg = 'none' },
          ["@comment.note.comment"] = { bg = 'none' },
          ["@comment.fix.comment"] = { bg = 'none' },
          -- Try to fix render-markdown overloaded colors
          -- Change H2 to Peach to separate it from Blue/Sky wikilinks
          --RenderMarkdownH2 = { fg = colors.peach, bold = true },
          --RenderMarkdownH2Bg = { bg = colors.peach, fg = colors.base },

          -- Optional: Brighten H1 to Sapphire or Red for extra punch
          --RenderMarkdownH1 = { fg = colors.red, bold = true },
          --RenderMarkdownH1Bg = { bg = colors.red, fg = colors.base },

          -- Ensure wikilinks stay distinct (usually Blue)
          --RenderMarkdownWikiLink = { fg = colors.blue, underline = true },

          -- LSP semantic tokens for Neovim 0.12+
          -- These are the highlight groups that gopls sends via semantic tokens
          ["@lsp.type.function"] = { fg = colors.blue },
          ["@lsp.type.method"] = { fg = colors.blue },
          ["@lsp.type.variable"] = { fg = colors.text },
          ["@lsp.type.parameter"] = { fg = colors.peach },
          ["@lsp.type.type"] = { fg = colors.yellow },
          ["@lsp.type.class"] = { fg = colors.yellow },
          ["@lsp.type.interface"] = { fg = colors.yellow },
          ["@lsp.type.enum"] = { fg = colors.yellow },
          ["@lsp.type.enumMember"] = { fg = colors.flamingo },
          ["@lsp.type.constant"] = { fg = colors.yellow },
          ["@lsp.type.keyword"] = { fg = colors.mauve },
          ["@lsp.type.comment"] = { fg = colors.surface2, italic = true },
          ["@lsp.type.string"] = { fg = colors.green },
          ["@lsp.type.number"] = { fg = colors.peach },
          ["@lsp.type.operator"] = { fg = colors.sky },
          ["@lsp.type.namespace"] = { fg = colors.blue },
          ["@lsp.type.property"] = { fg = colors.text },
          ["@lsp.type.decorator"] = { fg = colors.flamingo },
          ["@lsp.type.macro"] = { fg = colors.mauve },
          ["@lsp.type.event"] = { fg = colors.flamingo },
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
