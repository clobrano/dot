" global
" Shortcut to full configuration
" ~/.config/nvim/

let mapleader = ' '
let maplocalleader=' '

" Plugins
" VimPlug configuration              {{{
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
"Plug 'voldikss/vim-floaterm'
Plug 'dracula/vim'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'clobrano-forks/onehalf', {'rtp': 'vim/'}
Plug 'ryanoasis/vim-devicons'
"}}}
" Search & Replace                   {{{
Plug 'junegunn/fzf',                     { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'vim-scripts/Mark--Karkat',         { 'on': 'Mark'}
Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree'
"}}}
"  GIT helpers                        {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'  " <leader>gm to show line's commit message
Plug 'jreybert/vimagit'
Plug 'junegunn/gv.vim'
"}}}
" Development                        {{{
Plug 'ambv/black',                       {'for': 'python'}
Plug 'davidhalter/jedi',                 {'for': 'python'}
Plug 'davidhalter/jedi-vim',             {'for': 'python'}
Plug 'fatih/vim-go',                      {'do': 'GoUpdateBinaries'}
"Plug 'guileen/vim-node-dict',            {'for': 'javascript'}
"Plug 'hari-rangarajan/CCTree',           {'for': ['c', 'cpp']}
"Plug 'janko/vim-test'
"Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
"Plug 'shmargum/vim-sass-colors',         {'for': 'scss'}
"Plug 'vim-scripts/cflow-output-colorful'
"plug 'moll/vim-node',                    {'for': 'javascript'}
Plug 'jiangmiao/auto-pairs'
Plug 'arrufat/vala.vim'
Plug 'brookhong/cscope.vim',             {'for': ['c', 'cpp']}
Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
Plug 'pangloss/vim-javascript',          {'for': 'javascript'}
Plug 'pechorin/any-jump.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-dispatch'
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}
Plug 'vim-syntastic/syntastic'
Plug 'vim-utils/vim-man',                {'for': ['c', 'cpp']}
"}}}
" For Writers                        {{{
Plug 'ferrine/md-img-paste.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vimwiki/vimwiki'
Plug 'gyim/vim-boxdraw'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kyuhi/vim-emoji-complete'
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
"Plug 'clobrano-forks/vim-todo-lists'
"}}}
" Generics                           {{{
Plug 'w0rp/ale'           " testing 2019-05-16
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'matze/vim-meson'
Plug 'aklt/plantuml-syntax'
Plug 'liuchengxu/vim-which-key'
Plug 'blindFS/vim-taskwarrior'
"}}}
call plug#end()
set nocompatible
syntax enable
filetype on

" VimWiki {{{
let g:vimwiki_list = [
    \ {'path': '~/MyBox/notes',
        \ 'syntax': 'markdown', 
        \ 'ext': '.md',
        \ 'path_html': '~/MyBox/notes/_site'} ]
let g:vimwiki_folding = 'list'
let g:vimwiki_table_mappings = 0
nnoremap <leader>vn :VimwikiDiaryNextDay
nnoremap <leader>vp :VimwikiDiaryPrevDay
" }}}

" Work custom nippets {{{
cabbr gerrit  !git push origin HEAD:refs/for/
" }}}

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" This shall be in init.vim, otherwise for
" some reason it is not executed unless the plugin is loaded first
let Tlist_Process_File_Always=1

augroup pandoc_syntax
  autocmd! FileType vimwiki set syntax=markdown.pandoc
augroup END


