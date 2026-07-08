return {
  "vhyrro/luarocks.nvim",
  enabled = false,
  priority = 1000,
  config = function()
    require("luarocks-nvim").setup({
      rocks = "auto",
      nvim_dir = vim.fn.stdpath("config"),
      skip_update = true,
    })
  end,
}
