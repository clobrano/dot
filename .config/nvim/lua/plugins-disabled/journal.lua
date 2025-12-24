return {
  'journal/journal',
  dependencies = { 'nvim-telescope/telescope.nvim' }, -- Ensure Telescope is a dependency
  config = function()
    require('journal.journal').setup() -- Call setup when the plugin is loaded
  end
}
