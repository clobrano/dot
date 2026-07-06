return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  config = function()
    require("no-neck-pain").setup({
      width = 140,
      buffers = {
        right = {
          enabled = false,
        },
        scratchPad = {
          enabled = false,
        },
        bo = {
          filetype = "no-neck-pain",
        },
      },
      autocmds = {
        enableOnVimEnter = false,
        reloadOnColorSchemeChange = false,
        skipEnteringNoNeckPainBuffer = true,
      },
      integrations = {
        outline = {
          position = "right",
          reopen = true,
        },
      },
    })
    vim.keymap.set('n', '<leader>nn', ':NoNeckPain<cr>', { noremap = true, desc = "Toggle NoNeckPain" })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        require("no-neck-pain").enable()
      end,
    })
  end
}
