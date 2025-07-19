return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  filesystem = {
    window = {
      mappings = {
        ["L"] = "open_nofocus",
      },
    },
    commands = {
      open_nofocus = function(state)
        require("neo-tree.sources.filesystem.commands").open(state)
        vim.schedule(function()
          vim.cmd([[Neotree focus]])
        end)
      end,
    },
  },
  config = function()
    vim.keymap.set('n', '<leader>et', ':Neotree reveal<cr>', { silent = true, noremap = true })
  end
}
