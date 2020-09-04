function! WriteRoom()
    " TODO change line number color to make it invisible, but colorscheme-wise
    if !exists("g:writeroom")
        let g:writeroom="true"
        exec "setlocal norelativenumber"
        exec "setlocal number"
        exec "setlocal numberwidth=15"
        exec "setlocal columns=100"
    else
        unlet g:writeroom
        exec "setlocal nonumber"
        exec "setlocal relativenumber"
        exec "setlocal numberwidth=4"
        exec "setlocal columns=160"
    endif
endfunction

command! WriteRoom :call WriteRoom()

function! ToggleBackground()
    if "light" == &background
        exec "set background=dark"
    else
        exec "set background=light"
    endif
endfunction

command! ToggleBg :call ToggleBackground()

let s:middot='·'
let s:raquo='»'
let s:small_l='ℓ'

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
"
" Instead returning:
"
"   »··[2ℓ]··: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
"
" thanks to Wincent https://github.com/wincent/wincent
function! WincentFoldtext() abort
  let l:lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  let l:first=substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
endfunction

command! Activereview !active-review-update.py
