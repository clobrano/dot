" support for vimtodolist
inoremap <C-t>b <esc>:VimTodoListsCreateNewItemBelow<cr>
inoremap <C-t>d <esc>:VimTodoListsToggleItem<cr>
inoremap <C-t>n <esc>:VimTodoListsCreateNewItem<cr>
inoremap <C-t><tab> <esc>:VimTodoListsIncreaseIndent<cr>A
nnoremap <C-t>b :VimTodoListsCreateNewItemBelow<cr>
nnoremap <C-t>d :VimTodoListsToggleItem<cr>
nnoremap <C-t>n :VimTodoListsCreateNewItem<cr>
