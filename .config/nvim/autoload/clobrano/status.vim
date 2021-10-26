function! clobrano#status#git()
    if !isdirectory($HOME . '/.config/nvim/plugged/vim-fugitive')
        return '[fugitive KO]'
    else
        let l:branchname = FugitiveHead()
        return strlen(branchname) > 0 ? '|  '.l:branchname : ''
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
    if !empty(glob('~/.config/nvim/plugged/taglist.vim'))
        let l:context = Tlist_Get_Tagname_By_Line()
        let _ = strlen(l:context) > 0 ? '| @' . l:context : ''
    endif
    return _
endfunction

function! clobrano#status#relpath()
    let cwd = fnamemodify(getcwd(), ':t:r')
    let filename =  cwd . '/' .expand("%")
    return filename
endfunction

function! clobrano#status#statusline_update(state)
    if (a:state == 'focus')
        "set statusline=
        setlocal statusline=
        setlocal statusline+=%<\                                     " cut at start
        if !empty(glob('~/.config/nvim/plugged/vim-devicons'))
            setlocal statusline+=%{WebDevIconsGetFileTypeSymbol()}\ %{clobrano#status#relpath()}\  " path
        else
            setlocal statusline+=%{clobrano#status#relpath()}\  " path
        endif
        setlocal statusline+=%{clobrano#status#git()}\               " git branch
        setlocal statusline+=%{clobrano#status#context()}\           " context
        setlocal statusline+=%h%m%R%W\                               " flags and buf no
        setlocal statusline+=%=                                      " right side
        setlocal statusline+=(%{&fileformat})\               " git branch
        setlocal statusline+=%{clobrano#status#linter()}\    " Linter status
        setlocal statusline+=%20(ℓ:%l/%L\ c:%v\ [%P]%) " line and file percentage
    endif
    if (a:state == 'unfocus')
        setlocal statusline=
        setlocal statusline+=%{clobrano#status#git()}\               " git branch
        setlocal statusline=%f
        setlocal statusline+=%20(ℓ:%l/%L\ c:%v\ [%P]%) " line and file percentage
    endif
endfunction
