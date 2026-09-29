return {
  "clobrano/frontline.nvim",
  config = function()
    require("frontline").setup({
      relative_dates = true,
      task_format = "*{{description}}*",
      workspaces = {
        personal =
        {
          rc = "~/Me/Taskwarrior/taskrcs/taskrc-personal-desktop",
          notes_directory = "~/Me/Notes/1-Projects",
          task_format = "{{project}}: _{{description}}_ {{icons}}",
        },
        work = {
          rc = "~/.taskrc",
          notes_directory = "~/Documents/RedHatNotes/Tasks",
          task_format = "{{project}}: _{{description}}_ {{icons}}",
          task_bullet = "-",
        },
      },
      default_workspace = "work",       -- Used when no @workspace specified
      enable_reverse_dependencies = true, -- Show anchor icon for tasks blocking others (default: true)
      require_todo_annotations_done = true,
      copy_task_format = "_{{description}}_ `{{short_uuid}}`",
      default_sort = { field = "due", reverse = false },
    })
  end
}
