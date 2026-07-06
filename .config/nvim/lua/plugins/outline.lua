return  {
  "hedyhli/outline.nvim",
  enabled = true,
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    {
      "<leader>toc",
      function()
        require("outline").toggle()
        -- Small delay to let the window open before focusing
        vim.defer_fn(function()
          local wins = vim.api.nvim_list_wins()
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
            if ft == 'Outline' then
              vim.api.nvim_set_current_win(win)
              break
            end
          end
        end, 50)
      end,
      desc = "Toggle outline"
    },
  },
  opts = {
    outline_window = {
      focus_on_open = false,
    },
  },
}
