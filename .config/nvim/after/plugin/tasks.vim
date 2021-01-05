" support for vim-taskwarrior
nnoremap tw :TW<cr>
let g:task_report_name = 'minimal'
let g:task_rc_override = 'rc.defaultwidth=999'
let g:task_info_size=70
let g:task_info_vsplit=1

nnoremap <leader>tt :VimwikiToggleListItem<cr>
let g:vimwiki_listsyms = ' .oOx'

" in place marks (replace currently selected text with marks)
nnoremap <leader>vmk vc🗸<esc>
nnoremap <leader>xmk vc🗙<esc>
nnoremap <leader>qmk vc❔<esc>
nnoremap <leader>lmk vc↶<esc>
nnoremap <leader>rmk vc↷<esc>
