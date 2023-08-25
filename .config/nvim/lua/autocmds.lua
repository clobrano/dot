vim.cmd[[
" Respace splits on resize
""autocmd VimResized * execute normal! \<c-w>="
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

" open Man and Help page in vertical split
autocmd FileType help wincmd L
autocmd FileType man wincmd L

" open Quickfix window below all splits
au FileType qf wincmd J

" Enter terminal-mode automatically
autocmd TermOpen * startinsert
]]

--" Hightlight word under cursor (all splits)
--" Just like windo, but restore the current window when done. (see: https://vim.fandom.com/wiki/Windo_and_restore_current_window)
--function! WinDoAndRestore(command)
  --let currwin=winnr()
  --execute 'windo ' . a:command
  --execute currwin . 'wincmd w'
--endfunction
--com! -nargs=+ -complete=command Windo call WinDoAndRestore(<q-args>)

--let g:toggle_hl_cur_word = 0
--function! ToggleHlCurWord()
    --if !g:toggle_hl_cur_word
        --augroup HL_CUR_WORD
            --autocmd!
            --autocmd CursorHold * :exec 'windo match Search /\V\<' . expand('<cword>') . '\>/'
        --augroup END
        --let g:toggle_hl_cur_word = 1
    --else
        --augroup HL_CUR_WORD
            --autocmd!
            --autocmd CursorHold * :exec 'windo match none'
        --augroup END
        --let g:toggle_hl_cur_word = 0
    --endif
--endfunction
