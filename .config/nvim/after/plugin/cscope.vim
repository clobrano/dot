if has('cscope')
    function! TagsReload()
        exe "!find . -name '*.c' >> cscope.files"
        exe "!find . -name '*.cpp' >> cscope.files"
        exe "!find . -name '*.h' >> cscope.files"
        exe "!find . -name '*.hpp' >> cscope.files"
        exe "!cscope -bRq"
    endfunction

    nnoremap <leader>tr :call TagsReload()
    " find symbol
    nnoremap <leader>fs :cscope find s <cword><cr>
    " find definition
    nnoremap <leader>fd :cscope find g <cword><cr>
    " find callers
    nnoremap <leader>fc :cscope find c <cword><cr>
    " find files including this file
    nnoremap <leader>fi :cscope find i <cword><cr>
    " find wher this symbol is assigned to a value
    nnoremap <leader>f= :cscope find a <cword><cr>
endif
