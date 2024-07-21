return {
	'mfussenegger/nvim-dap',
	config = function()
		vim.keymap.set("n", "<F6>", ":lua require'dapui'.open()<cr>")
		vim.keymap.set('n', '<F7>', function() require('dap').continue() end)

		vim.keymap.set('n', '<F8>', function() require('dap').step_over() end)
		vim.keymap.set('n', '<C-n>', function() require('dap').step_over() end)

		vim.keymap.set('n', '<F9>', function() require('dap').step_into() end)
		vim.keymap.set('n', '<C-s>', function() require('dap').step_into() end)

		vim.keymap.set('n', '<F10>', function() require('dap').step_out() end)
		vim.keymap.set('n', '<C-f>', function() require('dap').step_out() end)

		vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
		vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
		vim.keymap.set('n', '<Leader>lp',
			function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
		vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
		vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
		vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
        --vim.keymap.set({ 'n', 'v' }, '<Leader>pv', function() require('dap.ui.widgets').preview() end) -- Conflicts with `diffput` which I use more often
		vim.keymap.set('n', '<Leader>df',
			function()
				local widgets = require('dap.ui.widgets')
				widgets.centered_float(widgets.frames)
			end)
		vim.keymap.set('n', '<Leader>dw',
			function()
				local widgets = require('dap.ui.widgets')
				widgets.centered_float(widgets.scopes)
			end)
	end
}
