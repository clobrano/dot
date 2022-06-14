require'lspconfig'.clangd.setup{}

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end
-- Setup lspconfig.
--require('lspconfig').clangd.setup {
--capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--}


require('lspconfig').pylsp.setup{}                 
require('lspconfig').gopls.setup{}                 
require('lspconfig').rust_analyzer.setup({})       

