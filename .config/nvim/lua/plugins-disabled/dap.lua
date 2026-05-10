return {
	'mfussenegger/nvim-dap',
	config = function()
		vim.keymap.set("n", '<leader>du', function() require('dapui').toggle() end, { desc='[D]ap [U]I toggle', noremap = true, silent = true  })
		vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc='[D]ap [C]ontinue', noremap = true, silent = true  })
		vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, { desc='[D]ap step [N]ext', noremap = true, silent = true  })
		vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc='[D]ap step [O]ut', noremap = true, silent = true  })
		vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc='[D]ap step [I]nto', noremap = true, silent = true  })
		vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc='[D]ap toggle [B]reakpoint', noremap = true, silent = true  })
    vim.keymap.set("n", "<leader>dB", function()
      local condition = vim.fn.input("Breakpoint condition: ")
      require("dap").toggle_breakpoint(condition)
    end, { desc='[D]ap [B]reakpoint with condition', noremap = true, silent = true })
		vim.keymap.set('n', '<Leader>dlp',
			function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
		vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
		vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
		vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end, { desc='[D]ap [H]over', noremap = true, silent = true  })
        --vim.keymap.set({ 'n', 'v' }, '<Leader>pv', function() require('dap.ui.widgets').preview() end) -- Conflicts with `diffput` which I use more often
		vim.keymap.set('n', '<Leader>df',
			function()
				local widgets = require('dap.ui.widgets')
				widgets.centered_float(widgets.frames)
			end, { desc='[D]ap show [F]rame', noremap = true, silent = true  })
		vim.keymap.set('n', '<Leader>dw',
			function()
				local widgets = require('dap.ui.widgets')
				widgets.centered_float(widgets.scopes)
			end)
	end
}
