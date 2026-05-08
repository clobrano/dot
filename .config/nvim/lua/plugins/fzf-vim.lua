return {
  'junegunn/fzf.vim',
  config = function()
    -- Popup window (center of the screen)
    vim.cmd [[
        let g:fzf_layout = { 'down': '40%' }
        let g:fzf_history_dir = '~/.local/share/fzf-history'
      ]]

    local ignore_vendor = true
    local respect_gitignore = true

    local function get_fd_opts()
      local base = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude venv --exclude .venv"
      if ignore_vendor then
        base = base .. " --exclude vendor"
      end
      if not respect_gitignore then
        base = base .. " --no-ignore"
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

    vim.api.nvim_create_user_command('FzfToggleGitignoreInSearch', function()
      respect_gitignore = not respect_gitignore
      if respect_gitignore then
        print("Gitignored files are now EXCLUDED from search")
      else
        print("Gitignored files are now INCLUDED in search")
      end
    end, { desc = 'Toggle gitignored files in FzfLua search' })

    require('fzf-lua').setup({
      defaults = { cwd_prompt = false },
      winopts = {
        width = 0.95,
        height = 0.9,
      }
    })

    vim.keymap.set('n', '<leader>fb', ':FzfLua buffers<cr>', { desc = '[F]ind [B]uffers' })
    vim.keymap.set('n', '<leader>ft', ':FzfLua tags<cr>', { desc = '[F]ind [T]ags' })
    vim.keymap.set('n', '<leader>ff', function()
      require('fzf-lua').files({ fd_opts = get_fd_opts() })
    end, { desc = '[F]ind [F]iles' })
  end
}
