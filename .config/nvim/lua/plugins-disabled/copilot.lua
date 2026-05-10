--vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_proxy = 'http://localhost:11435'
vim.g.copilot_proxy_strict_ssl = false
vim.api.nvim_set_keymap("i", "<C-y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.cmd [[
    let g:copilot_filetypes = {
        \ '*': v:false,
        \ 'go': v:true,
        \ 'python': v:true,
        \ 'text': v:true,
        \ }
]]
