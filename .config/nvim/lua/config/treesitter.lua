-- Neovim 0.12: Treesitter is built-in
-- Configure syntax highlighting and other treesitter features

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Enable treesitter highlighting for the filetype
    if pcall(vim.treesitter.start) then
      -- If treesitter parser is available, enable it
      vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end
  end,
})
