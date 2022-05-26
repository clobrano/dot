lua << EOF
require('telescope').setup{
}
EOF

" Mapping
nnoremap <leader>fm :Telescope man_pages<cr>
nnoremap <leader>fs :Telescope grep_string<cr>
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>fh :Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>ft :Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>fi :Telescope lsp_implementations<cr>
nnoremap <leader>fd :Telescope lsp_definitions<cr>
nnoremap <leader>fr :Telescope lsp_references<cr>
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fl :Telescope resume<cr>

" GIT mappings
nnoremap <leader>fgb :Telescope git_branches<cr>
nnoremap <leader>fgs :Telescope git_stashes<cr>
