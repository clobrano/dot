-- Setup nvim-cmp.
local cmp = require'cmp'
--local luasnip = require'luasnip'

cmp.setup({
    -- snippet = {
    --   expand = function(args)
    --     vim.fn["luasnip#anonymous"](args.body)
    --   end,
    -- },
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        -- ['<C-y>'] = cmp.mapping(function(fallback)
        --   if luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        --   end, {"i", "s"}),
        ['<Tab>'] = cmp.mapping.confirm { select = true },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 5 },
        { name = 'luasnip' },
    },
    experimental = {
        ghost_text = true
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})


