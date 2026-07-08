return {
  "3rd/image.nvim",
  enabled = false,
  dependencies = { "luarocks.nvim" },
  config = function()
    require("image").setup {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          sizing_strategy =
          "fit_image_while_staying_above_window_baseline"
        }
      }
    }
  end
}
