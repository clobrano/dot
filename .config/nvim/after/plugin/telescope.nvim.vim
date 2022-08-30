lua << EOF
require('telescope').setup{
    defaults = {  
        layout_strategy = 'vertical',
        layout_config = {
            width = 0.95,
            height = 0.95,
            horizontal = {preview_width = 0.5},
            vertical = {preview_height = 0.7},
        },
    },
    pickers = {
        find_files = {
            no_ignore = true,
        }
    }
}
EOF

" Mapping
"nnoremap <leader>fa :Telescope live_grep<cr>
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fd :Telescope lsp_definitions<cr>
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>fh :Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fi :Telescope lsp_implementations<cr>
nnoremap <leader>fl :Telescope resume<cr>
nnoremap <leader>ft :Telescope tags<cr>
nnoremap <leader>fm :Telescope man_pages<cr>
nnoremap <leader>fr :Telescope lsp_references<cr>
nnoremap <leader>fs :Telescope grep_string<cr>

" GIT mappings
nnoremap <leader>fgb :Telescope git_branches<cr>
nnoremap <leader>fgs :Telescope git_stashes<cr>
