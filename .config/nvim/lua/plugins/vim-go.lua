return {
    'fatih/vim-go',
    config = function()
        vim.cmd[[
        let g:go_term_enabled = 1
        let g:go_term_reuse = 1
        let g:go_term_close_on_exit = 0
        let g:go_list_type = "locationlist"

        let $GINKGO_EDITOR_INTEGRATION = "true"

        let g:go_highlight_functions = 1
        let g:go_highlight_methods = 1
        let g:go_highlight_structs = 1
        let g:go_highlight_operators = 1
        let g:go_highlight_build_constraints = 1
        let g:go_fmt_command = "goimports"

        " Go build same shortcut as make (what if makeprg=go\ build ?)
        au FileType go nmap <leader>1 <Plug>(go-build)
        " Go def split, same shortcut as got to definition tag in C
        au FileType go nmap <A-]> <Plug>(go-def-vertical)

        au FileType go nmap <Leader>gI <Plug>(go-imports)
        au FileType go nmap <Leader>gi <Plug>(go-install)
        au FileType go nmap <Leader>gk <Plug>(go-doc)
        au FileType go nmap <Leader>gw <Plug>(go-doc-browser)
        au FileType go nmap <leader>gc <Plug>(go-coverage-toggle)
        au FileType go nmap <leader>gr <Plug>(go-run)
        au FileType go nmap <leader>gt <Plug>(go-test)

        cnoreabbrev <expr> ga getcmdtype() == ":" && getcmdline() == 'ga' ? 'GoAlternate' : 'ga'

        " For debugger only
        let g:go_debug_windows = {
            \ 'vars':       'rightbelow 60vnew',
            \ 'stack':      'rightbelow 10new',
            \ }
            let g:go_debug_breakpoint_sign_text = '🟥'
            au FileType go nmap <C-n> <Plug>(go-debug-next)
            au FileType go nmap <C-p> <Plug>(go-debug-print)
            au FileType go nmap <C-s> <Plug>(go-debug-step)
            au FileType go nmap <C-x> <Plug>(go-debug-step-out)
            au FileType go nmap <C-b> <Plug>(go-debug-breakpoint)
            au FileType go nmap <C-c> <Plug>(go-debug-continue)


            cnoreabbrev gocov GoCoverageOverlay cover.out
        ]]
    end,
}
