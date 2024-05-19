return {
    'majutsushi/tagbar',
    config = function()
        vim.keymap.set('n', '<leader>to', ':TagbarToggle fj<cr>')
    end
}
