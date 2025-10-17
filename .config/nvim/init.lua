-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- UI
  "savq/melange-nvim", -- default light theme
  require('plugins.catpuccin'),
  require('plugins.onedark'),
  require('plugins.dracula'),
  { 'projekt0n/github-nvim-theme', name = 'github-theme' },
  "tanvirtin/monokai.nvim", -- monokai colorscheme
  'ryanoasis/vim-devicons',
  require('plugins.nvim-listchars'),
  'mtdl9/vim-log-highlighting', -- Highlight log files
  'xiyaowong/transparent.nvim',
  require('plugins.tagbar'),
  --require('plugins.tabline'), -- needed to show buffers names on top
  require('plugins.lualine'),
  require('plugins.persisted'),
  --require('plugins.startify'),
  --require('plugins.noice'),
  { 'dhruvasagar/vim-table-mode' },

  -- Git/Revision related plugins
  require('plugins.vim-fugitive'),
  require('plugins.neogit'),
  'tpope/vim-rhubarb',
  require('plugins.gv'),
  'shumphrey/fugitive-gitlab.vim', -- vim-rhubarb for gitlab
  require('plugins.gitsigns'),
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
  { "Gelio/cmp-natdat",       config = true },
  require('plugins.gh'),
  require('plugins.octo'),

  -- Notes and Markdown
  require('plugins.clipboard-image'),
  require('plugins.icon-picker'),
  require('plugins.markdown-preview'),
  require('plugins.marvim'), -- macro recorder
  require('plugins.orgmode'),
  { "weirongxu/plantuml-previewer.vim", dependencies = { 'tyru/open-browser.vim', 'aklt/plantuml-syntax' } },
  require('plugins.taskwiki'),
  require('plugins.vimwiki'),
  --require('plugins.m_taskwarrior_d'),
  require('plugins.render-markdown'),
  --require('plugins.github-preview'),
  --require('plugins.plantuml'),
  --require('plugins.zenmode'),
  --require('plugins.peek'),
  --require('plugins.snacks'),

  -- Code and text helpers
  'jiangmiao/auto-pairs',
  'editorconfig/editorconfig-vim',
  'scrooloose/nerdcommenter',
  'skywind3000/asyncrun.vim',
  'tpope/vim-dispatch',
  'tpope/vim-eunuch',
  'tpope/vim-surround',
  require('plugins.sleuth'),
  'tyru/current-func-info.vim',
  require('plugins.yaml-helper'),
  --require('plugins.nvim-highlight-colors'),
  require('plugins.trailblazer'),
  require('plugins.todo-comments'),
  require('plugins.other'),
  require('plugins.nvim-window-picker'),

  -- Debugging
  require('plugins.dap-ui'),
  require('plugins.dap'),
  require('plugins.dap-go'),
  'nvim-neotest/nvim-nio',
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',

  -- Search/Navigation
  'junegunn/fzf.vim',
  'mileszs/ack.vim',
  'vim-scripts/MultipleSearch',
  --{ 'francoiscabrol/ranger.vim', dependencies = { 'rbgrouleff/bclose.vim' } },
  require('plugins.oil'),
  require('plugins.neotree'),
  require('plugins.mini'),
  require('plugins.vim-g'),
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
  require('plugins.leap'),
  require('plugins.telescope'),
  --require('plugins.journal'),


  -- tests
  require('plugins.vim-test'),


  -- go
  --require('plugins.vim-go'),
  require('plugins.go-nvim'),


  -- AI
  --'github/copilot.vim',
  --require('plugins.avante'),
  --require('plugins.avante-remote'),
  --require('plugins.codecompanion'),
  --require('plugins.gen-nvim'),

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  require('plugins.mason-lspconfig'),
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',     -- Snippet Engine & its associated nvim-cmp source
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp', -- Adds LSP completion capabilities
      'hrsh7th/cmp-cmdline',  -- Source for vim's cmdline
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets', -- Adds a number of user-friendly snippets
    },
  },

  -- Useful plugin to show you pending keybinds.
  require('plugins.which-key'),
  --require('plugins.trouble'),
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  'kiyoon/telescope-insert-path.nvim',
  'nvim-telescope/telescope-media-files.nvim',
  require('plugins.luasnip-telescope'),

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  require('plugins.treesitter'),
  require('plugins.treesitter-context'),

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}


-- Setups
require('lazy').setup(plugins, {})
require('autocmds')
require('settings')
require('mappings')
require('diagnostic')
require('lsp')
require('ai')

-- Setup neovim lua configuration
--require('neodev').setup()


require('plugins.fzf-vim')
require('plugins.ranger')
--require('plugins.copilot')
--require('plugins.incline')
require('plugins.surrounds')
require('undotree').setup()

vim.cmd("FzfLua register_ui_select")
--require("ibl").setup()

-- Neovide custom settings
if vim.fn.exists('g:neovide') == 1 then
  vim.cmd [[
  set shell=/usr/bin/zsh
  set title
  let g:neovide_theme = 'auto'
  let g:neovide_transparency=0.98
  let g:neovide_scroll_animation_length=0
  let g:neovide_confirm_quit=v:false
  let g:neovide_scale_factor=1.05
  set guifont=Source\ Code\ Pro:h11
  ]]
end


-- markdown preview configuration
vim.g.mkdp_images_path = '/home/clobrano/Documents/RedHatVault/attachments'

-- configuration for for markdown files
vim.cmd [[
  autocmd BufNewFile,BufRead *.md
    \ nnoremap <M-]> :VimWikiVSplitLink<cr>
    "\ highlight Folded guibg=none guifg=#51576d
]]

-- configuration for for lua files
vim.cmd [[
  autocmd BufNewFile,BufRead *.lua
    \ set shiftwidth=2
]]

-- orgmode configuration
vim.cmd [[
  autocmd BufNewFile,BufRead *.org set shiftwidth=2
]]

vim.cmd [[
  cnoreabbrev fontnote set guifont:Source\ Code\ Pro\ Light:h12
  "highlight Folded guibg=none
  set foldlevel=10
]]

vim.cmd [[
"highlight the entire block quote
syn match Comment "^> .*"
  ]]

vim.cmd [[
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
]]

vim.cmd [[
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path="/home/clobrano/Apps/plantuml-gplv2-1.2025.1.jar"
]]

-- lsp debug log
--vim.lsp.set_log_level 'debug'
--if vim.fn.has 'nvim-0.5.1' == 1 then
--require('vim.lsp.log').set_format_func(vim.inspect)
--end
