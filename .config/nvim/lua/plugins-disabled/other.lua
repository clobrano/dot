return {
  'rgroli/other.nvim',
  config = function()
    require("other-nvim").setup({
      mappings = {
        -- builtin mappings
        "golang",
        "python",
      },
      style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2
      },
    })
  end
}
