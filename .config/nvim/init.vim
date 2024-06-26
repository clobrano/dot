" Global Shortcut to full configuration
" ~/.config/nvim/

let mapleader = ' '
let maplocalleader=' '

" Plugins
call plug#begin()
Plug 'clobrano-forks/vim'  " Dracula customized theme
Plug 'NLKNguyen/papercolor-theme'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'kdheepak/tabline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'mileszs/ack.vim'
Plug 'phaazon/hop.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/MultipleSearch'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons (needed by sindrets/diffview.nvim)
"Plug 'nvim-tree/nvim-tree.lua'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

Plug 'vimlab/split-term.vim'
Plug 'yssl/QFEnter' " QFEnter allows you to open items from Vim's quickfix or location list wherever you wish.

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'folke/trouble.nvim'
Plug 'github/copilot.vim', { 'tag': 'v1.8.4' }
Plug 'aduros/ai.vim'
Plug 'jackMort/ChatGPT.nvim'
Plug 'MunifTanjim/nui.nvim'

Plug 'github/copilot.vim'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'  " vim-rhubarb for gitlab
Plug 'airblade/vim-gitgutter'
Plug 'sindrets/diffview.nvim'

Plug 'rhysd/vim-clang-format'
Plug 'ambv/black', {'for': 'python'}
Plug 'alfredodeza/pytest.vim', {'for': 'python'}
Plug 'vim-test/vim-test'

Plug 'fatih/vim-go', {'do': 'GoInstallBinaries'}
Plug 'matze/vim-meson'
Plug 'igankevich/mesonic'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

Plug 'dart-lang/dart-vim-plugin'
Plug 'akinsho/flutter-tools.nvim'

Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}

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
let test#neovim#start_normal = 1
let test#neovim#term_position = "hor botright 20"

if exists("g:neovide")
    " Put anything you want to happen only in Neovide here
    set shell=/usr/bin/zsh
    let g:neovide_transparency=1
    let g:neovide_scroll_animation_length = 0
    let g:neovide_confirm_quit=v:false
    let g:neovide_scale_factor=0.95
    set title
endif

let g:pyls_configurationSources = ["~/.pyls_config/"]

let g:NERDTreeHijackNetrw = 0 " add this line if you use NERDTree
let g:ranger_replace_netrw = 1 " open ranger when vim open a directory

" to move into new mappings.lua
nnoremap <leader>sw :set wrap<cr>
nnoremap <leader>snw :set nowrap<cr>
