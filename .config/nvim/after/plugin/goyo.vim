nnoremap <leader>gy :Goyo<cr>

function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set wrap
    set cmdheight=1
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    set cmdheight=2
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
