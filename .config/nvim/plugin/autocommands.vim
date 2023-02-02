"autocmd * set textwidth=0
" Make current window more obvious by turning off/adjusting some features in non-current
" windows.
"if exists('+winhighlight')
    "autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
    "autocmd FocusLost,WinLeave * set winhighlight=LineNr:ColorColumn,CursorLineNr:ColorColumn,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn,NonText:ColorColumn
    "if exists('+colorcolumn')
        "autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
    "endif
"elseif exists('+colorcolumn')
    "autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
    "autocmd FocusLost,WinLeave * let &l:colorcolumn=join(range(1, 255), ',')
"endif

" Respace splits on resize
autocmd VimResized * execute "normal! \<c-w>="
" folding method for css, scss
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Align function arguments
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Auto-header scripts
augroup Shebang
  autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl># -*- coding: UTF-8 -*-\<nl>\"|$
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\<nl># -*- coding: utf-8 -*-\<nl># vi: set ft=python :\<nl>\"|$
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: None -*-\<nl>\"|$
  autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
  autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
augroup END

augroup exe_code
    autocmd FileType bash,sh :nnoremap <buffer> <localleader>r 
                \ :sp<cr> :term bash %<cr> :startinsert<cr>
    autocmd FileType python :nnoremap <buffer> <localleader>r 
                \ :sp<cr> :term python3 %<cr> :startinsert<cr>
    autocmd FileType cpp,c :nnoremap <buffer> <localleader>r 
                \ :sp<cr> :term ./%<<cr> :startinsert<cr>
augroup END

" Filetypes with specific settings (e.g. formatting)
" thanks to Wincent https://github.com/wincent/wincent
let g:clobrano_format_filetypes=[
    \   'c',
    \   'cpp',
    \   'hpp',
    \   'markdown',
    \   'scss',
    \   'text',
    \   'todo',
    \   'vim',
    \   'vimwiki',
    \ ]
let s:pattern=join(g:clobrano_format_filetypes, ',')
execute 'autocmd FileType ' . s:pattern . " call clobrano#format#customize(expand('<afile>'), expand('<amatch>'))"

if has('statusline')
    "autocmd BufEnter,FocusGained,VimEnter,WinEnter * call clobrano#status#statusline_update('focus')
    "autocmd FocusLost,WinLeave * call clobrano#status#statusline_update('unfocus')
endif

" open Man and Help page in vertical split
autocmd FileType help wincmd L
autocmd FileType man wincmd L

" open Quickfix window below all splits
au FileType qf wincmd J
