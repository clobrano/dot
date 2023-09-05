--let g:NERDTreeHijackNetrw = 0 " add this line if you use NERDTree
vim.cmd[[
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
]]

vim.keymap.set('n', '<leader>f', '<Nop>') -- trying to disable annoying <leader>f mapping
vim.keymap.set('n', '<leader>rr', ':Ranger<cr>', { silent = true })
vim.keymap.set('n', '<leader>rw', ':RangerWorkingDirectory', { silent = true })
