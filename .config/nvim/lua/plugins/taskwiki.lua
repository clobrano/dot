return {
  'tools-life/taskwiki',
  config = function()
    vim.cmd [[
      let g:taskwiki_disable_concealcursor="yes"
    ]]
    vim.keymap.set('n', '<leader>rr', ':TaskWikiBufferLoad<cr>')
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",  -- Match only markdown buffers
      callback = function()
        vim.cmd("TaskWikiBufferLoad")
        vim.cmd("echo 'Tasks reloaded'")
      end,
    })

    local cwd = vim.fn.getcwd()
    if cwd:find('^/home/clobrano')  then
      print('work machine')
      vim.cmd [[
        let g:taskwiki_extra_warriors={ 'W': {'data_location': '/home/clobrano/Documents/taskwarriorRH/', 'taskrc_location': '/home/clobrano/.taskworkrc'}}
      ]]
    end
  end
}
