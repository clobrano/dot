" Apply some custom formatting for filetype
" thanks to Wincent https://github.com/wincent/wincent
function! clobrano#format#customize(file, type)
    let l:pattern=join(g:clobrano_format_filetypes, '\|')
    if match(a:type, '\<\(' . l:pattern . '\)\>') != -1
        if match(a:type, '\<\(markdown\|todo\)\>') != -1
            exe "colorscheme solarized"
            exe "set background=light"
        elseif match(a:type, '\<\(scss\)\>') != -1
            exe "colorscheme onehalfdark"
            exe "set background=dark"
        else
            exe "colorscheme monokai"
            exe "set background=dark"
        endif
    endif
endfunction
