if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "markdown"

call matchadd('Conceal', '\[\ \]', 0, 110, {'conceal': ''})
call matchadd('Conceal', '\[X\]', 0, 120, {'conceal': ''})

"hi def link todoCheckbox Todo
""hi Conceal guibg=NONE
"highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

"setlocal cole=1
