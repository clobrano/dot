return {
  'dkarter/bullets.vim',
  enabled = true,
  ft = { 'markdown', 'text' },
  init = function()
    vim.g.bullets_enabled_file_types = { 'markdown', 'text' }
    vim.g.bullets_outline_levels = {
      'num', -- Level 1: 1.
      'abc', -- Level 2: a.
      'std*', -- Level 3: -
      'std-', -- Level 4: -
    }
  end
}
