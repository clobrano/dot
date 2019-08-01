function! clobrano#status#git()
    if ! exists("*FugitiveHead")
	return '[fugitive KO]'
    else
    	let l:branchname = FugitiveHead()
    	return strlen(branchname) > 0 ? '['.l:branchname.']' : ''
    endif
endfunction


" Show the number of errors and warning
function! clobrano#status#linter()
    let _ = ''
    if !exists("*ale#statusline#Count")
        return "[linker KO]"
    endif

    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors


    if l:counts.total == 0
        let _ .= ''
    else
        let _ .= '[' . all_errors . 'E,' . all_non_errors . 'W]'
    endif
    return _
endfunction
