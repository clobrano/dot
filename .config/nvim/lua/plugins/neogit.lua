return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",  -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua",              -- optional
	},
	--config = true,
	config = function()
		require('neogit').setup {
			status = {
				recent_commit_count = 15,
			}
		}
		vim.keymap.set('n', '<leader>gps', '<esc>:Neogit push<cr>')
		vim.keymap.set('n', '<leader>gco', '<esc>:Neogit commit<cr>')
	end
}
