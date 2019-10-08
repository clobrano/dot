set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
set csverb
set cscopetag nocscopeverbose


function! TagsReload(mode)
    if a:mode == 'kernel'
        exe "!cscope -bRqk"
    else
        exe "!cscope -bRq"
    endif
endfunction
nnoremap <leader>tr :call TagsReload('normal')
nnoremap <leader>tkr :call TagsReload('kernel')

nnoremap <leader>l :cscope add cscope.out

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
