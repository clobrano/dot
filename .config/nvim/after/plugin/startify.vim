nnoremap gS :Startify<cr>

let g:startify_change_to_dir=0
let g:startify_files_number = 5
let g:startify_change_to_vcs_root = 1
let g:startify_session_delete_buffers = 1
let g:startify_enable_special = 0
let g:startify_bookmarks = [ {'b': '~/workspace/me/blog'},
            \ {'w': '~/MyBox/work/telit/tnotes/index.md'},
            \ {'m': '~/MyBox/notes/index.md'},
            \ {'u': '~/workspace/devel/uxfp'},
            \ {'y': '~/workspace/ubuntu/yaru'},
            \ ]

let g:startify_change_to_dir = 0
let g:startify_lists = [
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

