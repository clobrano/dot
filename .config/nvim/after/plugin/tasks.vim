" Change priority to A
nnoremap <leader>tpa v$:s/([A-D])/(A)/g<CR><space><space>:nohlsearch<cr>
" Change priority to B
nnoremap <leader>tpb v$:s/([A-D])/(B)/g<CR><space><space>:nohlsearch<cr>
" Change priority to C
nnoremap <leader>tpc v$:s/([A-D])/(C)/g<CR><space><space>:nohlsearch<cr>
" Change priority to D
nnoremap <leader>tpc v$:s/([A-D])/(D)/g<CR><space><space>:nohlsearch<cr>

" Move task UP in the same list
nnoremap <leader>tu dd?^#<cr>p<leader><space>``
" Move task to Done list
nnoremap <leader>td :s/-/✔/<cr>dd/^#.*Done<esc>p^a <C-R>=strftime("%y%02m%02d")<CR><esc>``
" Move task to Idle list
nnoremap <leader>tl dd/^#.*Idle<esc>p^a <C-R>=strftime("%y%02m%02d")<CR><esc>``

" Sort items by project
nnoremap <leader>tsj vip:sort '+[a-zA-z]*' r<cr>
" Sort items by priority
nnoremap <leader>tsp vip:sort '([A-Z])' r<cr>


