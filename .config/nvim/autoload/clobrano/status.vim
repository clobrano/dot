function! clobrano#status#git()
    let l:branchname = FugitiveHead()
    return strlen(branchname) > 0 ? '['.l:branchname.']' : ''
endfunction


" Show the number of errors and warning
function! clobrano#status#linter()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let _ = ''

    if l:counts.total == 0
        let _ .= ''
    else
        let _ .= '[' . all_errors . 'E,' . all_non_errors . 'W]'
    endif
    return _
endfunction
