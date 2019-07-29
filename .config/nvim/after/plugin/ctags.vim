if executable("ctags")
    noremap T <Esc>:tag<space>
    " Move to next tag
    noremap <C-[> <C-o>
    " Open Tag in vertical split
    map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

    command! CtagsMake !ctags -R --extra=+f --exclude=.git .
endif
