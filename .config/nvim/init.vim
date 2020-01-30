" Plugins                            {{{
" VimPlug configuration              {{{
let mapleader = ' '
let maplocalleader=' '
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source ~/.config/nvim/init.vim
endif

call plug#begin()

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
"}}}
" Look & Feel                        {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'crusoexia/vim-monokai'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'clobrano-forks/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
"}}}
" Search & Replace                   {{{
Plug 'MattesGroeger/vim-bookmarks'
Plug 'derekwyatt/vim-fswitch'
Plug 'junegunn/fzf',                     { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'vim-scripts/Mark--Karkat',         { 'on': 'Mark'}
Plug 'vim-scripts/taglist.vim'
Plug 'tpope/vim-abolish'
Plug 'scrooloose/nerdtree'
"}}}
"  GIT helpers                        {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'jreybert/vimagit'
"}}}
" Development                        {{{
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'vim-syntastic/syntastic'
Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-dispatch'
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'scrooloose/nerdcommenter'
Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
Plug 'brookhong/cscope.vim',             {'for': ['c', 'cpp']}
Plug 'hari-rangarajan/CCTree',           {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
Plug 'vim-utils/vim-man',                {'for': ['c', 'cpp']}
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}
Plug 'fatih/vim-go',                     {'for': 'go', 'do': 'GoUpdateBinaries'}
Plug 'pangloss/vim-javascript',          {'for': 'javascript'}
Plug 'vim-scripts/cflow-output-colorful'
"plug 'moll/vim-node',                    {'for': 'javascript'}
"Plug 'guileen/vim-node-dict',            {'for': 'javascript'}
Plug 'davidhalter/jedi',                 {'for': 'python'}
Plug 'davidhalter/jedi-vim',             {'for': 'python'}
Plug 'ambv/black',                       {'for': 'python'}
Plug 'janko/vim-test'
"Plug 'shmargum/vim-sass-colors',         {'for': 'scss'}
"}}}
" For Writers                        {{{
Plug 'ferrine/md-img-paste.vim'
"Plug 'gabrielelana/vim-markdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'gyim/vim-boxdraw'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align'
Plug 'kyuhi/vim-emoji-complete'
"Plug 'reedes/vim-lexical'          " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'      " Better autocorrections
Plug 'reedes/vim-textobj-sentence' " Treat sentences as text objects
Plug 'reedes/vim-wordy'            " Weasel words and passive voice
Plug 'sotte/presenting.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-jp/vital.vim'
Plug 'https://gitlab.com/gi1242/vim-emoji-ab.git' " https://www.webfx.com/tools/emoji-cheat-sheet/
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'chrisbra/unicode.vim'
Plug 'clobrano-forks/vim-todo-lists'
"}}}
" Generics                           {{{
Plug 'freitass/todo.txt-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'           " testing 2019-05-16
Plug 'vim-scripts/marvim' " give a name to macros
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'matze/vim-meson'
Plug 'aklt/plantuml-syntax'
Plug 'clobrano-forks/vim-slumlord'
"}}}
call plug#end()
set nocompatible
syntax enable
filetype on
"}}}

" global
" Shortcut to full configuration
" ~/.config/nvim/

" Custom Snippets {{{
source ~/.config/nvim/snippets/canonical.config.vim
source ~/.config/nvim/snippets/cisco.vim
source ~/.config/nvim/snippets/programming.vim
"}}}

" Gerrit review {{{
cabbr gerrit  !git push origin HEAD:refs/for/
" }}}

" Look&Feel {{{
command! Papercolor :colorscheme PaperColor | set background=light
command! Monokai :colorscheme monokai | set termguicolors

" }}}

" Markdown {{{
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#spell#enabled=0
"" no side folding sign
let g:pandoc#folding#fdc = 0

" clipboard images into md file
autocmd FileType markdown nmap <silent> <leader>ic :call mdip#MarkdownClipboardImage()<CR>

" preview html in tmp directory
nnoremap <leader>mp  :!pandoc -s --self-contained --toc -H ~/MyBox/me/pandoc.css % -o /tmp/markdown-preview.html --metadata title=%:t:r
nnoremap <leader>mpw :silent !xdg-open /tmp/markdown-preview.html
nnoremap <leader>mw :MarkdownPreview<cr>

nnoremap <leader>ta  vip:EasyAlign *<bar><cr>

" }}}

" Notes {{{

nnoremap <leader>d a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%y%m%d")<CR>
nnoremap <A-d> a<C-R>=strftime("%y%m%d")<CR><Esc>

nnoremap <leader>snw :set nowrap<cr>
nnoremap <leader>sw :set wrap<cr>
nnoremap gW :cd /mnt/4EBCC563BCC545E5/Store/telit

" vim todo list
let g:VimTodoListsMoveItems = 0
nnoremap <C-space> :VimTodoListsToggleItem<cr>
"}}}

" Writers {{{
" Bold text with "B"
autocmd FileType markdown,todo,plantuml let b:surround_66 = "**\r**"
" Link with "L"
autocmd FileType markdown,todo let b:surround_76 = "[\r]()"
" Strike through "X"
autocmd FileType markdown,todo let b:surround_88 = "~~\r~~"

autocmd BufNew,BufEnter *.todo set foldmethod=indent
autocmd BufNew,BufEnter *.todo set foldlevel=0

augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
"augroup lexical
  "autocmd!
  "autocmd FileType markdown,mkd call lexical#init()
  "autocmd FileType textile call lexical#init()
"augroup END

iabbr vmk ✅
iabbr xmk ❌
iabbr qmk ❔

cabbr draft e /tmp/draft.md

au FileType html,php,markdown,mmd,text,mail,gitcommit
    \ runtime macros/emoji-ab.vim
" }}}

nnoremap gN :cd ~/MyBox/notes

" startify
nnoremap gS :Startify<cr>
let g:startify_change_to_dir=0
let g:startify_files_number = 10
let g:startify_bookmarks = [ {'I': '~/MyBox/notes/me/📭Inbox.md'},
 \ {'J': '~/MyBox/notes/me/journal/📒journal.md'},
 \ {'D': '~/MyBox/notes/work/todo-txt/todo.txt'},
 \ {'i': '/mnt/4EBCC563BCC545E5/Store/telit/inbox.md'},
 \ {'t': '/mnt/4EBCC563BCC545E5/Store/telit/taskell.todo'},
 \ {'d': '/mnt/4EBCC563BCC545E5/Store/telit/todo-txt/todo.txt'} ]

let g:startify_change_to_dir = 0
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'files',     'header': ['   Files']          },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
