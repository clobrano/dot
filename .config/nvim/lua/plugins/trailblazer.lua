return {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            -- your custom config goes here
            mappings = { -- rename this to "force_mappings" to completely override default mappings and not merge with them
                nv = {  -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                    motions = {
                        new_trail_mark = '<leader>km',
                        track_back = '<leader>kb',
                        peek_move_next_down = '<leader>kj',
                        peek_move_previous_up = '<leader>kk',
                        move_to_nearest = '<leader>kn',
                        toggle_trail_mark_list = '<leader>kl',
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
    end,
}
