" support for vim-taskwarrior

if isdirectory($HOME . "/.config/nvim/plugged/taskwarrior.vim")
    nnoremap tw :TW<cr>
    let g:task_rc_override = 'rc.defaultwidth=999'
    let g:task_info_size=70
    let g:task_info_vsplit=1
endif

if isdirectory($HOME . "/.config/nvim/plugged/vimwiki")
    nnoremap <leader>tt :VimwikiToggleListItem<cr>
endif

" in place marks (replace currently selected text with marks)
nnoremap <leader>vmk vc🗸<esc>
nnoremap <leader>xmk vc🗙<esc>
nnoremap <leader>qmk vc❔<esc>
nnoremap <leader>lmk vc↶<esc>
nnoremap <leader>rmk vc↷<esc>
