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
  "savq/melange-nvim",                                       -- default light theme
  require('plugins.catpuccin'),
  "tanvirtin/monokai.nvim",                                  -- monokai colorscheme
  'ryanoasis/vim-devicons',
  "fraso-dev/nvim-listchars",                                -- toggle show listchars
  "b0o/incline.nvim",                                        -- for the floating filenames
  { 'kdheepak/tabline.nvim',  opts = { show_bufnr = true } }, -- needed to show buffer tab
  'mtdl9/vim-log-highlighting',                              -- Highlight log files
  require('plugins.tagbar'),
  require('plugins.lualine'),
  require('plugins.startify'),
  require('plugins.noice'),

  -- Git related plugins
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

  -- Notes and Markdown
  require('plugins.clipboard-image'),
  require('plugins.github-preview'),
  require('plugins.icon-picker'),
  require('plugins.markdown-preview'),
  require('plugins.marvim'), -- macro recorder
  require('plugins.orgmode'),
  require('plugins.plantuml'),
  require('plugins.taskwiki'),
  require('plugins.vimwiki'),
  require('plugins.zenmode'),
  require('plugins.render-markdown'),

  -- Code and text helpers
  'jiangmiao/auto-pairs',
  'editorconfig/editorconfig-vim',
  'scrooloose/nerdcommenter',
  'skywind3000/asyncrun.vim',
  'tpope/vim-dispatch',
  'tpope/vim-eunuch',
  'tpope/vim-surround',
  --'tpope/vim-sleuth',
  'tyru/current-func-info.vim',
  require('plugins.yaml-helper'),
  --require('plugins.nvim-highlight-colors'),
  require('plugins.trailblazer'),
  require('plugins.todo-comments'),
  {
    'pwntester/octo.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons' },
  },

  -- Debugging
  require('plugins.dap-ui'),
  require('plugins.dap'),
  require('plugins.dap-go'),
  'nvim-neotest/nvim-nio',
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',

  -- Search
  require('plugins.telescope'),
  'junegunn/fzf.vim',
  'mileszs/ack.vim',
  'vim-scripts/MultipleSearch',
  { 'francoiscabrol/ranger.vim', dependencies = { 'rbgrouleff/bclose.vim' } },
  require('plugins.oil'),
  require('plugins.neotree'),
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


  -- tests
  require('plugins.vim-test'),


  -- go
  require('plugins.vim-go'),


  -- AI
  --'github/copilot.vim',
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "mistral",      -- The default model to use.
      display_mode = "split", -- The display mode. Can be "float" or "split".
      show_prompt = false,    -- Shows the Prompt submitted to Ollama.
      show_model = true,      -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = true,   -- Never closes the window automatically.
      init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a lua function returning a command string, with options as the input parameter.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false                           -- Prints errors and the command which is run.
    }
  },
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

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
  { 'folke/which-key.nvim',      opts = {} },
  require('plugins.trouble'),
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  'kiyoon/telescope-insert-path.nvim',
  'nvim-telescope/telescope-media-files.nvim',
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

require('plugins.fzf-vim')
require('plugins.ranger')
--require('plugins.copilot')
require('plugins.incline')
require('plugins.surrounds')
require('undotree').setup()
require('plugins.octo')
require('nvim-listchars').setup({
  save_state = false
})

vim.cmd("FzfLua register_ui_select")

require('tabline').setup { enable = false }
--
--require("indent_blankline").setup {
--space_char_blankline = " ",
--show_current_context = true,
--show_current_context_start = false,
--}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
--require('plugins.telescope')
--vim.cmd [[
--cnoreabbrev ts Telescope
--nnoremap ts :Telescope<cr>
--]]

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- Enable media-file preview in telescope
require('telescope').load_extension('media_files')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>f/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  -- configure get_dropdown to expand previewer to full width of screen
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    layout_strategy = "vertical",
    winblend = 10,
    previewer = false,
    shorten_path = false,
    layout_config = {
      width = 0.95,
      height = 0.95,
      horizontal = { preview_width = 0.9 },
      vertical = { preview_height = 0.5 },
    },
  })
end, { desc = '[F]uzzily [/] search in current buffer' })

vim.keymap.set('n', '<leader>fa', require('telescope.builtin').live_grep, { desc = '[F]ind [A]all' })
vim.keymap.set('v', "<leader>fa", require("telescope-live-grep-args.shortcuts").grep_visual_selection)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').colorscheme, { desc = '[F]ind [C]olorscheme' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [k]eymaps' })
vim.keymap.set('n', '<leader>fl', require('telescope.builtin').resume, { desc = '[F]ind [L]ast search' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages, { desc = '[F]ind [M]anual' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>ft', function() require('telescope.builtin').tags({ fname_width = 70 }) end,
  { desc = '[F]ind [T]ags' })

-- Git telescope
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches, { desc = '[F]ind [G]it [B]ranches' })
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits, { desc = '[F]ind [G]it [C]ommits' })
vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_stash, { desc = '[F]ind [G]it [S]tashes' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus = false})
  autocmd CursorHoldI *.go silent! lua vim.lsp.buf.hover({focusable = false})
]]

-- [[ Configure LSP ]]

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('<leader>fd', vim.lsp.buf.definition, '[F]ind [D]efinition')
  nmap('<leader>fr', function() require('telescope.builtin').lsp_references({ fname_width = 70 }) end,
    '[F]ind [R]eferences')
  nmap('<leader>fi', vim.lsp.buf.implementation, '[F]ind [I]mplementation')
  nmap('<leader>fD', vim.lsp.buf.type_definition, 'Find Type [D]efinition')
  nmap('<leader>ds', function() require('telescope.builtin').lsp_document_symbols({ symbol_width = 70 }) end,
    '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[F]ind [D]eclaration')
  --nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  --nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  --nmap('<leader>wl', function()
  --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  --if client.server_capabilities.documentSymbolProvider then
  --navic.attach(client, bufnr)
  --end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = false,
    signs = true,
    update_in_insert = true,
  }
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
    focusable = false
  }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  }
)

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  gopls = {},
  pyright = {},
  markdown_oxide = {},
  clangd = {},
  --marksman = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

--require("lspconfig").markdown_oxide.setup({
--  capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
--  on_attach = on_attach,       -- configure your on attach config
--})



-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<Tab>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    --{ name = 'nvim_lsp' },  pre markdown_oxide
    { name = 'nvim_lsp',
      option = {
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
        }
      }
    },
    { name = 'luasnip' },
  },
  experimental = {
    ghost_text = false
  },
}
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

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

-- Register some useful macros
vim.cmd [[
" Macro to format PR Markdown links
let @p='f#��avt ��adBi- jjpbi-PRjjf[��ai jjvEh:s/ by.*]/]'
" Macro to format MR Gitlab links
let @m='f!��a lvedBi#-MRjjpa jjlvEh:s/ (!.*]/]'
" Macro to format RH Issue tracker links
let @t='llvi]dBi- #jjpa jjllvlldrep - Red Hat Issue Tracker/'
" Macro to set Wrap in current and next split (for code review with GH.nvim)
let @d='BfT��acwDONEjj'
]]

-- Which key configuration
local wk = require("which-key")
wk.register({
  g = {
    name = "+Git",
    h = {
      name = "+Github",
      c = {
        name = "+Commits",
        c = { "<cmd>GHCloseCommit<cr>", "Close" },
        e = { "<cmd>GHExpandCommit<cr>", "Expand" },
        o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
        p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
        z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
      },
      i = {
        name = "+Issues",
        p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
      },
      l = {
        name = "+Litee",
        t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
      },
      r = {
        name = "+Review",
        b = { "<cmd>GHStartReview<cr>", "Begin" },
        c = { "<cmd>GHCloseReview<cr>", "Close" },
        d = { "<cmd>GHDeleteReview<cr>", "Delete" },
        e = { "<cmd>GHExpandReview<cr>", "Expand" },
        s = { "<cmd>GHSubmitReview<cr>", "Submit" },
        z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
      },
      p = {
        name = "+Pull Request",
        c = { "<cmd>GHClosePR<cr>", "Close" },
        d = { "<cmd>GHPRDetails<cr>", "Details" },
        e = { "<cmd>GHExpandPR<cr>", "Expand" },
        o = { "<cmd>GHOpenPR<cr>", "Open" },
        p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
        r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
        t = { "<cmd>GHOpenToPR<cr>", "Open To" },
        z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
      },
      t = {
        name = "+Threads",
        c = { "<cmd>GHCreateThread<cr>", "Create" },
        n = { "<cmd>GHNextThread<cr>", "Next" },
        t = { "<cmd>GHToggleThread<cr>", "Toggle" },
      },
    },
  },
}, { prefix = "<leader>" })


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


-- lsp debug log
--vim.lsp.set_log_level 'debug'
--if vim.fn.has 'nvim-0.5.1' == 1 then
--require('vim.lsp.log').set_format_func(vim.inspect)
--end
--
