let g:mysep = ' '
function! clobrano#status#git()
    if !exists('g:loaded_fugitive')
        return '[fugitive KO]'
    else
        let l:branchname = FugitiveHead()
        return strlen(branchname) > 0 ? '  '.l:branchname . g:mysep : ''
    endif
endfunction


" Show the number of errors and warning
function! clobrano#status#linter()
    let _ = ''
    if !isdirectory($HOME . "/.config/nvim/plugged/ale")
        return ""
    endif

    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    if l:counts.total == 0
        let _ .= ''
    else
        let _ .= ' [' . all_errors . ']  [' . all_non_errors . ']'
    endif
    return _
endfunction

" Use TagList plugin to show current function context
function! clobrano#status#context()
    let _ = ''
    if exists('g:loaded_taglist')
        let l:context = Tlist_Get_Tagname_By_Line()
        let _ = strlen(l:context) > 0 ? g:mysep. " " . l:context . '()' : ''
    endif
    return _
endfunction

function! clobrano#status#workingdirectory()
    return '⛁ ' . fnamemodify(getcwd(), ':t:r') . g:mysep
endfunction

function! clobrano#status#show_tdd_result()
    let l:tdd_result_file = $HOME . "/.tdd-result"
    if !filereadable(l:tdd_result_file)
        return """
    endif
    return readfile(l:tdd_result_file, '', 1)[0]
endfunction


highlight User1 cterm=bold ctermfg=236 ctermbg=141 gui=bold guifg=#282A36 guibg=#BD93F9
highlight User2 ctermbg=238 guibg=#424450 ctermfg=84 guifg=#50FA7B
highlight User3 ctermbg=238 guibg=#424450 ctermfg=117 guifg=#8BE9FD
highlight User4 ctermbg=238 guibg=#424450 ctermfg=11 gui=bold guifg=#ffff60

function! clobrano#status#statusline_update(state)
    setlocal statusline=
    setlocal statusline+=%1*
    setlocal statusline+=%<\                                     " cut at start
    setlocal statusline+=%{clobrano#status#workingdirectory()}\  " path
    setlocal statusline+=%*
    setlocal statusline+=%2*
    setlocal statusline+=%{clobrano#status#git()}\               " git branch
    setlocal statusline+=%*
    setlocal statusline+=%3*
    if !empty(glob('~/.config/nvim/plugged/vim-devicons'))
        setlocal statusline+=%{WebDevIconsGetFileTypeSymbol()}\  " path
    endif
    setlocal statusline+=%f  " path
    setlocal statusline+=%*
    setlocal statusline+=%4*
    setlocal statusline+=%{clobrano#status#context()}\           " context
    setlocal statusline+=%*
    setlocal statusline+=%h%m%R%W\                               " flags and buf no
    setlocal statusline+=%=                                      " right side
    setlocal statusline+=%{clobrano#status#show_tdd_result()}
    setlocal statusline+=%{clobrano#status#linter()}\    " Linter status
    setlocal statusline+=%20(ℓ:%l/%L\ [%P]%) " line and file percentage
endfunction

