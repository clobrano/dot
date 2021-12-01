" buffer: open alternate file (ex. .c/.cpp <-> .h)
nnoremap <leader>a :FSHere<cr>
nnoremap <leader>av :FSSplitRight<cr>

" Do not create new alternate file if it does not exist yet.
let fsnonewfiles=1

" Some C++ projects use .cc in place of .cpp, moreover
" .h header is way more common than hpp, so keep it as alternate
" file.
au BufEnter *.h let b:fswitchdst  = 'cpp,cc'
au BufEnter *.cc let b:fswitchdst  = 'h,hpp'
