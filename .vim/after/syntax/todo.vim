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
syntax  match  TodoDate       '\d\{5\}'

syntax  match  TodoDueDate    'due:\d\{2,4\}-\d\{2\}-\d\{2\}'
syntax  match  TodoDueDate    'due:\d\{2\}-\d\{2\}'
syntax  match  TodoDueDate    'due:\d\{2\}/\d\{1,3\}'

syntax  match  Statement           '\(^\|\W\)+[^[:blank:]]\+'
syntax  match  MakeSpecial    '\(^\|\W\)@[^[:blank:]]\+'
syntax  match  Conditional    '\(^\|\W\)#[^[:blank:]]\+'

syntax match Comment     'http://[0-9a-zA-Z./\-_+=$%&()#?\[\]]*'
syntax match Comment     'https://[0-9a-zA-Z./\-_+=$%&()#?\[\]]*'
syntax match Comment     '[0-9a-zA-Z\.]*\/[ 0-9a-zA-Z\-\.]*\.md'
syntax match String      '".*"'
syntax match Bug         '\v[Bb]ug \d+'
syntax match Type        '(A)'
syntax match MakeSpecial '(B)'
syntax match String      '(C)'

hi def link Bug            ModeMsg
hi def link TodoContext    Constant
hi def link TodoDate       Directory
hi def link TodoProject    Statement
hi def link TodoTag        Question
