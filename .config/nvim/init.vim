" Global Shortcut to full configuration
" ~/.config/nvim/

let mapleader = ' '
let maplocalleader=' '

" Plugins
call plug#begin()
Plug 'clobrano-forks/vim'  " Dracula customized theme
Plug 'NLKNguyen/papercolor-theme'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'ap/vim-buftabline'

Plug 'mileszs/ack.vim'
"Plug 'pechorin/any-jump.vim'
Plug 'phaazon/hop.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/MultipleSearch'

Plug 'scrooloose/nerdtree'
Plug 'derekwyatt/vim-fswitch'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

Plug 'vimlab/split-term.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'brookhong/cscope.vim',             {'for': ['c', 'cpp']}
Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-scripts/taglist.vim'
Plug 'ludovicchabant/vim-gutentags'

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'rhysd/vim-clang-format'
Plug 'ambv/black', {'for': 'python'}
Plug 'vim-test/vim-test'
Plug 'alfredodeza/pytest.vim', {'for': 'python'}

Plug 'fatih/vim-go', {'do': 'GoUpdateBinaries'}
Plug 'matze/vim-meson'
Plug 'igankevich/mesonic'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

Plug 'dart-lang/dart-vim-plugin'
Plug 'nvim-lua/plenary.nvim'
Plug 'akinsho/flutter-tools.nvim'

Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}

Plug 'wakatime/vim-wakatime'
call plug#end()
set nocompatible
"syntax enable
filetype on

" Work custom snippets
abbr grt  !git push origin HEAD:refs/for/

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" This shall be in init.vim, otherwise for
" some reason it is not executed unless the plugin is loaded first
let Tlist_Process_File_Always=1

inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
    \ "find . -path '*/\.*' -prune -o -print ",
    \ fzf#wrap({'dir': expand('%:p:h')}))

set nocscopeverbose
set completeopt=menu,menuone,noselect

lua require('basic')


" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
autocmd CursorHoldI * silent! lua vim.lsp.buf.hover({focusable=false})

" Vim-g configuration
let g:vim_g_query_url="https://duckduckgo.com/?q="
let g:vim_g_command = "Wsearch"

nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

let test#strategy = 'neovim'

set guifont=Source\ Code\ Pro:h10
