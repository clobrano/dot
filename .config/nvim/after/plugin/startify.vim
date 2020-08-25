nnoremap gS :Startify<cr>

let g:startify_change_to_dir=0
let g:startify_files_number = 10
let g:startify_bookmarks = [ {'I': '~/MyBox/notes/index.md'},
 \ {'J': '~/MyBox/notes/me/journal/📒journal.md'},
 \ {'t': '~/MyBox/work/telit/tnotes/index.md'} ]

let g:startify_change_to_dir = 0
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'files',     'header': ['   Files']          },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

