-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

-- Define server configurations
local servers = {
  gopls = {
    -- Static analysis checks
    analyses = {
      unusedparams = true,    -- Warn about unused function parameters
      shadow = true,          -- Warn about shadowed variables
      fieldalignment = false, -- Check struct field alignment (disabled for performance)
      nilness = false,        -- Check for potential nil pointer dereferences
      unusedwrite = false,    -- Check for unused variable assignments
    },
    staticcheck = false,      -- Enable additional static checks beyond standard analyses
    usePlaceholders = false,  -- Don't insert placeholders in completion items

    -- Code lens actions shown in editor
    codelenses = {
      gc_details = true,         -- Disable GC optimization details lens
      generate = true,           -- Disable go generate lens
      regenerate_cgo = false,    -- Disable cgo regeneration lens
      tidy = true,               -- Show lens for tidying imports (add/remove unused)
      upgrade_dependency = true, -- Show lens for upgrading dependencies to newer versions
      vendor = true,             -- Show lens for managing vendored dependencies
    },

    -- Inlay hints displayed in editor
    hints = {
      assignVariableTypes = false,    -- Show inferred variable types
      compositeLiteralFields = false, -- Show field names in struct literals
      compositeLiteralTypes = false,  -- Show struct types in literals
      constantValues = false,         -- Show inferred constant values
      functionTypeParameters = false, -- Show type parameters in function calls
      parameterNames = false,         -- Show parameter names in function calls
      rangeVariableTypes = false,     -- Show types of range loop variables
    },

    -- Enable semantic tokens (required for proper syntax highlighting in 0.12)
    semanticTokens = true,
  },
  pyright = {},
  markdown_oxide = {},
  clangd = {},
  bashls = {
    filetypes = { "sh", "zsh", "bash" },
  },
  lua_ls = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      },
      telemetry = { enable = false },
    },
  },
  harper_ls = {
    filetypes = { "markdown" },
    settings = {
      ["harper-ls"] = {
        userDictPath = "~/.config/nvim/spell/en.utf-8.add",
        diagnosticSeverity = "hint",
        linters = {
          ExpandMemoryShorthands = false,
          LongSentences = false,
          NumericRangeEnDash = false,
          OxfordComma = false,
          SentenceCapitalization = false,
          SpellCheck = true,
          SplitWords = false,
          ToDoHyphen = false,
          UnclosedQuotes = false,
          UseEllipsisCharacter = false,
          UseTitleCase = false,
        },
        isolateEnglish = true,
        markdown = {
          -- [ignores this part]()
          -- [[ also ignore wiki links ]]
          IgnoreLinkTitle = true,
        }
      },
    },
  },
}

-- Ensure servers are installed
mason_lspconfig.setup {
  automatic_installation = true,
  ensure_installed = vim.tbl_keys(servers),
}

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition, { desc = '[F]ind [D]efinition' })
vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation, { desc = '[F]ind [I]mplementation' })
vim.keymap.set('n', '<leader>fD', vim.lsp.buf.type_definition, { desc = 'Find Type [D]efinition' })
vim.api.nvim_create_user_command('Format', function(_) vim.lsp.buf.format() end,
  { desc = 'Format current buffer with LSP' })

-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>la', require('actions-preview').code_actions, '[L]anguage [A]ction')

  nmap('<leader>fd', vim.lsp.buf.definition, '[F]ind [D]efinition')
  nmap('<leader>fi', vim.lsp.buf.implementation, '[F]ind [I]mplementation')
  nmap('<leader>fD', vim.lsp.buf.type_definition, 'Find Type [D]efinition')

  -- K mapping is now handled by hover.nvim plugin
  --nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[F]ind [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Signature help handler (hover is now handled by hover.nvim plugin)
--local sig_help_opts = { border = "rounded", max_width = 80, max_height = 20 }
--vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  --vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend("force", config or {}, sig_help_opts))
--end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable additional LSP features for Neovim 0.12+
capabilities.textDocument.colorProvider = { dynamicRegistration = false }
capabilities.inlineCompletion = { dynamicRegistration = false }
capabilities.textDocument.inlayHint = { dynamicRegistration = true }
capabilities.textDocument.codeLens = { dynamicRegistration = false }
-- Enable semantic tokens for syntax highlighting
capabilities.textDocument.semanticTokens = {
  dynamicRegistration = false,
  requests = { range = false, full = true },
  tokenTypes = {
    "namespace", "type", "class", "enum", "interface", "struct",
    "typeParameter", "parameter", "variable", "property", "enumMember",
    "event", "function", "method", "macro", "keyword", "modifier",
    "comment", "string", "number", "regexp", "operator", "decorator",
  },
  tokenModifiers = {
    "declaration", "definition", "readonly", "static", "deprecated",
    "abstract", "async", "modification", "documentation", "defaultLibrary",
  },
}

-- Configure each server with capabilities and settings
local settings_map = {
  gopls = function(config) return { gopls = config } end,
  lua_ls = function(config) return { Lua = config.Lua } end,
}

for server_name, server_config in pairs(servers) do
  local config_opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  -- Add settings if available
  if settings_map[server_name] then
    config_opts.settings = settings_map[server_name](server_config)
  elseif server_config.settings then
    config_opts.settings = server_config.settings
  end

  -- Add filetypes if specified
  if server_config.filetypes then
    config_opts.filetypes = server_config.filetypes
  end

  vim.lsp.config(server_name, config_opts)
end

-- Enable all configured servers
vim.lsp.enable(vim.tbl_keys(servers))

-- Stop harper_ls
local function stop_harper_ls()
  for _, client in ipairs(vim.lsp.get_clients({ name = "harper_ls" })) do
    client:stop()
  end
end
vim.api.nvim_create_user_command('StopHarperLs', stop_harper_ls, { desc = 'Stop Harper LSP server' })
vim.keymap.set('n', '<leader>sh', stop_harper_ls, { desc = '[S]top [H]arper LSP' })

-- Enable inlay hints globally
vim.lsp.inlay_hint.enable(true)

-- Autocmd to enable codelens when gopls attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "gopls" then
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end
  end
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  sources = {
    { name = 'nvim_lsp',
      option = {
        markdown_oxide = {
          -- Added '@' to the keyword_pattern to allow snippets starting with '@'
          keyword_pattern = [[\(\k\| \|\/\|#\|@\)\+]]
        }
      }
    },
    { name = 'luasnip' },
    { name = 'natdat' },
    { name = 'buffer' },
    { name = 'path' },
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
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  experimental = {
    ghost_text = false
  },
}

-- Autocommand for Markdown-specific completion (enable natdat, disable buffer/LSP noise)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    cmp.setup.buffer({
      sources = {
        { name = 'natdat' },  -- Natural date completion with @ trigger
        { name = 'path' },    -- File path completion
      }
    })
  end,
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = vim.tbl_extend('force', cmp.mapping.preset.cmdline(), {
    ['<Tab>'] = cmp.mapping.confirm { select = true },
  }),
  sources = {
    { name = 'buffer' }
  }
})

-- Setup for cmdline completion specifically for ':' and '!'
cmp.setup.cmdline(':', {
  mapping = vim.tbl_extend('force', cmp.mapping.preset.cmdline(), {
    ['<Tab>'] = cmp.mapping.confirm { select = true },
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'shell_history' },
  })
})
