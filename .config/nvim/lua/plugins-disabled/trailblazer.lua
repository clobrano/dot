return {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            -- your custom config goes here
            mappings = { -- rename this to "force_mappings" to completely override default mappings and not merge with them
                nv = {  -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                    motions = {
                        new_trail_mark = '<leader>mm',
                        track_back = '<leader>mb',
                        peek_move_next_down = '<leader>mj',
                        peek_move_previous_up = '<leader>mk',
                        move_to_nearest = '<leader>mc',
                        toggle_trail_mark_list = '<leader>ml',
                    },
                },
                -- You can also add/move any motion or action to mode specific mappings i.e.:
                -- i = {
                --     motions = {
                --         new_trail_mark = '<C-l>',
                --         ...
                --     },
                --     ...
                -- },
            },
        })
        vim.keymap.set('n', '<leader>mL', ':TrailBlazerLoadSession marks/marks.tbsv')
        vim.keymap.set('n', '<leader>mS', ':TrailBlazerSaveSession marks')
        vim.keymap.set('n', '<leader>mD', ':TrailBlazerDeleteAllTrailMarks')
    end,
}
