return {
  'nvim-orgmode/orgmode',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', lazy = true },
  },
  event = 'VeryLazy',
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'org',
      callback = function()
        vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
          silent = true,
          buffer = true,
        })
      end,
    })
  end,
  config = function()
    -- Load treesitter grammar for org

    -- Setup treesitter
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
      },
      ensure_installed = { 'org' },
    })

    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = { '~/Dropbox/notes/**/*', '~/Documents/RedHatVault/**/*' },
      org_default_notes_file = '~/Dropbox/notes/Planner.org',
      org_capture_templates = {
        t = { description = 'Task', template = '* TODO %?\n  %u' },
        w = { description = 'Work', target = '~/Documents/RedHatVault/Work.org', template = '* TODO %?\n' },
        n = { description = 'Note', template = '* %?\n  %u' },
      },
      org_startup_folded = 'overview', -- 'showeverything',
      org_tags_column = -100,
   })
  end,
}
