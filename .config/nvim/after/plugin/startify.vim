nnoremap gS :Startify<cr>

let g:startify_change_to_dir=0
let g:startify_files_number = 8
let g:startify_change_to_vcs_root = 1
let g:startify_session_delete_buffers = 1
let g:startify_enable_special = 0

let g:startify_change_to_dir = 0
let g:startify_lists = [
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'files',     'header': ['   Files']      },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]
