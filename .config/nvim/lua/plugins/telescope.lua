
--- close buffers inside a Telescope buffer view
local function close_selected_buffers(bufnr)
  require('telescope.actions').delete_buffer(bufnr)
end

--- Telescope options defined here, they'll be assigned below in this file
local telescope_opts = {
  defaults = {
    mappings = {
      i = {
        ["<c-d>"] = close_selected_buffers,
      },
      n = {
        ["<c-d>"] = close_selected_buffers,
      },
    },
    file_ignore_patterns = {
      "^.git/", "node_modules/", "^vendor/", "^venv/", "^.venv/", "^tags$"
    },
    path_display = Filename_first_path_display,
    layout_strategy = 'flex',
    layout_config = {
      width = 0.99,
      height = 0.99,
      flex = {
        -- Minimum width required for 'horizontal' layout (preview on the right)
        -- If the window width is less than this, it will switch to 'vertical' (preview on top)
        -- You'll need to adjust this value based on your screen size and preferences.
        -- For example, 120 or 150 might be good starting points.
        width = 0.99,        -- You can also use a fixed number like 150
        height = 0.99,
        preview_width = 0.8, -- Percentage of the available horizontal space for the preview window
        -- You can further fine-tune the horizontal and vertical specific configurations
        horizontal = {
          prompt_position = "top",
          preview_width = 0.7, -- Adjust results window width if needed
        },
        vertical = {
          prompt_position = "top",
          mirror = true,
          -- The preview window will be above the results in this layout
        },
      },
    },
    pickers = {
      lsp_references = { fname_width = 100, },
      tags = { fname_width = 100, },
      find_files = {
        no_ignore = true,
        no_ignore_parent = true,
      },
      colorscheme = {
        enable_preview = true
      },
    },

  },
}




--- is_vendor_ignored and TelescopeToggleVendorIgnore are used to toggle ignoring "vendor" folder when searching inside a golang project
local is_vendor_ignored = true
_G.TelescopeToggleVendorIgnore = function()
  is_vendor_ignored = not is_vendor_ignored
  if is_vendor_ignored then
    -- Include vendor golang directory in the excluded list
    telescope_opts.defaults.file_ignore_patterns = {
      "^.git/", "node_modules/", "^vendor/", "^venv/", "^.venv/", "^tags$"
    }
    print("Vendor folder is now EXCLUDED from Telescope search")
  else
    -- Remove vendor golang directory from the excluded list
    telescope_opts.defaults.file_ignore_patterns = {
      "^.git/", "node_modules/", "^venv/", "^.venv/", "^tags$"
    }
    print("Vendor folder is now INCLUDED in Telescope search")
  end
  require("telescope").setup(telescope_opts)
end





--- Here is the actual Telescope plugin configuration
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" },
  config = function()
    -- Display entry text after two tabs as comment.
    -- Used to display file paths as filename followed by greyed-out path.
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    function Filename_first_path_display(_, path)
      --local tail = require("telescope.utils").path_tail(path)
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == "." then
        return tail
      else
        return string.format("%s\t(/%s)", tail, parent)
      end

      --return string.format("%s %s", tail, path)
    end

    require('telescope').setup(telescope_opts)

    -- Mappings
    vim.keymap.set(
      'n', '<leader>f/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        -- configure get_dropdown to expand previewer to full width of screen
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          layout_strategy = "flex",
          enable_preview = false,
          shorten_path = false,
          -- set it again as this is independent from the default layout configured above
          layout_config = {
            width = 0.99,
            height = 0.99,
          }
        })
      end,
      { desc = '[F]uzzily [/] search in current buffer' }
    )

    vim.keymap.set('n', '<leader>ttv', function() _G.TelescopeToggleVendorIgnore() end,
      { desc = '[T]elescope [T]oggle [V]endor in search' })
    vim.keymap.set('n', '<leader>fa', require('telescope.builtin').live_grep, { desc = '[F]ind [A]all' })
    vim.keymap.set('v', "<leader>fa", require("telescope-live-grep-args.shortcuts").grep_visual_selection)
    vim.keymap.set('n', '<leader>fb', function()
      require('telescope.builtin').buffers({
        layout_strategy = 'vertical',
        layout_config = {
          mirror = true, -- This places the preview above the results list
        },
      })
    end, { desc = '[F]ind [B]uffers' })
    vim.keymap.set('n', '<leader>fc', require('telescope.builtin').colorscheme, { desc = '[F]ind [C]olorscheme' })
    vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [k]eymaps' })
    vim.keymap.set('n', '<leader>fj',
      function()
        require('telescope.builtin').find_files({
          cwd = "./Journal",
          prompt_title = "Find Journal entries"
        })
      end, { desc = '[F]ind [J]ournal' })
    vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages, { desc = '[F]ind [M]anual' })
    vim.keymap.set('n', '<leader>fl', require('telescope.builtin').resume, { desc = '[F]ind [L]ast search' })
    vim.keymap.set('n', '<leader>fr',
      function()
        require('telescope.builtin').lsp_references({
          layout_strategy = "vertical",
          enable_preview = false,
          fname_width = 100, -- Keep your fname_width setting
        })
      end, { desc = '[L]SP [R]eferences' }
    )
    vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>ft',
      function()
        require('telescope.builtin').tags({
          layout_strategy = "vertical",
          enable_preview = false,
          fname_width = 100, -- Keep your fname_width setting
        })
      end, { desc = '[F]ind [T]ags' })

    -- Git telescope
    vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches, { desc = '[F]ind [G]it [B]ranches' })
    vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits, { desc = '[F]ind [G]it [C]ommits' })
    vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_stash, { desc = '[F]ind [G]it [S]tashes' })

    -- Session via Persisted.nvim
    vim.keymap.set('n', '<leader>so', ":Telescope persisted<cr>", { desc = '[S]ession [O]pen (via Persisted)' })
  end
}
