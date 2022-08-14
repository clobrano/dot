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



