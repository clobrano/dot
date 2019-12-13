if filereadable(expand('uncrustify.cfg'))
    augroup Autoformat
        autocmd!
        autocmd FileType c let &l:equalprg = 'uncrustify --frag -q -c uncrustify.cfg --no-backup'
    augroup END

    command! Uncrustify :!uncrustify -c uncrustify.cfg --no-backup %
endif
"set formatprg="uncrustify -c uncrustify.cfg --no-backup"
