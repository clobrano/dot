nnoremap <leader>ga   <esc>:Gwrite
nnoremap <leader>gc   <esc>:Gcommit<cr>
nnoremap <leader>gca  <esc>:Gcommit --amend<cr>
nnoremap <leader>gcan <esc>:Gcommit --amend --no-edit<cr>
nnoremap <leader>gl   <esc>:Glog<cr>
nnoremap <leader>gph  <esc>:Gpush<cr>
nnoremap <leader>gpl  <esc>:Gpull<cr>
nnoremap <leader>gs   <esc>:Gstatus<cr>

" Fugitive vertical diff
nnoremap <leader>gd <esc>:Gvdiff<space>
" Gvdiff get from left split
nnoremap gdh :diffget //2
" Gvdiff get from right split
nnoremap gdl :diffget //3
