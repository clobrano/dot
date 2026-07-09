return {
  'dkarter/bullets.vim',
  enabled = true,
  ft = { 'markdown', 'text' },
  config = function()
    vim.g.bullets_enabled_filetypes = { 'markdown', 'text' }
    vim.g.bullets_outline_levels = {
      'num', -- Level 1: 1.
      'abc', -- Level 2: a.
      'std-', -- Level 3: *
    }
  end
}
