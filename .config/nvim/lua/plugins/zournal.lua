return {
  "clobrano/zournal.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("zournal").setup({
      workspaces = {
        work = {
          root_dir = "~/Documents/RedHatNotes/",
          journal_dir = "Journal",
          inbox_dir = "Resources",

          -- Filename formats for journal types (strftime-like patterns)
          weekly_format = "%Y-%m-W%W.md",
          week_numbering_system = "gregorian",

          -- Template file paths (leave empty for basic defaults)
          weekly_template = "~/Documents/RedHatNotes/Templates/weekly-template.md",
          monthly_template = "",
          inbox_template = "",

          --virtual_text_enabled = true,
        },
        personal = {
          root_dir = "~/Me/Notes/",
          journal_dir = "Journal/",
          inbox_dir = "3-Resources/",
          --virtual_text_enabled = true,

          -- Filename formats for journal types (strftime-like patterns)
          daily_format = "%Y-%m-%d.md",
          weekly_format = "review_week_%Y_%W.md",
          week_numbering_system = "gregorian",

          -- Template file paths (leave empty for basic defaults)
          daily_template = "~/Me/Notes/3-Resources/templates/notes-day.md",
        },
      },
      -- Mappings
      vim.keymap.set('n', '<leader>zd', ':ZournalDailyJournal<cr>', {desc="Open Zournal Daily", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zw', ':ZournalWeeklyJournal<cr>', {desc="Open Zournal Weekly", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zc', ':ZournalTagCopy<cr>', {desc="Zournal Tag Copy", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>za', ':ZournalTagAdd<cr>', {desc="Zournal Tag Add", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zr', ':ZournalTagReferences<cr>', {desc="Zournal Tag References", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zf', ':ZournalTagFollow<cr>', {desc="Zournal Tag Follow", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zn', ':ZournalInbox<cr>', {desc="Zournal New File in Inbox", noremap = true,silent=true}),
      vim.keymap.set('n', '<leader>zt', ':ZournalVirtualTextToggle<cr>', {desc="Zournal Virtual Text Toggle", noremap = true,silent=true}),
    })
  end,
}
