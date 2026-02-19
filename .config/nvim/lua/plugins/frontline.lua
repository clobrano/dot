return {
  "clobrano/frontline.nvim",
  config = function()
    require("frontline").setup({
    workspaces = {
      personal =
      {
        rc = "~/.mytaskrc",
        notes_directory = "~/Me/Notes/1-Projects",
      },
      work = {
        rc = "~/.taskrc",
        notes_directory = "~/Documents/RedHatNotes/Tasks",
      },
    },
    default_workspace = "work",  -- Used when no @workspace specified
    enable_reverse_dependencies = false,  -- Show anchor icon for tasks blocking others (default: true)
    require_todo_annotations_done = true,
    })
  end
}
