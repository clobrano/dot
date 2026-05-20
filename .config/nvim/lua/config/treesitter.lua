-- Neovim 0.12: Treesitter is built-in
-- Configure syntax highlighting and other treesitter features

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype == '' then
      -- Start treesitter for this buffer if a parser is available
      local ok = pcall(vim.treesitter.start, buf)
      if ok then
        vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
      end
    end
  end,
})
