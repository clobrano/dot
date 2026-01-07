return {
  "clobrano/frontline.nvim",
  config = function()
    require("frontline").setup({
    workspaces = {
      personal = "~/.mytaskrc",
      work = "~/.taskrc",
    },
    default_workspace = "work",  -- Used when no @workspace specified
    enable_reverse_dependencies = false,  -- Show anchor icon for tasks blocking others (default: true)
    })
  end
}
