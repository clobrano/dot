return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",     -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  filesystem = {
    window = {
      mappings = {
        -- disable open_with_window_picker because it conflicts with my movement keys and
        -- the needed plugin is also not installed
        ['w'] = 'none'
      }
    },
  },
  config = function()
    require('neo-tree').setup {
      filesystem = {
        bind_to_cwd = false,
        --hijack_netrw_behavior = "disabled",
      }
    }
    vim.keymap.set('n', '<leader>nt', ':Neotree reveal<cr>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>nb', ':Neotree buffers<cr>', { desc = '[F]ind [B]uffers' })
  end
}
