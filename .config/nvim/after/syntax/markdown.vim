"if exists("b:foo_syntax")
    "finish
"endif

"" Custom conceal
"call matchadd('Conceal', '\[\ \]', 0, 11, {'conceal': ''})
"call matchadd('Conceal', '\[x\]', 0, 12, {'conceal': ''})

"let b:foo_syntax = "todo"

"hi def link todoCheckbox Todo
"hi Conceal guibg=NONE

"setlocal cole=1
