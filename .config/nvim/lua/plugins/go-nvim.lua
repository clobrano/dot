return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- lsp_keymaps = false,
    -- other options
  },
  config = function(_, opts)
    require("go").setup(opts)
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require('go.format').goimports()
      end,
      group = format_sync_grp,
    })
    vim.keymap.set("n", "<leader>goa", ":GoAlt<cr>", { desc="[GO] [A]lternate file", noremap=true, silent=true })
    vim.keymap.set("n", "<leader>gob", ":GoBuild<cr>", { desc="[GO] [B]uild", noremap=true, silent=true })
    vim.keymap.set("n", "<leader>goi", ":GoInstall<cr>", { desc="[GO] [I]nstall", noremap=true, silent=true })
    vim.keymap.set("n", "<leader>gotf", ":GoTest<cr>", { desc="[GO] [T]est", noremap=true, silent=true })
    vim.keymap.set("n", "<leader>gotf", ":GoTestFile<cr>", { desc="[GO] [T]est this [F]ile", noremap=true, silent=true })
    vim.keymap.set("n", "<leader>gop", ":GoTestPackage<cr>", { desc="[GO] [T]est [P]ackage", noremap=true, silent=true })

    -- Generate Tags with gotags
    vim.api.nvim_create_user_command("GoTags",
      function()
        vim.fn.system(  ":!gotags `find . -name '*.go' | grep -v './vendor'` > tags<cr>")
      end,
      {})

  end,
  event = { "CmdlineEnter" },
  ft = { "go", 'gomod' },
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}
