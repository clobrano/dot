return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    require('dapui').setup({
      layouts = {
        {
          elements = {
            { id = "breakpoints", size = 0.25 },
            { id = "watches",     size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "scopes",      size = 0.25 },
          },
          size = 40,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.50 },
            { id = "console", size = 0.50 },
          },
          size = 10,
          position = "bottom",
        },
      },
    })
  end
}
