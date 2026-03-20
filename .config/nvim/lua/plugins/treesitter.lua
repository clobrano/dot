return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "yaml",
        "go",
        "lua",
        "python",
        "rust",
        "javascript",
        "typescript",
        "cpp",
        "c",
      },
      highlight = {
        enable = true,
      },
    })
  end
}
