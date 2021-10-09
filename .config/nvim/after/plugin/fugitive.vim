nnoremap <leader>ga   <esc>:Gwrite
nnoremap <leader>gb   <esc>:G blame<cr>
nnoremap <leader>gc   <esc>:G commit<cr>
nnoremap <leader>gca  <esc>:G commit --amend<cr>
nnoremap <leader>gcan <esc>:G commit --amend --no-edit<cr>
nnoremap <leader>gl   <esc>:G log<cr>
nnoremap <leader>gph  <esc>:G push<cr>
nnoremap <leader>gpl  <esc>:G pull<cr>
nnoremap <leader>gs   <esc>:vertical G<cr>

" Fugitive vertical diff
nnoremap <leader>gd <esc>:Gvdiff<space>
" Gvdiff get from left split
nnoremap gdh :diffget //2
" Gvdiff get from right split
nnoremap gdl :diffget //3

" move to parent directory when exploring the tree
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> <leader>.. :edit %:h<CR> |
  \ endif
