return {
  'nvim-orgmode/orgmode',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', lazy = true },
  },
  event = 'VeryLazy',
  config = function()
    -- Load treesitter grammar for org
    require('orgmode').setup_ts_grammar()

    -- Setup treesitter
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
      },
      ensure_installed = { 'org' },
    })

    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = {'~/Dropbox/notes/**/*', '~/Documents/RedHatVault/**/*'},
      org_default_notes_file = '~/Dropbox/LogSeq/Planner.org',
      org_capture_templates = {
        t = { description = 'Task', template = '* TODO %?\n  %u' },
        n = { description = 'Note', template = '* %?\n  %u' },
      },
      org_startup_folded = 'showeverything',
      org_tags_column = 0,
    })
  end,
}
