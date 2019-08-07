" Vim syntax file example
" Put it in ~/.vim/after/syntax/ and tailor to your needs.

syn match Type "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
hi def link defined Macro

" Highlight typedefs if they end with _t (e.g. custom_type_t OK)
syn match Type "\<\w*_t\>"
syn match Type "\<t[A-Z\_\-]\+\w*\>"
