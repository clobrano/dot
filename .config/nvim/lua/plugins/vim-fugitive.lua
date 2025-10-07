return {
  'tpope/vim-fugitive',
    config = function()
        vim.cmd[[
        cnoreabbrev <expr> gg getcmdtype() == ":" && getcmdline() == 'gg' ? 'G ' : 'gg'
        cnoreabbrev <expr> gb getcmdtype() == ":'<,'>" && getcmdline() == 'gb' ? 'GBrowse! ' : 'gb'
        ]]
        vim.keymap.set('n', '<leader>ga', '<esc>:Gwrite')
        vim.keymap.set('n','<leader>gb', '<esc>:G blame<cr>')
        vim.keymap.set('n','<leader>gco', '<esc>:G commit -s<cr>')
        vim.keymap.set('n','<leader>gca', '<esc>:G commit --amend<cr>')
        vim.keymap.set('n','<leader>gcan', '<esc>:G commit --amend --no-edit<cr>')
        --vim.keymap.set('n','<leader>gl', '<esc>:botright G log<cr>')
        --vim.keymap.set('n','<leader>gps', '<esc>:Dispatch! git push<cr>')
        vim.keymap.set('n','<leader>gpl', '<esc>:Dispatch! git pull<cr>')
        --vim.keymap.set('n','<leader>gs', '<esc>:vertical G<cr>')
        vim.keymap.set('n','<leader>gv', '<esc>:GV<cr>')

        -- Fugitive vertical diff
        vim.keymap.set('n', '<leader>gd', '<esc>:Gvdiff<space>')
        -- Gvdiff get from left split
        vim.keymap.set('n', 'gh', ':diffget //2', {desc="[G]et diff from right [H] split"})
        -- Gvdiff get from right split
        vim.keymap.set('n', 'gl', ':diffget //3', {desc="[G]et diff from left [L] split"})

        -- move to parent directory when exploring the tree
        vim.cmd[[
        autocmd User fugitive
        \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
        \   vim.keymap_set( <buffer> <leader>.. :edit %:h<CR> |
        \ endif
        ]]

        -- this is for fugitive-gitlab
        vim.cmd("let g:fugitive_gitlab_domains = ['https://gitlab.cee.redhat.com']")
    end,
}
