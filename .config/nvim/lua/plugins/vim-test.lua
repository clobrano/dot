return {
    'vim-test/vim-test',
    opts = {},
    config = function()
        vim.cmd [[
    let test#strategy = {
      \ 'nearest': 'basic',
    \}
      "let g:test#basic#start_normal = 1
      let g:test#neovim#term_position = "hor botright 5"
      ]]
        vim.keymap.set('n', '<leader>ts', ':TestSuite<cr>')
        vim.keymap.set('n', '<leader>tn', ':TestNearest<cr>')
        vim.keymap.set('n', '<leader>tl', ':TestLast<cr>')
    end
}
