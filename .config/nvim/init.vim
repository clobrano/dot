" Global Shortcut to full configuration
" ~/.config/nvim/

let mapleader = ' '
let maplocalleader=' '

" Plugins
call plug#begin()
Plug 'dracula/vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'ap/vim-buftabline'

Plug 'mileszs/ack.vim'
Plug 'pechorin/any-jump.vim'
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
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'brookhong/cscope.vim',             {'for': ['c', 'cpp']}
Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-scripts/taglist.vim'
Plug 'ludovicchabant/vim-gutentags'

"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'ambv/black', {'for': 'python'}
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
Plug 'vimsence/vimsence'

Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}
call plug#end()
set nocompatible
"syntax enable
filetype on

" Work custom nippets
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

nnoremap <leader>h :find %<.

set nocscopeverbose

lua << EOF
virtual_text = {}

virtual_text.show = true

virtual_text.toggle = function()
    virtual_text.show = not virtual_text.show
    vim.lsp.diagnostic.display(
        vim.lsp.diagnostic.get(0, 1),
        0,
        1,
        {virtual_text = virtual_text.show}
    )
end

vim.api.nvim_set_keymap(
    'n',
    '<Leader>lv',
    '<Cmd>lua virtual_text.toggle()<CR>',
    {silent=true, noremap=true}
)
EOF

" TODO move it to a dedicated file or in vimrc.local
let g:posero_default_mappings = 1

lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = false,
    signs = true,
    update_in_insert = true,
    }
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single"
    }
)
EOF

lua << EOF
require'lspconfig'.clangd.setup{}
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end
EOF

set completeopt=menu,menuone,noselect

lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body)

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      --['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      { name = 'ultisnips' },

      { name = 'buffer' },
    }
  })

  -- Setup lspconfig.
  require('lspconfig').clangd.setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
EOF

lua require'lspconfig'.pylsp.setup{}
lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.rust_analyzer.setup({})
lua << EOF
require("flutter-tools").setup{} -- use defaults
EOF

" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc

autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
autocmd CursorHoldI * silent! lua vim.lsp.buf.hover({focusable=false})

lua <<EOF
require'nvim-treesitter.configs'.setup {
ensure_installed = { "c", "cpp", "python", "go", "vim", "rust" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
ignore_install = { }, -- List of parsers to ignore installing
highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
},
}
EOF

" Vim-g configuration
let g:vim_g_query_url="https://duckduckgo.com/?q="
let g:vim_g_command = "Wsearch"

" Discord Rich presence configuration
let g:vimsence_discord_flatpak=1
let g:vimsence_client_id = '907672473938575380'
let g:vimsence_small_text = 'NeoVim'
let g:vimsence_small_image = 'neovim'

if isdirectory($HOME . "/TMT/carlolo")
    let g:vimsence_editing_details = 'Editing some file'
    let g:vimsence_editing_state = 'Working on secret project'
else
    let g:vimsence_editing_details = 'Editing {}'
    let g:vimsence_editing_state = 'Working on {}'
endif
let g:vimsence_file_explorer_text = 'In NERDTree'
let g:vimsence_file_explorer_details = 'Looking for files'
"let g:vimsence_custom_icons = {'filetype': 'iconname'}
"
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
