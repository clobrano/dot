let g:netrw_banner=0
let g:netrw_liststyle = 3             " treetest-view
let g:netrw_list_hide= netrw_gitignore#Hide().'.*\.swp$'
let g:netrw_hide = 1
let g:netrw_preview = 1
let g:netrw_alto = 0  " preview in botright side
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_winsize = -28             " absolute width of netrw window

cnoreabbrev <expr> ex getcmdtype() == ":" && getcmdline() == 'ex' ? 'Explore' : 'ex'


function! NetrwMapping()
    nmap <buffer> . gh
    nmap <buffer> P <C-w>z
    nmap <buffer> o P<CR>
    nmap <buffer> x bd
endfunction

function! NetrwFindHere()
    exec "Explore " . expand("%:h") . "/"
endfunction


augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

nnoremap <leader>ee :Explore ./<cr>
nnoremap <leader>eh :call NetrwFindHere()<cr>
nnoremap <leader>re :Rexplore<cr>
