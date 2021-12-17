lua << EOF
require('telescope').setup{
}
EOF

" Mapping
nnoremap <leader>fm :Telescope man_pages<cr>
nnoremap <leader>fs :Telescope grep_string<cr>
nnoremap <leader>fd :Telescope file_browser<cr>

" GIT mappings
nnoremap <leader>fgb :Telescope git_branches<cr>
nnoremap <leader>fgs :Telescope git_stashes<cr>
