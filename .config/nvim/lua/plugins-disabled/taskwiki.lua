-- Define the base path for your Taskwiki files
local work_journal_data_location = '/home/clobrano/Documents/RedHatNotes'

-- Configuration
return {
  'tools-life/taskwiki',
  config = function()
    vim.cmd [[
      let g:taskwiki_disable_concealcursor="yes"
    ]]

    -- Mappings
    vim.keymap.set('n', '<leader>rr', ':TaskWikiBufferLoad<cr>')

    -- Configure data location for work
    local cwd = vim.fn.getcwd()
    if cwd:find('^/home/clobrano') then
      vim.cmd [[
        let g:taskwiki_extra_warriors={ 'W': {'data_location': '/home/clobrano/Documents/taskwarriorRH/', 'taskrc_location': '/home/clobrano/.taskworkrc'}}
      ]]
    else
      print('not a work machine, skipping work configuration')
    end

    -- Create an autocommand to notify the user if the file is a Taskwiki journal
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",
      group = vim.api.nvim_create_augroup("taskwiki_reload_tasks_in_buffer", { clear = true }),
      callback = function(args)
        local file_path = vim.api.nvim_buf_get_name(args.buf)
        -- Check if the file_path starts with one of the journal_data_locations
        if file_path:sub(1, #work_journal_data_location) == work_journal_data_location then
          vim.cmd [[
            TaskWikiBufferLoad
          ]]
        end
      end,
    })
  end
}
