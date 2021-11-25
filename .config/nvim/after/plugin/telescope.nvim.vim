lua << EOF
require('telescope').setup{
}
EOF

" Mapping
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>ft :Telescope tags<cr>
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fq :Telescope quickfix<cr>
nnoremap <leader>fa :Telescope live_grep<cr>
nnoremap <leader>fw :Telescope grep_string<cr>
nnoremap <leader>fm :Telescope man_pages<cr>
nnoremap <leader>fg :Telescope git_commits<cr>
