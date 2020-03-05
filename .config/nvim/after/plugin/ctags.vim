if executable("ctags")
    noremap T <Esc>:tag<space>
    " Move to next tag
    noremap <C-[> <C-o>
    " use tselect instead of tags
    nnoremap <C-]> g<C-]>
    vnoremap <C-]> g<C-]>
    " Open Tag in vertical split
    "map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
    "noremap <A-]>  :exec("ptjump ".expand("<cword>"))<CR>
    noremap <A-]>  <C-w>vg<C-]>
    command! CtagsMake !ctags -R --extra=+f --exclude=.git .

    function TagsRedo()
        exe "CscopeClear"
        exe "CtagsMake"
        exe "cscope add cscope.out"
    endfunction
    "nnoremap <leader>tr :call TagsRedo()
endif
