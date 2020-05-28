if has('nvim')
    let g:fzf_launcher = 'xterm -T fzf -fa monaco -fs 10 -e bash -ic %s'
endif

let g:fzf_layout = {
\ 'window': 'new | wincmd J | resize 15'
\ }

let g:fzf_history_dir = '~/.local/share/fzf-history'

nnoremap <leader>fa :Ag<cr>
nnoremap <leader>fb :Buffers<cr>
"nnoremap <leader>ff :Files<cr>
nnoremap <leader>fl :BLines<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fx :Commits<cr>
nnoremap <leader>ff :FloatermNew fzf --preview='head -$LINES {}'<cr>
