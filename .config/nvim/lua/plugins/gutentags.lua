-- If using lazy.nvim:
return {
  "ludovicchabant/vim-gutentags",
  init = function()
    -- Tell gutentags how to find the root of your Go project
    vim.g.gutentags_project_root = { ".git", "go.mod", "go.work" }

    -- Clear out the cache directory setting entirely.
    -- Gutentags will now drop a 'tags' file directly into the project root.
    vim.g.gutentags_cache_dir = nil

    -- Define what files to exclude from being indexed (replaces your `grep -v './vendor'`)
    vim.g.gutentags_ctags_exclude = {
      "*.git",
      "*.svg",
      "*.hg",
      "*/vendor/*",       -- Exclude Go vendor folder
      "*/.root/*",
      "*/bin/*",          -- Exclude compiled binaries
      "node_modules",
    }

    -- Ensure the cache directory exists
    if vim.fn.isdirectory(vim.g.gutentags_cache_dir) == 0 then
      vim.fn.mkdir(vim.g.gutentags_cache_dir, "p")
    end
  end,
}
