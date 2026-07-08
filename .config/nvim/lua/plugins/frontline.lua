return {
  "clobrano/frontline.nvim",
  config = function()
    require("frontline").setup({
      relative_dates = true,
      workspaces = {
        personal =
        {
          rc = "~/Me/Taskwarrior/taskrcs/taskrc-personal-desktop",
          notes_directory = "~/Me/Notes/1-Projects",
        },
        work = {
          rc = "~/.taskrc",
          notes_directory = "~/Documents/RedHatNotes/Tasks",
        },
      },
      default_workspace = "work",       -- Used when no @workspace specified
      enable_reverse_dependencies = true, -- Show anchor icon for tasks blocking others (default: true)
      require_todo_annotations_done = true,
      copy_task_format = "{{description}} `{{short_uuid}}`",
      default_sort = { field = "due", reverse = false },
    })
  end
}
