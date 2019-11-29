"if executable('fzf')
    if has('nvim')
        let g:fzf_launcher = 'xterm -T fzf -fa monaco -fs 10 -e bash -ic %s'
    endif

    nnoremap <leader>fa :Ag<cr>
    nnoremap <leader>fb :Buffers<cr>
    nnoremap <leader>ff :Files<cr>
    nnoremap <leader>fl :BLines<cr>
    nnoremap <leader>ft :Tags<cr>
    nnoremap <leader>fx :Commits<cr>
"endif
