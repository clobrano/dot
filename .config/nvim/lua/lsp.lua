-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

require("mason").setup()
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
  ensure_installed = { "rust_analyzer", "lua_ls", "bashls", "gopls", "pyright" }
}

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition, { desc = '[F]ind [D]efinition' })
vim.keymap.set('n', '<leader>fi', vim.lsp.buf.implementation, { desc = '[F]ind [I]mplementation' })
vim.keymap.set('n', '<leader>fD', vim.lsp.buf.type_definition, { desc = 'Find Type [D]efinition' })
vim.api.nvim_create_user_command('Format', function(_) vim.lsp.buf.format() end,
  { desc = 'Format current buffer with LSP' })


if true then
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
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

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  --
  --  If you want to override the default filetypes that your language server will attach to you can
  --  define the property 'filetypes' to the map in question.
  local servers = {
    gopls = {},
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
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
        },
        telemetry = { enable = false },
      },
    },
  }

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Ensure the servers above are installed
  mason_lspconfig.setup {
    automatic_installation = true,
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        lspconfig[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        }
      end
    }
  }

  lspconfig.markdown_oxide.setup({
    capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    on_attach = on_attach,       -- configure your on attach config
  })

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
      { name = 'nvim_lsp',
        option = {
          markdown_oxide = {
            keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
          }
        }
      },
      { name = 'luasnip' },
      { name = 'natdat' },
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
end
