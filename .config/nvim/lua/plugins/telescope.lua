require('telescope').setup {
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
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == "." then
        return tail
      else
        return string.format("%s\t\t%s", tail, parent)
      end
    end

    vim.cmd [[
            " Mapping
            nnoremap <leader>fa :Telescope live_grep<cr>
            nnoremap <leader>fb :Telescope buffers<cr>
            nnoremap <leader>fc :Telescope colorscheme<cr>
            nnoremap <leader>fd :Telescope lsp_definitions<cr>
            nnoremap <leader>ff :Telescope find_files hidden=true<cr>
            nnoremap <leader>fg :Telescope current_buffer_fuzzy_find<cr>
            nnoremap <leader>fh :Telescope help_tags<cr>
            nnoremap <leader>fk :Telescope keymaps<cr>
            nnoremap <leader>fi :Telescope lsp_implementations<cr>
            nnoremap <leader>fl :Telescope resume<cr>
            nnoremap <leader>fm :Telescope man_pages<cr>
            nnoremap <leader>fr :Telescope lsp_references<cr>
            nnoremap <leader>fs :Telescope grep_string<cr>
            nnoremap <leader>ft :Telescope tags<cr>

            " GIT mappings
            nnoremap <leader>fgb :Telescope git_branches<cr>
            nnoremap <leader>fgc :Telescope git_commits<cr>
            nnoremap <leader>fgs :Telescope git_stashes<cr>

            " Abbreviations
            cnoreabbrev ts Telescope
            nnoremap ts :Telescope<cr>
        ]]
  end,
  defaults = {
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
      preview_height = 0.6,
    },
    pickers = {
      lsp_references = { fname_width = 100, },
      tags = { fname_width = 100, },
      find_files = {
        no_ignore = true,
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
    file_ignore_patterns = {
      "^.git/", "node_modules/", "^vendor/", "^venv/", "^.venv/"
    },
  },
}
