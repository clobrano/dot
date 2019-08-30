" Custom colors for Todo.txt like highlight
" YYYY-MM-DD
syntax  match  TodoDate       '\d\{2,4\}-\d\{2\}-\d\{2\}'
" YYYY/MM/DD
syntax  match  TodoDate       '\d\{2,4\}/\d\{2\}/\d\{2\}'
" MM-DD
syntax  match  TodoDate       '\d\{2\}-\d\{2\}'
" MM/DD
syntax  match  TodoDate       '\d\{2\}/\d\{2\}'
" Data YYYY/Day-of-year
syntax  match  TodoDate       '\d\{4\}/\d\{3\}'
" Data YY/Day-of-year
syntax  match  TodoDate       '\d\{2\}/\d\{3\}'
" Data YYWWD
syntax  match  TodoDueDate    '\!\d\{6\}'
syntax  match  TodoDate       '\d\{6\}'

syntax  match  Statement      '\(^\|\W\)+[^[:blank:]]\+'
syntax  match  Project            '\(^\|\W\)@[^[:blank:]]\+'
syntax  match  Hashtag        '\(^\|\W\)#[^[:blank:]]\+'

syntax match Link     'http://[0-9a-zA-Z./\-_+=$%&()#?\[\]]*'
syntax match Link     'https://[0-9a-zA-Z./\-_+=$%&()#?\[\]]*'
syntax match Note     '[0-9a-zA-Z\-\.]*\/[ 0-9a-zA-Z\-\.]*\.md'
syntax match String      '".*"'
syntax match Bug         '\v[Bb]ug \d+'
syntax match PrioA '(A)'
syntax match PrioB '(B)'
syntax match PrioC '(C)'

hi def link Bug            ModeMsg
hi def link TodoContext    Constant
hi def link TodoDate       Directory
hi def link TodoProject    Statement
hi def link TodoTag        Question

hi Hashtag     gui=none      guibg=none guifg=purple    cterm=bold      ctermbg=none
hi Link        gui=underline guibg=none guifg=lightblue cterm=underline ctermbg=none ctermfg=blue
hi Note        gui=none      guibg=none guifg=#CDCCCC cterm=none      ctermbg=none ctermfg=grey
hi Project     gui=none      guibg=none guifg=orange    cterm=bold      ctermbg=none
hi TodoDueDate gui=none      guibg=none guifg=red
hi PrioA       gui=none      guibg=none guifg=red
hi PrioB       gui=none      guibg=none guifg=orange
hi PrioC       gui=none      guibg=none guifg=green
