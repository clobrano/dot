" Configuration to simplify edit text/markdow files
" This configuration file operates on more than one single plugin

nnoremap gN :lcd ~/MyBox/notes
nnoremap gW :lcd ~/MyBox/work/telit/tnotes

" Pandoc
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#spell#enabled=1
" no side folding sign
let g:pandoc#folding#fdc = 1
" Pandoc based preview html in tmp directory
nnoremap <leader>pm  :!pandoc -s --self-contained -c ~/MyBox/notes/projects/css/kult-mod.css % -t html -o /tmp/markdown-preview.html --metadata pagetitle=%:t:r
nnoremap <leader>pmf :!pandoc -s --self-contained -c ~/MyBox/notes/projects/css/kult-mod.css % -t html -F mermaid-filter -o /tmp/markdown-preview.html --metadata pagetitle=%:t:r
nnoremap <leader>pmw :silent !xdg-open /tmp/markdown-preview.html
" end-pandoc


" clipboard images into md file (this must belong to some plugin I don't
" remember)
autocmd FileType markdown nmap <silent> <leader>ip :call mdip#MarkdownClipboardImage()<CR>

" Markdown-preview
"let g:mkdp_markdown_css = '/home/carlo/MyBox/notes/projects/css/kult-mod.css'
let g:mkdp_page_title = '${name}'
nnoremap <leader>mw :MarkdownPreview<cr>

" EasyAlign align tables
nnoremap <leader>at  vip:EasyAlign *<bar><cr>


" Add dates, short and long formats
nnoremap <leader>D a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>d a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%d.%m.%y")<CR>
nnoremap <A-d> a<C-R>=strftime("%d.%m.%y")<CR><Esc>
inoremap hhmm <C-R>=strftime("%H:%M")<CR>
inoremap wwd <C-r>=strftime("%a")<CR>

" The following works with surround plugin
" Bold text with "B"
autocmd FileType markdown,todo,plantuml let b:surround_66 = "**\r**"
" Link with "L"
autocmd FileType markdown,todo let b:surround_76 = "[\r]()"
" Strike through "X"
autocmd FileType markdown,todo let b:surround_88 = "~~\r~~"

augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END

" Nice abbreviation when emoji support is not enable
iabbr vmk ✅
iabbr xmk ❌
iabbr qmk ❔

" Open a draft file with a command `draft`
cabbr draft e /tmp/draft.md

" Enable emoji support on text related filetypes
au FileType html,php,markdown,mmd,text,mail,gitcommit
    \ runtime macros/emoji-ab.vim

" Requires Markdown or pandoc plugins
nnoremap tv :Tocv<cr>
