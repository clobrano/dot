" Apply some custom formatting for filetype
" thanks to Wincent https://github.com/wincent/wincent
function! clobrano#format#customize(file, type)
    let l:pattern=join(g:clobrano_format_filetypes, '\|')
    if match(a:type, '\<\(' . l:pattern . '\)\>') != -1
        if match(a:type, '\<\(markdown\|text\)\>') != -1
            hi SpellBad gui=underline guibg=none guifg=red
            hi SpellCap guibg=none guifg=grey
        endif
    endif
endfunction
