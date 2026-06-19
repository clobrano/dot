return {
  'dkarter/bullets.vim',
  ft = { 'markdown', 'text' },
  config = function()
    vim.g.bullets_enabled_filetypes = { 'markdown', 'text' }
    vim.g.bullets_outline_levels = {
      'num', -- Level 1: 1.
      'abc', -- Level 2: a.
      'std-', -- Level 3: *
      'std-', -- Level 4: -
      'std-', -- Level 5: *
      'std-' -- Level 6: -
    }
  end
}
