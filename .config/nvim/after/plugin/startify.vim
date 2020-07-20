nnoremap gS :Startify<cr>

nnoremap gN :lcd ~/MyBox/notes
nnoremap gW :lcd ~/Sync/tnotes

let g:startify_change_to_dir=0
let g:startify_files_number = 10
let g:startify_bookmarks = [ {'I': '~/MyBox/notes/me/📭Inbox.md'},
 \ {'J': '~/MyBox/notes/me/journal/📒journal.md'},
 \ {'t': '~/MyBox/work/telit/tnotes/taskell.md'} ]

let g:startify_change_to_dir = 0
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'files',     'header': ['   Files']          },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

