if isdirectory($HOME . "/.config/nvim/plugged/vim-startify")
    nnoremap gs :Startify<cr>

    let g:startify_change_to_dir=0
    let g:startify_files_number = 5
    let g:startify_change_to_vcs_root = 1
    let g:startify_session_delete_buffers = 1
    let g:startify_enable_special = 0
    let g:startify_bookmarks = [ 
                \ {'b': '~/workspace/me/blog'},
                \ {'m': '~/MyBox/notes/index.md'},
                \ {'v': '~/.config/nvim/init.vim'},
                \ {'c': '~/.config/nvim/'},
                \ ]

    let g:startify_change_to_dir = 0
    let g:startify_lists = [
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'files',     'header': ['   Files']      },
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ ]
endif
