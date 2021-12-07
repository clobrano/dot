lua << EOF
require('telescope').setup{
}
EOF

" Mapping
"nnoremap <leader>fa :Telescope live_grep<cr>
"nnoremap <leader>fb :Telescope buffers<cr>
"nnoremap <leader>ff :Telescope find_files no_ignore=true<cr>
nnoremap <leader>fm :Telescope man_pages<cr>
"nnoremap <leader>fq :Telescope quickfix<cr>
"nnoremap <leader>ft :Telescope tags<cr>
"nnoremap <leader>fw :Telescope grep_string<cr>

" GIT mappings
"nnoremap <leader>fgb :Telescope git_branches<cr>
"nnoremap <leader>fgc :Telescope git_commits<cr>
nnoremap <leader>fgs :Telescope git_stashes<cr>
