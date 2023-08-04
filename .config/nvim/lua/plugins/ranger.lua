--let g:NERDTreeHijackNetrw = 0 " add this line if you use NERDTree
vim.cmd('let g:ranger_replace_netrw = 1') -- open ranger when vim open a directory

vim.keymap.set('n', '<leader>rr', ':Ranger<cr>', { silent = true })
vim.keymap.set('n', '<leader>rw', ':RangerWorkingDirectory', { silent = true })
