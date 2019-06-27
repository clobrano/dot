function! License(type)
    let license = '~/dotfiles/vim/vim/snippets/licenses/' . a:type
    let filename = expand('%:t')
    let owner = "Carlo Lobrano"
    let email = "c.lobrano@gmail.com"
    let date = strftime('%Y')
    exec '-1r' . license
    exec ':%s/owner/' . owner .'/g'
    exec ':%s/email/' . email . '/g'
    exec ':%s/date/' . date . '/g'
    exec ':%s/filename/' . filename . '/g'
endfunction
iabbr gpl <esc>:call License('gpl')
