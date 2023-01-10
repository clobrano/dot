lspconfig = require'lspconfig'

lspconfig.clangd.setup{
    default_config = {
        cmd = { 'clangd -header-insertion=never' }
    } 
}

lspconfig.gopls.setup{}

lspconfig.rust_analyzer.setup({})

lspconfig.pylsp.setup{
  settings = {
    formatCommand = {"black"},
    pylsp = {
      plugins = {
        pyls_flake8 = {
            enabled = true,
            ignore = "E501"
        },
        pylint = { enabled = true},
        pycodestyle = {
            enabled = true,
            ignore = "E501"
        },
      },
    }
  }
}

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
      },
    },
  }
})
