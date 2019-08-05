" Apply some custom formatting for filetype
" thanks to Wincent https://github.com/wincent/wincent
function! clobrano#format#customize(file, type)
    let l:pattern=join(g:clobrano_format_filetypes, '\|')
    if match(a:type, '\<\(' . l:pattern . '\)\>') != -1
        if match(a:type, '\<\(markdown\|todo\|text\)\>') != -1
            exe "colorscheme PaperColor"
            exe "set background=light"
            setlocal nospell
        endif
        if match(a:type, '\<\(markdown\|text\)\>') != -1
            " No spell check in todo filetype
            setlocal spell
            setlocal spelllang=en,it
            hi SpellBad cterm=none ctermbg=none ctermfg=red
            hi SpellCap cterm=bold ctermbg=none ctermfg=grey
        endif
        if match(a:type, '\<\(scss\)\>') != -1
            exe "colorscheme onehalfdark"
            exe "set background=dark"
        endif
    endif
endfunction
