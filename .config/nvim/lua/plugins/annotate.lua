return {
  "clobrano/annotate.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>aa", function() require("annotate").add() end, mode = { "n", "x" }, desc = "Annotate" },
    { "<leader>ae", function() require("annotate").edit() end, desc = "Annotate: edit" },
    { "<leader>ad", function() require("annotate").delete() end, desc = "Annotate: delete" },
    { "<leader>al", function() require("annotate").list() end, desc = "Annotate: list" },
    { "<leader>ap", function() require("annotate").preview() end, desc = "Annotate: preview export" },
    { "<leader>ax", function() require("annotate").export("tmux") end, desc = "Annotate: send to agent pane" },
    { "<leader>ay", function() require("annotate").export() end, desc = "Annotate: copy export" },
    { "]a", function() require("annotate").jump(1) end, desc = "Next annotation" },
    { "[a", function() require("annotate").jump(-1) end, desc = "Previous annotation" },
  },
}
