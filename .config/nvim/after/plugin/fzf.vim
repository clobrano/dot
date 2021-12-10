" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_history_dir = '~/.local/share/fzf-history'


command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

noremap <leader>fa :Rg<cr>
noremap <leader>fb :Buffers<cr>
noremap <leader>fc :Commits<cr>
noremap <leader>ff :Files<cr>
noremap <leader>fl :BLines<cr>
noremap <leader>ft :Tags<cr>
