return {
  'tools-life/taskwiki',
  config = function()
	vim.cmd [[
	  let g:taskwiki_disable_concealcursor="yes"
	]]
	vim.keymap.set('n', '<leader>tr', ':TaskWikiBufferLoad<cr>')

	local cwd = vim.fn.getcwd()
    if cwd:find('^/home/clobrano')  then
      print('clobrano dir exists')
      vim.cmd [[
        let g:taskwiki_extra_warriors={ 'W': {'data_location': '/home/clobrano/Documents/taskwarriorRH/', 'taskrc_location': '/home/clobrano/.taskworkrc'}}
      ]]
    end
  end
}
