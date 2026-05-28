return {
  'stevearc/overseer.nvim',
  opts = {
    dap = false,
    task_list = {
      direction = 'bottom',
      min_height = 25,
      max_height = 25,
    },
  },
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function(_, opts)
    require('overseer').setup(opts)

    vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = 'Overseer Run' })
    vim.keymap.set('n', '<leader>ot', '<cmd>OverseerToggle<cr>', { desc = 'Overseer Toggle' })

    local telescope = require('telescope.builtin')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    vim.ui.select = function(items, opts, on_choice)
      if vim.tbl_isempty(items) then
        on_choice(nil)
        return
      end

      pickers.new({}, {
        prompt_title = opts.prompt or 'Select',
        finder = finders.new_table({
          results = items,
          entry_maker = function(entry)
            local display
            if type(entry) == 'string' then
              display = entry
            elseif type(entry) == 'table' and entry.name then
              display = entry.name
            else
              display = tostring(entry)
            end
            return {
              value = entry,
              display = display,
              ordinal = display,
            }
          end,
        }),
        sorter = require('telescope.config').values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            on_choice(selection.value)
          end)
          return true
        end,
      }):find()
    end
  end,
}
