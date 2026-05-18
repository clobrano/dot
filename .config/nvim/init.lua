print("Welcome to your new, clean config!")
require("config.lazy")
require('config.autocmds')
require('config.settings')
require('config.treesitter')
require('config.mappings')
require('config.diagnostic')
require('config.lsp')
require('config.abbr')


-- Temporary workaround to improve Octo PR page look: Add this at the very end of your init.lua
vim.api.nvim_set_hl(0, "OctoEditable", { bg = "#313244" }) -- Catppuccin Surface0/Mantle
vim.api.nvim_set_hl(0, "OctoDetails", { bg = "#1e1e2e" })   -- Catppuccin Base
vim.api.nvim_set_hl(0, "OctoHeader", { fg = "#89b4fa", bold = true })
