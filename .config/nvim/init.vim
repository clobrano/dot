"
"  _   _ _____ ___        _
" | \ | | ____/ _ \__   _(_)_ __ ___
" |  \| |  _|| | | \ \ / / | '_ ` _ \
" | |\  | |__| |_| |\ V /| | | | | | |
" |_| \_|_____\___/  \_/ |_|_| |_| |_|
"
"                   __ _                       _   _                __ _ _
"   ___ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __    / _(_) | ___
"  / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \  | |_| | |/ _ \
" | (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | | |  _| | |  __/
"  \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_| |_| |_|_|\___|
"                        |___/

" Plugins                            {{{
" VimPlug configuration              {{{
let mapleader = ' '
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
Plug 'terryma/vim-multiple-cursors'
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
"}}}
" For Writers                        {{{
Plug 'ferrine/md-img-paste.vim'
Plug 'gyim/vim-boxdraw'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align'
Plug 'kyuhi/vim-emoji-complete'
Plug 'masukomi/vim-markdown-folding'
"Plug 'plasticboy/vim-markdown',           {'for': 'markdown'}
Plug 'reedes/vim-lexical'          " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'      " Better autocorrections
Plug 'reedes/vim-textobj-sentence' " Treat sentences as text objects
Plug 'reedes/vim-wordy'            " Weasel words and passive voice
Plug 'sotte/presenting.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-jp/vital.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
"}}}
" Generics                           {{{
Plug 'janko/vim-test'
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

"
" global
"

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
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_toc_autofit = 1
let vim_markdown_preview_github=1
autocmd FileType markdown set conceallevel=2
cabbr toc Toc
cabbr toch Toch
" }}}

" Notes {{{

nnoremap <leader>d a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%y%m%d")<CR>
nnoremap <A-d> a<C-R>=strftime("%y%m%d")<CR><Esc>

nnoremap <leader>snw :set nowrap<cr>
nnoremap <leader>sw :set wrap<cr>

"autocmd FileType markdown,txt source ~/.config/nvim/snippets/markdown.vim

"}}}

" Writers {{{
" Bold text with "B"
autocmd FileType markdown,todo,plantuml let b:surround_66 = "**\r**"
" Link with "L"
autocmd FileType markdown,todo let b:surround_76 = "[\r]()"

augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
augroup END

iabbr vmk ✔
iabbr xmk ✘
iabbr amk ⮕

" }}}

autocmd FileType markdown nmap <silent> <leader>ic :call mdip#MarkdownClipboardImage()<CR>

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
