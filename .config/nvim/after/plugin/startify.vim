" nnoremap SS :Startify<cr>
cnoreabbrev ss Startify

let g:startify_custom_header =
    \ startify#pad(split(system('date +"%a %d %b %Y" | figlet -w 100'), '\n'))

let g:startify_change_to_dir=1
let g:startify_change_to_vcs_root = 1
let g:startify_commands = [
    \ { 'I': ['Open init.vim', 'e $MYVIMRC | lcd %:p:h'] }
    \ ]
let g:startify_enable_special = 0
let g:startify_files_number = 3

let g:startify_session_delete_buffers = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence = 1

let g:startify_lists = [
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ { 'type': 'dir',       'header': ['   MRU in '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ ]

function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
