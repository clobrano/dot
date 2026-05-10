return {
  "wallpants/github-preview.nvim",
  -- It needs typescript dependencies to install via bun https://bun.sh/docs/installation
  -- bun install bunvim
  -- bun install pantsdown
  cmd = { "GithubPreviewToggle" },
  keys = { "<leader>mpt" },
  opts = {
    -- config goes here
  },
  config = function(_, opts)
    local gpreview = require("github-preview")

    local fns = gpreview.fns
    vim.keymap.set("n", "<leader>mpt", fns.toggle)
    vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
    vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)

    gpreview .setup({
      host = "localhost",

      -- port used by local server
      port = 6041,

      -- set to "true" to force single-file mode & disable repository mode
      single_file = false,

      theme = {
        -- "system" | "light" | "dark"
        name = "system",
        high_contrast = false,
      },

      -- define how to render <details> tags on init/content-change
      -- true: <details> tags are rendered open
      -- false: <details> tags are rendered closed
      details_tags_open = true,

      cursor_line = {
        disable = false,

        -- CSS color
        -- if you provide an invalid value, cursorline will be invisible
        color = "#c86414",
        opacity = 0.2,
      },

      scroll = {
        disable = false,

        -- Between 0 and 100
        -- VERY LOW and VERY HIGH numbers might result in cursorline out of screen
        top_offset_pct = 35,
      },

      -- for debugging
      -- nil | "debug" | "verbose"
      log_level = nil,
    })
  end,
}
