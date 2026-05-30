return {
  "folke/tokyonight.nvim",
  enabled = true,
  lazy = false,
  priority = 1000,  -- Load this early in case you want to switch to it
  opts = {
    style = "moon", -- "storm", "moon", or "night" for maximum contrast
    transparent = true,
    styles = {
      sidebars = "dark",
      floats = "dark",
    },
  },
}
