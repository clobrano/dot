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
  "savq/melange-nvim",                    -- default light theme
  { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
  "tanvirtin/monokai.nvim",               -- monokai colorscheme
  'ryanoasis/vim-devicons',
  "fraso-dev/nvim-listchars",             -- toggle show listchars
  "b0o/incline.nvim",                     -- for the floating filenames
  { 'kdheepak/tabline.nvim', opts = {} }, -- needed to show buffer tab
  'mtdl9/vim-log-highlighting', -- Highlight log files
  require('plugins.tagbar'),
  require('plugins.lualine'),
  --{'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {}}, -- Add indentation guides even on blank lines
  require('plugins.startify'),

  -- Git related plugins
  require('plugins.vim-fugitive'),
  require('plugins.neogit'),
  'tpope/vim-rhubarb',
  require('plugins.gv'),
  'shumphrey/fugitive-gitlab.vim', -- vim-rhubarb for gitlab
  'lewis6991/gitsigns.nvim',
  { 'sindrets/diffview.nvim',    dependencies = { 'nvim-tree/nvim-web-devicons' } },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },

  -- Notes and Markdown
  require('plugins.zenmode'),
  --{'dhruvasagar/vim-dotoo'},
  require('plugins.orgmode'),
  require('plugins.mkdnflow'),
  require('plugins.vim-markdown'),
  'freitass/todo.txt-vim',
  'artempyanykh/marksman',
  'kiyoon/telescope-insert-path.nvim',
  --require('plugins.ufo'),
  {
    -- needs plantUML and imv installed
    'Groveer/plantuml.nvim',
    config = function()
      -- calling `setup` is optional for customization
      require('plantuml').setup({})
    end
  },
  require('plugins.github-preview'),
  require('plugins.markdown-preview'),
  require('plugins.clipboard-image'),


  -- Code and text helpers
  'jiangmiao/auto-pairs',
  'editorconfig/editorconfig-vim',
  'scrooloose/nerdcommenter',
  'skywind3000/asyncrun.vim',
  'tpope/vim-dispatch',
  'tpope/vim-eunuch',
  'tpope/vim-surround',
  'tpope/vim-sleuth',
  'mfussenegger/nvim-dap',
  'tyru/current-func-info.vim',
  'lmeijvogel/vim-yaml-helper',
  require('plugins.trailblazer'),
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  { 'pwntester/octo.nvim', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'nvim-tree/nvim-web-devicons' }, },


  -- Debugging
  'leoluz/nvim-dap-go',
  'rcarriga/nvim-dap-ui',
  'nvim-neotest/nvim-nio',
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',

  -- Search
  'junegunn/fzf.vim',
  'mileszs/ack.vim',
  'vim-scripts/MultipleSearch',
  { 'francoiscabrol/ranger.vim', dependencies = { 'rbgrouleff/bclose.vim' } },
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
  'github/copilot.vim',
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
  { 'folke/which-key.nvim', opts = {} },
  {
    'folke/trouble.nvim',
    opts = { icons = false, use_diagnostic_signs = true, },
    config = function()
      vim.keymap.set('n', '<leader>tt', ':TroubleToggle<cr>')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" },
  },
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

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

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
require('plugins.copilot')
require('plugins.incline')
require('plugins.surrounds')

require('todo-comments').setup {
  gui_style = {
    fg = "BOLD",
  },
  highlight = {
    comments_only = false,
    after = "",
    keyword = "fg",
  }
}
require('gitsigns').setup {
  on_attach = function(bufnr)
    -- Setup keymaps
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', '<cmd>lua require"gitsigns".next_hunk()<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', '<cmd>lua require"gitsigns".prev_hunk()<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hp', '<cmd>lua require"gitsigns".preview_hunk()<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hu', '<cmd>lua require"gitsigns".reset_hunk()<CR>', {})
  end
}

require('undotree').setup()
require('plugins.octo')
require('nvim-listchars').setup({
  save_state = false
})
--require('litee.lib').setup()
--require('litee.gh').setup({
---- deprecated, around for compatability for now.
--jump_mode             = "invoking",
---- remap the arrow keys to resize any litee.nvim windows.
--map_resize_keys       = false,
---- do not map any keys inside any gh.nvim buffers.
--disable_keymaps       = false,
---- the icon set to use.
--icon_set              = "default",
---- any custom icons to use.
--icon_set_custom       = nil,
---- whether to register the @username and #issue_number omnifunc completion
---- in buffers which start with .git/
--git_buffer_completion = true,
---- defines keymaps in gh.nvim buffers.
--keymaps               = {
---- when inside a gh.nvim panel, this key will open a node if it has
---- any futher functionality. for example, hitting <CR> on a commit node
---- will open the commit's changed files in a new gh.nvim panel.
--open = "<CR>",
---- when inside a gh.nvim panel, expand a collapsed node
--expand = "zo",
---- when inside a gh.nvim panel, collpased and expanded node
--collapse = "zc",
---- when cursor is over a "#1234" formatted issue or PR, open its details
---- and comments in a new tab.
--goto_issue = "gd",
---- show any details about a node, typically, this reveals commit messages
---- and submitted review bodys.
--details = "d",
---- inside a convo buffer, submit a comment
--submit_comment = "<C-s>",
---- inside a convo buffer, when your cursor is ontop of a comment, open
---- up a set of actions that can be performed.
--actions = "<C-a>",
---- inside a thread convo buffer, resolve the thread.
--resolve_thread = "<C-r>",
---- inside a gh.nvim panel, if possible, open the node's web URL in your
---- browser. useful particularily for digging into external failed CI
---- checks.
--goto_web = "gx"
--}
--})
vim.cmd("FzfLua register_ui_select")

require('tabline').setup {}
--
--require("indent_blankline").setup {
--space_char_blankline = " ",
--show_current_context = true,
--show_current_context_start = false,
--}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-w>"] = require("telescope.actions").send_selected_to_qflist,
      },
      n = {
        ["p"] = require('telescope_insert_path').insert_reltobufpath_insert,
      },
    },
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.90,
      height = 0.99,
      preview_height = 0.6,
    },
    pickers = {
      lsp_references = { fname_width = 100, },
      tags = { fname_width = 100, },
      find_files = {
        mappings = {
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end
          }
        }
      },
      colorscheme = {
        enable_preview = true
      },
    },
    file_ignore_patterns = {
      "^.git/", "node_modules/", "^vendor/", "^venv/", "^.venv/"
    },
  },
  pickers = {
    find_files = {
      no_ignore = true,
    }
  },
  config = function()
  end,
}
vim.cmd [[
  cnoreabbrev ts Telescope
  nnoremap ts :Telescope<cr>
]]

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

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
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').tags, { desc = '[F]ind [T]ags' })

-- Git telescope
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches, { desc = '[F]ind [G]it [B]ranches' })
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits, { desc = '[F]ind [G]it [C]ommits' })
vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_stash, { desc = '[F]ind [G]it [S]tashes' })


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus = false})
  autocmd CursorHoldI * silent! lua vim.lsp.buf.hover({focusable = false})
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
  nmap('<leader>fr', require('telescope.builtin').lsp_references, '[F]ind [R]eferences')
  nmap('<leader>fi', vim.lsp.buf.implementation, '[F]ind [I]mplementation')
  nmap('<leader>fD', vim.lsp.buf.type_definition, 'Find Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
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
  -- rust_analyzer = {},
  marksman = {},
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
    { name = 'nvim_lsp' },
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
  let g:neovide_transparency=1
  let g:neovide_scroll_animation_length=0
  let g:neovide_confirm_quit=v:false
  let g:neovide_scale_factor=1.0
  set guifont=Source\ Code\ Pro:h11
  ]]
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- DAP (debugging) configuration
vim.keymap.set("n", "<F6>", ":lua require'dapui'.open()<cr>")
vim.keymap.set('n', '<F7>', function() require('dap').continue() end)

vim.keymap.set('n', '<F8>', function() require('dap').step_over() end)
vim.keymap.set('n', '<C-n>', function() require('dap').step_over() end)

vim.keymap.set('n', '<F9>', function() require('dap').step_into() end)
vim.keymap.set('n', '<C-s>', function() require('dap').step_into() end)

vim.keymap.set('n', '<F10>', function() require('dap').step_out() end)
vim.keymap.set('n', '<C-f>', function() require('dap').step_out() end)

vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
--vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() require('dap.ui.widgets').preview() end) Conflicts with `diffput` which I use more often
vim.keymap.set('n', '<Leader>df',
  function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end)
vim.keymap.set('n', '<Leader>dw',
  function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end)
--vim.keymap.set("n", "<F7>", ":lua require'dap'.continue()<cr>")
--vim.keymap.set("n", "<F8>", ":lua require'dap'.toggle_breakpoint()<cr>")
--vim.keymap.set("n", "<F9>", ":lua require'dap'.step_over()<cr>")
--vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<cr>")
--vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<cr>")
require('dap-go').setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details see:
  -- |dap-configuration|
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "2345",
    -- additional args to pass to dlv
    args = {}
  },
}
require('dapui').setup({})


-- Register some useful macros
vim.cmd [[
" Macro to format PR Markdown links
let @p='f#€ýavt €ýadBi- jjpbi-PRjjf[€ýai jjvEh:s/ by.*]/]'
" Macro to format MR Gitlab links
let @m='f!€ýa lvedBi#-MRjjpa jjlvEh:s/ (!.*]/]'
" Macro to format RH Issue tracker links
let @t='llvi]dBi- #jjpa jjllvlldrep - Red Hat Issue Tracker/'
" Macro to set Wrap in current and next split (for code review with GH.nvim)
let @d='BfT€ýacwDONEjj'
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

-- I want the todo.txt shortcuts, but the ability to work with vimwiki (find references for example)
-- so I will use a todo file with markdown extension, that should be recognized by vimwiki and
-- load all its properties for the buffer, and also set the filetype to todo to get todo.txt mappings.
vim.cmd [[
  autocmd BufNewFile,BufRead todo.md set filetype=todo
]]

-- set textwidth to 0 for markdown files
vim.cmd [[
  autocmd BufNewFile,BufRead *.md
    \ set textwidth=0 |
    \ set shiftwidth=2 |
    \ nnoremap <M-]> wv<C-]> |
    \ highlight Folded guibg=none guifg=#51576d
]]

-- orgmode configuration
vim.cmd [[
  autocmd BufNewFile,BufRead *.org set shiftwidth=2
]]

-- I will lose color highlighting this way, so I also want to set it manually:
-- red for (A), orange for (B), cyan for (C), normal for all the other (not working)
vim.cmd [[
  autocmd BufNewFile,BufRead todo.md
    \ syntax match TodoA '^([aA])' |
    \ highlight TodoA ctermfg=red guifg=red gui=bold |
    \ highlight TodoB ctermfg=yellow guifg=yellow gui=bold |
    \ highlight TodoC ctermfg=cyan guifg=cyan gui=bold
]]

vim.cmd [[
  cnoreabbrev fontnote set guifont:Source\ Code\ Pro\ Light:h12
  set shiftwidth=2
  highlight Folded guibg=none
]]

vim.cmd [[
  let g:dotoo#agenda#files=['~/Documents/RedHatVault/*.dotoo', '~/Dropbox/notes/*.dotoo']
]]
