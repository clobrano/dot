" Configuration to simplify edit text/markdow files
" This configuration file operates on more than one single plugin

" Add dates, short and long formats
"nnoremap <leader>D a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
"nnoremap <leader>d a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
"inoremap <A-d> <C-R>=strftime("%d.%m.%y")<CR>
"nnoremap <A-d> a<C-R>=strftime("%d.%m.%y")<CR><Esc>
"inoremap hhmm <C-R>=strftime("%H:%M")<CR>
"inoremap wwd <C-r>=strftime("%a")<CR>

" Lines, move up/down
nnoremap <C-Up>   :<C-u>silent! move-2<CR>==
nnoremap <C-Down> :<C-u>silent! move+<CR>==
xnoremap <C-Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <C-Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv
