return {
    'junegunn/gv.vim',
    config = function()
        vim.keymap.set('n', '<leader>gv', ':GV<cr>')
    end
}
