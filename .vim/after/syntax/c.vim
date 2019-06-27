" Vim syntax file example
" Put it in ~/.vim/after/syntax/ and tailor to your needs.

let cairo_deprecated_errors = 1
let gdkpixbuf_deprecated_errors = 1
let glib_deprecated_errors = 1
let gtk3_deprecated_errors = 1

runtime!  /home/carlolo/.vim/plugged/gtk-vim-syntax/syntax/glib.vim
runtime!  /home/carlolo/.vim/plugged/gtk-vim-syntax/syntax/gtk2.vim
runtime!  /home/carlolo/.vim/plugged/gtk-vim-syntax/syntax/gtk3.vim

syn match defined "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
hi def link defined Macro

" vim: set ft=vim :
