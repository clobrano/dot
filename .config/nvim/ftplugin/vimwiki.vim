
"let g:vimwiki_folding = 'value'
set foldlevel=99
"set foldexpr=NestedMarkdownFolds()
"au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
"au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setlocal syntax=markdown
"set concealcursor=c

" I want the todo.txt shortcuts, but the ability to work with vimwiki (find references for example)
" so I will use a todo file with markdown extension, that should be recognized by vimwiki and
" load all its properties for the buffer, and also set the filetype to todo to get todo.txt mappings.
"autocmd BufNewFile,BufRead todo.md set filetype=todo
