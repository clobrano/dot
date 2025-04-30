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

      local tail = require("telescope.utils").path_tail(path)
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == "." then
        return tail
      else
        return string.format("%s\t(/%s)", tail, parent)
      end

      --return string.format("%s %s", tail, path)
    end

    -- See `:help telescope.builtin`
    vim.keymap.set(
      'n', '<leader>f/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        -- configure get_dropdown to expand previewer to full width of screen
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          layout_strategy = "vertical",
          winblend = 10,
          previewer = false,
          shorten_path = false,
          layout_config = {
            width = 0.95,
            height = 0.95,
            horizontal = { preview_width = 0.9 },
            --vertical = { preview_height = 0.5 },
          },
        })
      end,
      { desc = '[F]uzzily [/] search in current buffer' }
    )

    vim.keymap.set('n', '<leader>fa', require('telescope.builtin').live_grep, { desc = '[F]ind [A]all' })
    vim.keymap.set('v', "<leader>fa", require("telescope-live-grep-args.shortcuts").grep_visual_selection)
    --vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })
    vim.keymap.set('n', '<leader>fc', require('telescope.builtin').colorscheme, { desc = '[F]ind [C]olorscheme' })
    vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [k]eymaps' })
    vim.keymap.set('n', '<leader>fl', require('telescope.builtin').resume, { desc = '[F]ind [L]ast search' })
    vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages, { desc = '[F]ind [M]anual' })
    vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>ft', require('telescope.builtin').tags, { desc = '[F]ind [T]ags' })

    -- Git telescope
    vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches, { desc = '[F]ind [G]it [B]ranches' })
    vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits, { desc = '[F]ind [G]it [C]ommits' })
    vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_stash, { desc = '[F]ind [G]it [S]tashes' })

    require('telescope').setup({
      defaults = {
        file_ignore_patterns = {
          "^.git/", "node_modules/", "^vendor/", "^venv/", "^.venv/", "^tags$"
        },
        path_display = Filename_first_path_display,
        mappings = {
          i = {
            ["<C-v>"] = require('telescope.actions').select_vertical, -- Map <C-v> to open in vertical split in insert mode
          },
          n = {
            ["p"] = require('telescope_insert_path').insert_reltobufpath_insert,
          },
        },
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.90,
          height = 0.99,
          --preview_height = 0.6,
        },
        pickers = {
          lsp_references = { fname_width = 100, },
          tags = { fname_width = 100, },
          find_files = {
            no_ignore = true,
            no_ignore_parent = true,
            mappings = {
              n = {
                ["cd"] = function(prompt_bufnr)
                  local selection = require("telescope.actions.state").get_selected_entry()
                  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                  require("telescope.actions").close(prompt_bufnr)
                  -- Depending on what you want put `cd`, `lcd`, `tcd`
                  vim.cmd(string.format("silent lcd %s", dir))
                end
              }
            }
          },
          colorscheme = {
            enable_preview = true
          },
        },

      },
    })
  end
}
