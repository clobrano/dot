return {
  "olimorris/persisted.nvim",
  event = { "BufReadPre" }, -- Ensure the plugin loads only when a buffer has been loaded
  opts = {
    -- Your config goes here ...
  },
  should_save = function()
    -- Do not save if the alpha dashboard is the current filetype
    if vim.bo.filetype ~= "markdown" then
      return false
    end
    return true
  end,
}
