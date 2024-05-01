return {
    'szw/vim-g',
    opts = {},
    config = function()
        vim.cmd [[
        let g:vim_g_query_url="https://www.google.com/search?q="
        "let g:vim_g_query_url="https://duckduckgo.com/?q="
      ]]
        vim.keymap.set({ 'n', 'v' }, '<leader>fw', ':Google<cr>')
    end
}
