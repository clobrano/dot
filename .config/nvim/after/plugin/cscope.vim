if isdirectory($HOME . "/.config/nvim/plugged/cscope.vim")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    set csverb
    set cscopetag nocscopeverbose


    function! CscopeReload(mode)
        exe "CscopeClear"
        if a:mode == 'kernel'
            exe "!cscope -bRqk"
        else
            exe "!cscope -bRq"
        endif
        exe "cscope add cscope.out"
    endfunction
    nnoremap <leader>tr :call CscopeReload('normal')
    nnoremap <leader>tkr :call CscopeReload('kernel')

    " find symbol
    nnoremap <leader>fs :cscope find s <C-R>=expand("<cword>")<cr><cr>
    " find definition
    nnoremap <leader>fd :cscope find g <C-R>=expand("<cword>")<cr><cr>
    " find callers
    nnoremap <leader>fc :cscope find c <C-R>=expand("<cword>")<cr><cr>
    " find files including this file
    nnoremap <leader>fi :cscope find i <C-R>=expand("<cword>")<cr><cr>
    " find wher this symbol is assigned to a value
    nnoremap <leader>f= :cscope find a <C-R>=expand("<cword>")<cr><cr>
endif
