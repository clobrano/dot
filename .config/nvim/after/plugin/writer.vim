" Configuration to simplify edit text/markdow files
" This configuration file operates on more than one single plugin

nnoremap gn :lcd ~/MyBox/notes
nnoremap gw :lcd ~/MyBox/work/telit/tnotes

if isdirectory($HOME . "/.config/nvim/plugged/vim-pandoc-syntax")
    let g:pandoc#syntax#conceal#use = 1
    let g:pandoc#syntax#conceal#urls = 1
    let g:pandoc#spell#enabled=1
    " no side folding sign
    let g:pandoc#folding#fdc = 1
endif

if executable("pandoc")
    " Pandoc based preview html in tmp directory
    nnoremap <leader>pm  :!pandoc -s --self-contained -c ~/MyBox/notes/projects/css/kult-mod.css % -t html -o /tmp/markdown-preview.html --metadata pagetitle=%:t:r
    nnoremap <leader>pmf :!pandoc -s --self-contained -c ~/MyBox/notes/projects/css/kult-mod.css % -t html -F mermaid-filter -o /tmp/markdown-preview.html --metadata pagetitle=%:t:r
    nnoremap <leader>pmw :silent !xdg-open /tmp/markdown-preview.html
endif


if isdirectory($HOME . "/.config/nvim/plugged/md-im-paste")
    " clipboard images into md file
    autocmd FileType markdown nmap <silent> <leader>ip :call mdip#MarkdownClipboardImage()<CR>
endif

if isdirectory($HOME . "/.config/nvim/plugged/markdown-preview")
    "let g:mkdp_markdown_css = '/home/carlo/MyBox/notes/projects/css/kult-mod.css'
    let g:mkdp_page_title = '${name}'
    nnoremap <leader>mw :MarkdownPreview<cr>
endif

" Add dates, short and long formats
nnoremap <leader>D a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>d a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%d.%m.%y")<CR>
nnoremap <A-d> a<C-R>=strftime("%d.%m.%y")<CR><Esc>
inoremap hhmm <C-R>=strftime("%H:%M")<CR>
inoremap wwd <C-r>=strftime("%a")<CR>

if isdirectory($HOME . "/.config/nvim/plugged/vim-surround")
    " Bold text with "B"
    autocmd FileType markdown,todo,plantuml let b:surround_{char2nr("B")} = "**\r**"
    " Link with "L"
    autocmd FileType markdown,todo let b:surround_{char2nr("L")} = "[\r]()"
    " Wiki link with "l"
    autocmd FileType markdown,todo let b:surround_{char2nr("l")} = "[[\r]]"
    " Strike through "X"
    autocmd FileType markdown,todo let b:surround_{char2nr("X")} = "~~\r~~"
endif

if isdirectory($HOME . "/.config/nvim/plugged/vim-litecorrect")
    augroup litecorrect
        autocmd!
        autocmd FileType markdown,mkd call litecorrect#init()
        autocmd FileType textile call litecorrect#init()
    augroup END
endif


" Lines, move up/down
nnoremap <C-Up>   :<C-u>silent! move-2<CR>==
nnoremap <C-Down> :<C-u>silent! move+<CR>==
xnoremap <C-Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <C-Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv

" Emoji abbreviations
iabbr vmk 🗸
iabbr xmk 🗙
iabbr qmk ❔
iabbr lmk ↶
iabbr rmk ↷

" Open a draft file with a command `draft`
cabbr draft e /tmp/draft.md

if isdirectory($HOME . "/.config/nvim/plugged/vim-emoji-ab")
    " Enable emoji support on text related filetypes
    au FileType html,php,markdown,mmd,text,mail,gitcommit
        \ runtime macros/emoji-ab.vim
endif

" indent/de-indent in insertmode (de-dent is <C-d> by default)
inoremap <C-i> <C-t>
