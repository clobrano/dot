" Apply some custom formatting for filetype
" thanks to Wincent https://github.com/wincent/wincent
function! clobrano#format#customize(file, type)
    let l:pattern=join(g:clobrano_format_filetypes, '\|')
    if match(a:type, '\<\(' . l:pattern . '\)\>') != -1
        if match(a:type, '\<\(markdown\|todo\|text\)\>') != -1
            exe "colorscheme solarized"
            exe "set background=light"
            setlocal spell
            setlocal spelllang=en,it
        elseif match(a:type, '\<\(scss\)\>') != -1
            exe "colorscheme onehalfdark"
            exe "set background=dark"
        elseif match(a:type, '\<\(c\|cpp\|hpp\)\>') != -1
            exe "colorscheme monokai"
            exe "set background=dark"
        endif
    endif
endfunction
