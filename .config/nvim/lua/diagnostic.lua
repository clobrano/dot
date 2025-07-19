
vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc="Open Diagnostic Floating window", noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = 'Open diagnostics list', noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc="Diagnostic next error", noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc="Diagnostic previous error", noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { desc="Open Diagnostic Telescope", noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- vim.cmd [[
--   "Enable floating window (error and doc) on hover"
--   "autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus = false})
--   autocmd CursorHoldI *.go silent! lua vim.lsp.buf.hover({focusable = false})
-- ]]

vim.diagnostic.config({
  virtual_text = {
    -- source = "if_many",  -- Use "if_many" to show source when multiple diagnostics
    source = false,         -- Use false to never show the source
    -- source = true,          -- Use true to always show the source (might be verbose)
    prefix = '●', -- Could be '■', '▎', 'x'
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●', -- Default: E
      [vim.diagnostic.severity.WARN] = '●',  -- Default: W
      [vim.diagnostic.severity.INFO] = '●',  -- Default: I
      [vim.diagnostic.severity.HINT] = '●',  -- Default: H
    },
  },
  severity_sort = true,
  float = {
     source = "if_many",   -- Use "if_many" to show source when multiple diagnostics
    --source = false,          -- Use false to never show the source
     --source = true,           -- Use true to always show the source (might be verbose)
  },
})

if false then
  -- not using this as the message holds even when
  -- not hovering on the same line anymore
function PrintDiagnostics(opts, bufnr, line_nr, _)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end
vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]
end


