vim.g.tagbar_type_go = {
    ctagstype = 'go',
    kinds = {
        'p:packages',
        'f:functions',
        'c:constants',
        't:types',
        'v:variables',
        's:structs',
        'i:interfaces',
        'm:struct members',
        'M:struct anonymous members',
        'n:interface method specification',
        'a:type aliases',
    },
    sro = '.',
    kind2scope = {
        t = 'ctype',
        s = 'struct',
        i = 'interface'
    },
    scope2kind = {
        ctype = 't',
        struct = 's',
        interface = 'i'
    },
    ctagsbin  = 'ctags',
    ctagsargs = '--fields=+iaS --extras=+q --languages=go --sort=yes'
}
return {
    'majutsushi/tagbar',
    enabled = false,
    config = function()
        vim.api.nvim_create_user_command('Toc', ':TagbarToggle fj', {})
        vim.keymap.set('n', '<leader>toc', ':TagbarToggle fj<cr>')
    end
}
