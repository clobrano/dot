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

    -- Setup treesitter: NOTE: treesiter fails loading support for org, so I'll disable it for now
    --require('nvim-treesitter.configs').setup({
      --highlight = {
        --enable = true,
      --},
      --ensure_installed = { 'org' },
    --})

    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = { '~/Me/Orgmode/**/*' },
      org_default_notes_file = '~/Me/Orgmode/Orgmode.org',
      org_capture_templates = {
        t = { description = 'Task', template = '* TODO %?\n' },
        n = { description = 'Note', template = '* %?\n' },
      },
      --org_startup_folded = 'overview', -- 'showeverything',
      org_tags_column = -100,
   })
  end,
}

