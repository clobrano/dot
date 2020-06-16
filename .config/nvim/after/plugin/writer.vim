" Configuration to simplify edit text/markdow files
" This configuration file operates on more than one single plugin

" Pandoc {{{
    let g:pandoc#syntax#conceal#use = 1
    let g:pandoc#syntax#conceal#urls = 1
    let g:pandoc#spell#enabled=0
    "" no side folding sign
    let g:pandoc#folding#fdc = 0
    " Pandoc based preview html in tmp directory
    nnoremap <leader>mp  :!pandoc -s --self-contained --toc -H ~/MyBox/notes/air.css % -o /tmp/markdown-preview.html --metadata title=%:t:r
    nnoremap <leader>mpw :silent !xdg-open /tmp/markdown-preview.html
" }}}


" clipboard images into md file (this must belong to some plugin I don't
" remember)
autocmd FileType markdown nmap <silent> <leader>ic :call mdip#MarkdownClipboardImage()<CR>


" Markdown-preview {{{
    let g:mkdp_markdown_css = '/home/carlo/MyBox/notes/css/kult-mod.css'
    let g:mkdp_page_title = '${name}'
    nnoremap <leader>mw :MarkdownPreview<cr>
" }}}


" EasyAlign align tables
nnoremap <leader>at  vip:EasyAlign *<bar><cr>


" Add dates, short and long formats
nnoremap <leader>D a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>d a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%y%m%d")<CR>
nnoremap <A-d> a<C-R>=strftime("%y%m%d")<CR><Esc>


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
