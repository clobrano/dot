return {
  'brenoprata10/nvim-highlight-colors',

  config = function()
    require('nvim-highlight-colors').setup {
      -- 'background'|'foreground'|'virtual'
      render = 'virtual',
      virtual_symbol = '■',
      virtual_symbol_position = 'eol',
    }
  end
}
