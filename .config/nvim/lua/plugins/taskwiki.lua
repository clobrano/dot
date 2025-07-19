return {
  'tools-life/taskwiki',
  config = function()
    vim.cmd [[
      let g:taskwiki_disable_concealcursor="yes"
    ]]
    vim.keymap.set('n', '<leader>rr', ':TaskWikiBufferLoad<cr>')

    local cwd = vim.fn.getcwd()

    if cwd:find('^/home/clobrano') then
      vim.cmd [[
        let g:taskwiki_extra_warriors={ 'W': {'data_location': '/home/clobrano/Documents/taskwarriorRH/', 'taskrc_location': '/home/clobrano/.taskworkrc'}}
      ]]

      -- Define the base path for your Taskwiki files
      local work_journal_data_location = '/home/clobrano/Documents/RedHatNotes'
      local personal_journal_data_location = '/home/clobrano/Me/Notes'

      -- Create an autocommand to notify the user if the file is a Taskwiki journal
      vim.api.nvim_create_autocmd("BufEnter", {
        -- Pattern to match markdown files
        pattern = "*.md",
        group = vim.api.nvim_create_augroup("TaskwikiNotification", { clear = true }), -- Use a new augroup or clear the existing one
        callback = function(args)
          local file_path = vim.api.nvim_buf_get_name(args.buf)
          -- Check if the file_path starts with one of the journal_data_locations
          if file_path:sub(1, #work_journal_data_location) == work_journal_data_location or
             file_path:sub(1, #personal_journal_data_location) == personal_journal_data_location then
            -- Notify the user that they can load Taskwiki data manually
            vim.api.nvim_echo({{"This file contains Taskwiki data. Run <leader>rr to load.", "Normal"}}, true, {})
          end
        end,
      })
    else
      -- If not on the work machine, do nothing or handle other configs
      print('not a work machine, skipping taskwiki_extra_warriors config')
    end
  end
}
