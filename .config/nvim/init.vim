" Global Shortcut to full configuration
" ~/.config/nvim/

let mapleader = ' '
let maplocalleader=' '

" Plugins

if has('packages')
    packadd! dracula
    packadd! vim-devicons
    packadd! vim-startify

    packadd! ack.vim
    packadd! any-jump.vim
    packadd! fzf
    packadd! fzf.vim
    packadd! nerdtree
    packadd! vim-g

    packadd! cscope.vim
    packadd! deoplete.nvim
    packadd! nvim-lspconfig
    packadd! taglist.vim
    packadd! vim-gutentags
    "packadd! UltiSnips
    "packadd! cscope_maps
    "packadd! vim-snippets

    packadd! gv.vim
    packadd! vim-fugitive
    packadd! vim-g
    packadd! vim-gitgutter

    packadd! black
    packadd! mesonic
    packadd! vim-go

    packadd! auto-pairs
    packadd! editorconfig-vim
    packadd! nerdcommenter
    packadd! vim-dispatch
    packadd! vim-eunuch
    packadd! vim-repeat
    packadd! vim-surround
else
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall | source ~/.config/nvim/init.vim
    endif

    call plug#begin()

    Plug 'dracula/vim'
    Plug 'mhinz/vim-startify'
    Plug 'ap/vim-buftabline'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'

    Plug 'pechorin/any-jump.vim'
    Plug 'junegunn/fzf',                     { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'mileszs/ack.vim'
    Plug 'szw/vim-g' " Quick Google lookup

    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/gv.vim'

    Plug 'neovim/nvim-lspconfig'
    Plug 'ambv/black',                       {'for': 'python'}
    Plug 'davidhalter/jedi',                 {'for': 'python'}
    Plug 'davidhalter/jedi-vim',             {'for': 'python'}
    Plug 'lambdalisue/vim-pyenv',            {'for': 'python'}
    Plug 'fatih/vim-go',                      {'do': 'GoUpdateBinaries'}

    Plug 'ambv/black',                       {'for': 'python'}
    Plug 'davidhalter/jedi',                 {'for': 'python'}
    Plug 'davidhalter/jedi-vim',             {'for': 'python'}
    Plug 'lambdalisue/vim-pyenv',            {'for': 'python'}
    Plug 'fatih/vim-go',                      {'do': 'GoUpdateBinaries'}

    Plug 'jiangmiao/auto-pairs'
    Plug 'brookhong/cscope.vim',             {'for': ['c', 'cpp']}
    Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
    Plug 'editorconfig/editorconfig-vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
    Plug 'pangloss/vim-javascript',          {'for': 'javascript'}
    Plug 'scrooloose/nerdcommenter'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-dispatch'
    Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}
    Plug 'vim-utils/vim-man',                {'for': ['c', 'cpp']}
    Plug 'matze/vim-meson'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-surround'


    "Plug 'vim-scripts/Mark--Karkat',         { 'on': 'Mark'}
    "Plug 'vim-scripts/taglist.vim'
    "Plug 'vim-syntastic/syntastic'
    "Plug 'SirVer/ultisnips'
    "Plug 'honza/vim-snippets'
    call plug#end()
endif
set nocompatible
"syntax enable
filetype on

" VimWiki {{{
let g:vimwiki_list = [
    \ {'path': '~/MyBox/notes', 'syntax': 'markdown', 'ext': '.md'},
    \ {'path': '~/MyBox/work/telit/tnotes', 'syntax': 'markdown', 'ext': '.md'} ]
let g:vimwiki_folding = 'list'
let g:vimwiki_table_mappings = 0
nnoremap <leader>vn :VimwikiDiaryNextDay
nnoremap <leader>vp :VimwikiDiaryPrevDay
" }}}

" Work custom nippets
abbr grt  !git push origin HEAD:refs/for/

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" This shall be in init.vim, otherwise for
" some reason it is not executed unless the plugin is loaded first
let Tlist_Process_File_Always=1

augroup pandoc_syntax
  autocmd! FileType vimwiki set syntax=markdown
augroup END

"call deoplete#custom#option('auto_complete_popup', "manual")
"
let g:vimwiki_folding='custom'

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
    virtual_text = false,
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

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


" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
