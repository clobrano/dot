virtual_text = {}
virtual_text.show = true
virtual_text.toggle = function()
    virtual_text.show = not virtual_text.show
    vim.lsp.diagnostic.display(
    vim.lsp.diagnostic.get(0, 1),
    0,
    1,
    {virtual_text = virtual_text.show}
    )
end

vim.api.nvim_set_keymap(
    'n',
    '<Leader>lv',
    '<Cmd>lua virtual_text.toggle()<CR>',
    {silent=true, noremap=true}
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = false,
        signs = true,
        update_in_insert = true,
    }
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single"
    }
)

require 'nvim-cmp'
require 'treesitter'
require('nvim-lspconfig')
require('flutter-tools').setup{} 
require("luasnip.loaders.from_vscode").lazy_load()
require'hop'.setup{}

vim.api.nvim_set_keymap('n', '<leader>j', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
vim.api.nvim_set_keymap('v', '<leader>j', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
vim.api.nvim_set_keymap('o', '<leader>j', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", {})
