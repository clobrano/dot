return {
    'preservim/vim-markdown',
    dependencies = {
        { 'godlygeek/tabular', lazy = true },
    },
    init = function()
        -- to create global variables accessible to
        -- vimscript we use`vim.g`
        vim.g.vim_markdown_auto_insert_bullets = 1
        vim.g.vim_markdown_edit_url_in = 'vsplit'
    end,
}
