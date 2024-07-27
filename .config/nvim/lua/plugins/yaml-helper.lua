return {
  "cuducos/yaml.nvim",
  ft = { "yaml" }, -- optional
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function ()
    vim.keymap.set('n', '<leader>sy', ':YAMLView<cr>', {desc = 'Show current YAML path'})
  end
}
