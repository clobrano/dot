lua <<ENDLUA
-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 50,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "M", action = "toggle_mark" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
ENDLUA

nnoremap <leader>nn <esc>:NvimTreeToggle<cr>
nnoremap <leader>nf <esc>:NvimTreeFindFile<cr>
nnoremap <leader>nc <esc>:NvimTreeCollapse<cr>


