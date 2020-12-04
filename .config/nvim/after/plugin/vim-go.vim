let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

" Go build same shortcut as make (what if makeprg=go\ build ?)
au FileType go nmap <leader>1 <Plug>(go-build)
" Go def split, same shortcut as got to definition tag in C
au FileType go nmap <A-]> <Plug>(go-def-vertical)

au FileType go nmap <Leader>gI <Plug>(go-imports)
au FileType go nmap <Leader>gi <Plug>(go-install)
au FileType go nmap <Leader>gw <Plug>(go-doc-browser)
au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gt <Plug>(go-test)
