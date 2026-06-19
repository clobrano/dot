return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = function()
        require('todo-comments').setup {
          vim.cmd [[
              cnoreabbrev <expr> td getcmdtype() == ":" && getcmdline() == 'td' ? 'TodoTelescope keywords=TODO,DOING' : 'td'
            ]],
            signs = true,
            sign_priority = 4, -- Lower than both gitsigns (6) and markdown headers (5)
            keywords = {
                FIX = {
                    icon = "x", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                DOING = { icon = "󰐌 ", color = "success" },
                DONE = { icon = "󰗠 ", color = "comment" },
                SKIP = { icon = "󰅙 ", color = "comment", alt = { "WONTDO" } },
                HOLD = { icon = " ", color = "warning", alt = { "POSTPONED" } },
                QUEST = { icon = " ", color = "warning", alt = { "Q" } },
                HINT = { icon = " ", color = "hint" },
                HACK = { icon = " ", color = "warning", alt = { "KEY" } },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING" } },
                WIP = { icon = " ", color = "test", alt = { "WORKINPROGRESS" } },
                PASS = { icon = " ", color = "success", alt = { "PASSED" } },
                FAIL = { icon = " ", color = "error", alt = { "ISSUE", "FAILED" } },
                OK = { icon = " ", color =   "success", alt = { "OK", "SOLVED" } },
                NOK = { icon = " ", color = "error", alt = { "NOK" } },
            },
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
                comment = {"Comment", "#737994"},
                success = {"Success", "#98C379"}
            },
            gui_style = {
                fg = "BOLD",
            },
            highlight = {
                comments_only = false,
                after = "",
                keyword = "fg",
            }
        }
    end
}
