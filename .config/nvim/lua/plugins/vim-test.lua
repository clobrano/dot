return {
  "vim-test/vim-test",
  config = function()
    vim.keymap.set('n', '<leader>tl', ':TestLast<cr>', { desc="[T]est[L]ast", noremap=true, silent=true })
  end
}
