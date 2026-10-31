return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    default_mappings = true,
    mappings = {
      set = "m", -- ma sets mark a
      delete = "dm", -- dma deletes mark a

      set_next = "<leader>ms",
      toggle = "<leader>mt",
      next = "<leader>mj",
      prev = "<leader>mk",
      preview = "<leader>mv",

      delete_line = "<leader>mD",
      delete_buf = "<leader>mB",
      delete_bookmark = "<leader>mbd",
      next_bookmark = "<leader>mbj",
      prev_bookmark = "<leader>mbk",
    },
  },
}
