return {
  "https://tangled.org/cuducos.me/yaml.nvim",
  ft = { "yaml" },                   -- optional
  dependencies = {
    "folke/snacks.nvim",             -- optional
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua"               -- optional
  },
  config = function()
    vim.keymap.set('n', '<leader>sy', ':YAMLView<cr>', { desc = 'Show current YAML path' })
  end
}
