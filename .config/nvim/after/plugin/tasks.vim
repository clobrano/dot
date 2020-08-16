" support for vimtodolist
inoremap <C-t>b <esc>:VimTodoListsCreateNewItemBelow<cr>
inoremap <C-t>d <esc>:VimTodoListsToggleItem<cr>
inoremap <C-t>n <esc>:VimTodoListsCreateNewItem<cr>
inoremap <C-t><tab> <esc>:VimTodoListsIncreaseIndent<cr>A
nnoremap <C-t>b :VimTodoListsCreateNewItemBelow<cr>
nnoremap <C-t>n :VimTodoListsCreateNewItem<cr>

" toggle task item
nnoremap <leader>tt :VimwikiToggleListItem<cr>

" move lines up/down
nnoremap <C-Up>   :<C-u>silent! move-2<CR>==
nnoremap <C-Down> :<C-u>silent! move+<CR>==
xnoremap <C-Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <C-Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv
