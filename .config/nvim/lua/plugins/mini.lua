function OpenMiniFilesCurrentDir()
  local MiniFiles = require('mini.files')
  local current_file_path = vim.api.nvim_buf_get_name(0)

  -- Get the directory of the current file
  -- vim.fn.fnamemodify(path, ':h') extracts the head (directory) of the path.
  local target_dir = vim.fn.fnamemodify(current_file_path, ':h')

  -- Use the current working directory if the buffer is unlisted or has no name (e.g., [No Name])
  if target_dir == '' then
    target_dir = vim.fn.getcwd()
  end

  -- Open MiniFiles at the determined directory
  MiniFiles.open(target_dir)

  -- The `MiniFiles.open()` function might open the file explorer, but not necessarily
  -- select or reveal the directory of the *current file* inside the explorer.
  -- If you want it to jump to the directory and select the current file's directory:
  -- MiniFiles.reveal_cwd()
  -- Note: Depending on the 'mini.files' version, `reveal_cwd()` might be what you want
  -- for focusing on the current file's path.
end

return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.files').setup({})
    vim.keymap.set('n', '<leader>em', ':lua OpenMiniFilesCurrentDir()<CR>', { desc = 'Open MiniFiles at current buffer directory', silent = true, noremap = true })
  end
}
