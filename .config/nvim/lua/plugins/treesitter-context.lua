return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require 'treesitter-context'.setup {
      enable = true,        -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false,  -- Enable multiwindow support.
      max_lines = 5,        -- Limit context to 5 lines to reduce memory usage
      min_window_height = 20, -- Only show context when window has at least 20 lines
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',      -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
  end
}
