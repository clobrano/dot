" Autogenerate a go main
function! GMain()
    let cur_line = line('.')
    call setline(cur_line, "func main() {")
    call setline(cur_line + 1, "}")
endfunction
iabbr gmain <esc>:call GMain()

" Autogenerate if err != nil
function! Gife()
    let cur_line = line('.')
    call setline(cur_line, "    if err != nil {")
    call setline(cur_line + 1, "}")
endfunction
iabbr ife <esc>:call Gife()<cr>
