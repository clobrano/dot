return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Enable treesitter hightlight for a selection of languages
    local treesitter_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = treesitter_group,
      -- Add any filetypes you want to support in this list
      pattern = { "go", "lua", "python", "rust", "javascript", "typescript", "cpp", "c" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end
}
