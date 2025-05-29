--return {
  ---- LSP Configuration & Plugins
  --'neovim/nvim-lspconfig',
  --dependencies = {
    ---- Automatically install LSPs to stdpath for neovim
    --{ 'mason-org/mason.nvim', config = true },
    --'mason-org/mason-lspconfig.nvim',
    ---- Useful status updates for LSP
    ---- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
    ---- Additional lua configuration, makes nvim stuff amazing!
    --'folke/neodev.nvim',
  --},
--}

return {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
