return {
	'tools-life/taskwiki',
	config = function()
		vim.cmd [[
		let g:taskwiki_extra_warriors={ 'W': {'data_location': '/home/clobrano/Documents/taskwarriorRH/', 'taskrc_location': '/home/clobrano/.taskworkrc'}, 'P': {'data_location': '/home/clobrano/Me/Taskwarrior/', 'taskrc_location': '/home/clobrano/.taskrc'}}
        let g:taskwiki_disable_concealcursor="yes"
    ]]
	end
}
