return {
  'junegunn/fzf.vim',
  config = function()
    -- Popup window (center of the screen)
    vim.cmd [[
        let g:fzf_layout = { 'down': '40%' }
        let g:fzf_history_dir = '~/.local/share/fzf-history'
      ]]

    local ignore_vendor = true

    local function get_fd_opts()
      local base = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude venv --exclude .venv"
      if ignore_vendor then
        return base .. " --exclude vendor"
      end
      return base
    end

    vim.api.nvim_create_user_command('FzfToggleVendorInSearch', function()
      ignore_vendor = not ignore_vendor
      if ignore_vendor then
        print("Vendor folder is now EXCLUDED from search")
      else
        print("Vendor folder is now INCLUDED in search")
      end
    end, { desc = 'Toggle vendor folder in FzfLua search' })

    vim.keymap.set('n', '<leader>ft', ':FzfLua tags<cr>', { desc = '[F]ind [T]ags' })
    vim.keymap.set('n', '<leader>ff', function()
      require('fzf-lua').files({ fd_opts = get_fd_opts() })
    end, { desc = '[F]ind [F]iles' })
  end
}
