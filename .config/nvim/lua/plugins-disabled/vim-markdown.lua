return {
    'preservim/vim-markdown',
    dependencies = {
        { 'godlygeek/tabular', lazy = true },
    },
    init = function()
        -- to create global variables accessible to
        -- vimscript we use`vim.g`
        --vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_auto_insert_bullets = 1
        vim.g.vim_markdown_edit_url_in = 'vsplit'
        vim.g.vim_markdown_folding_level = 6
        vim.g.markdown_fenced_languages = {'golang', 'python', 'lua', 'vim', 'bash'}
    end,
}
