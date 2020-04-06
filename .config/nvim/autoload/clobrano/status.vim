function! clobrano#status#git()
    if !isdirectory($HOME . "/.config/nvim/plugged/vim-fugitive")
        return '[fugitive KO]'
    else
        let l:branchname = FugitiveHead()
        return strlen(branchname) > 0 ? ' '.l:branchname.' ' : ''
    endif
endfunction


" Show the number of errors and warning
function! clobrano#status#linter()
    let _ = ''
    if !isdirectory($HOME . "/.config/nvim/plugged/ale")
        return "[ale-linter KO]"
    endif

    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    if l:counts.total == 0
        let _ .= ''
    else
        let _ .= '[:' . all_errors . ' :' . all_non_errors . ']'
    endif
    return _
endfunction

" Use TagList plugin to show current function context
function! clobrano#status#context()
    let _ = ''
        let l:context = Tlist_Get_Tagname_By_Line()
        let _ = strlen(l:context) > 0 ? l:context : ''
    return _
endfunction
