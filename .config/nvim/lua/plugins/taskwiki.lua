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

      -- Create the autocommand ONLY if the buffer's path is within the journal_data_location
      vim.api.nvim_create_autocmd("BufEnter", {
        -- Pattern to match markdown files
        pattern = "*.md",
        -- Use a Lua condition to check the file path
        group = vim.api.nvim_create_augroup("TaskwikiBufferLoad", { clear = true }), -- Good practice to use an augroup
        callback = function(args)
          local file_path = vim.api.nvim_buf_get_name(args.buf)
          -- Check if the file_path starts with the journal_data_location
          if file_path:sub(1, #work_journal_data_location) == work_journal_data_location then
            vim.cmd("TaskWikiBufferLoad")
          elseif file_path:sub(1, #personal_journal_data_location) == personal_journal_data_location then
            vim.cmd("TaskWikiBufferLoad")
          else
            print(file_path .. " is not a configured journal location")
          end
        end,
      })
    else
      -- If not on the work machine, do nothing or handle other configs
      print('not a work machine, skipping taskwiki_extra_warriors config')
    end
  end
}
