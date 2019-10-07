" Apply some custom formatting for filetype
" thanks to Wincent https://github.com/wincent/wincent
function! clobrano#format#customize(file, type)
    let l:pattern=join(g:clobrano_format_filetypes, '\|')
    if match(a:type, '\<\(' . l:pattern . '\)\>') != -1
        if a:type == "todo"
            setlocal nospell
        endif
        if match(a:type, '\<\(markdown\|text\)\>') != -1
            setlocal spell
            setlocal spelllang=en,it
            hi SpellBad cterm=none ctermbg=none ctermfg=red gui=underline guibg=none guifg=red
            hi SpellCap cterm=bold ctermbg=none ctermfg=grey guibg=none guifg=grey
        endif
    endif
endfunction
