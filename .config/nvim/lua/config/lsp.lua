-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

-- Define server configurations first (before mason setup)
local servers = {
  gopls = {
    analyses = {
      unusedparams = true,
      shadow = true,
      fieldalignment = false,
      nilness = false,
      unusedwrite = false,
    },
    staticcheck = false,
    usePlaceholders = false,
    codelenses = {
      gc_details = false,
      generate = false,
      regenerate_cgo = false,
      tidy = true,
      upgrade_dependency = false,
      vendor = false,
    },
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
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


if true then
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('<leader>fd', vim.lsp.buf.definition, '[F]ind [D]efinition')
    --nmap('<leader>fr', function() require('telescope.builtin').lsp_references({ fname_width = 70 }) end, '[F]ind [R]eferences')
    nmap('<leader>fi', vim.lsp.buf.implementation, '[F]ind [I]mplementation')
    nmap('<leader>fD', vim.lsp.buf.type_definition, 'Find Type [D]efinition')
    --nmap('<leader>ds', function() require('telescope.builtin').lsp_document_symbols({ symbol_width = 70 }) end, '[D]ocument [S]ymbols')
    --nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[F]ind [D]eclaration')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    -- Enable inlay hints if supported
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Enable codelens if supported
    if client and client:supports_method("textDocument/codeLens") then
      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end
  end

  -- Configure LSP hover and signature help handlers to have borders
  local hover_opts = { border = "rounded", max_width = 80, max_height = 20 }
  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, hover_opts))
  end
  vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend("force", config or {}, hover_opts))
  end

  if false then
    -- already configured in lua/diagnostic.lua
    -- keeping it for documentation
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
        virtual_text = false,
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
        focusable = false,
      }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single"
      }
    )
  end

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Enable additional LSP features for Neovim 0.12+
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  capabilities.inlineCompletion = { dynamicRegistration = false }

  -- Configure each server with capabilities and settings
  for server_name, server_config in pairs(servers) do
    local config_opts = {
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Add settings if the server has them
    if server_name == "gopls" then
      config_opts.settings = { gopls = server_config }
    elseif server_name == "lua_ls" then
      config_opts.settings = { Lua = server_config.Lua }
    end

    -- Add filetypes if specified
    if server_config.filetypes then
      config_opts.filetypes = server_config.filetypes
    end

    vim.lsp.config(server_name, config_opts)
  end

  vim.lsp.config("markdown_oxide", {
    capabilities = capabilities,
    on_attach = on_attach,
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
      --{ name = 'cmdline' }, -- do not enable it. It conflicts with editing Markdown (at least)
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

  -- Autocommand to disable buffer completion specifically for Markdown
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      cmp.setup.buffer({
        --enabled = false, -- Disable cmp entirely for this buffer
        -- disabling buffer, like below, will suppress time snippets, like "@today"
        --sources = cmp.config.sources({
          --{ name = 'nvim_lsp' }, -- Keep LSP if you have markdown LSP
          --{ name = 'luasnip' },
          --{ name = 'path' },
        --}),
      })
    end,
  })

  -- `/` cmdline setup.
  cmp.setup.cmdline('/', {
    mapping = vim.tbl_extend('force', cmp.mapping.preset.cmdline(), {
      ['<Tab>'] = cmp.mapping.confirm { select = true }, -- Enable Tab for confirmation
    }),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Setup for cmdline completion specifically for ':' and '!'
  cmp.setup.cmdline(':', {
    mapping = vim.tbl_extend('force', cmp.mapping.preset.cmdline(), {
      ['<Tab>'] = cmp.mapping.confirm { select = true }, -- Enable Tab for confirmation
    }),
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline' },
      { name = 'shell_history' },
    })
  })

  -- Enable all configured servers for Neovim 0.12+
  vim.lsp.enable({ "rust_analyzer", "lua_ls", "bashls", "gopls", "pyright", "markdown_oxide" })
end
