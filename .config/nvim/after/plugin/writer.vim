" Configuration to simplify edit text/markdow files
" This configuration file operates on more than one single plugin

" EasyAlign align tables
nnoremap <leader>at  vip:EasyAlign *<bar><cr>

" Add dates, short and long formats
nnoremap <leader>D a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>d a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%d.%m.%y")<CR>
nnoremap <A-d> a<C-R>=strftime("%d.%m.%y")<CR><Esc>
inoremap hhmm <C-R>=strftime("%H:%M")<CR>
inoremap wwd <C-r>=strftime("%a")<CR>

" The following works with surround plugin
" Bold text with "B"
autocmd FileType markdown,todo,plantuml let b:surround_{char2nr("B")} = "**\r**"
" Link with "L"
autocmd FileType markdown,todo let b:surround_{char2nr("L")} = "[\r]()"
" Wiki link with "l"
autocmd FileType markdown,todo let b:surround_{char2nr("l")} = "[[\r]]"
" Strike through "X"
autocmd FileType markdown,todo let b:surround_{char2nr("X")} = "~~\r~~"

" Lines, move up/down
nnoremap <C-Up>   :<C-u>silent! move-2<CR>==
nnoremap <C-Down> :<C-u>silent! move+<CR>==
xnoremap <C-Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <C-Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv

" Emoji abbreviations
iabbr vmk ✔
iabbr xmk 🗙
iabbr qmk ❔
iabbr lmk ↶
iabbr rmk ↷

" Open a draft file with a command `draft`
cabbr draft e /tmp/draft.md

" Enable emoji support on text related filetypes
au FileType html,php,markdown,mmd,text,mail,gitcommit
    \ runtime macros/emoji-ab.vim

" indent/de-indent in insertmode (de-dent is <C-d> by default)
"inoremap <C-i> <C-t>
