" Autogenerate a Python main
function! PythonMain()
    let cur_line = line('.')
    call setline(cur_line, "if __name__ == \"__main__\":")
endfunction
iabbr spmain <esc>:call PythonMain()

