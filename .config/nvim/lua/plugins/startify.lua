return {
    'mhinz/vim-startify',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        vim.cmd [[
            cnoreabbrev ss Startify

            let g:startify_custom_header =
            \ startify#pad(split(system('date +"%a %d %b %Y" | figlet -w 100'), '\n'))

            let g:startify_change_to_dir=1
            let g:startify_change_to_vcs_root = 1
            let g:startify_commands = [
                \ { 'i': ['Open init.lua', 'e ~/.dot/.config/nvim/init.lua| lcd %:p:h'] },
                \ { 'n': ['Open Notes', 'SLoad RedHatVault | colorscheme catppuccin-frappe | set guifont=Hasklig:h11 | set linespace=3 | highlight Folded guibg=none guifg=#51576d' ] },
                \ { 'E': ['Open Espanso', 'SLoad Espanso'] },
                \ { 'o': ['Open Orgmode', 'SLoad Orgmode | highlight Folded guibg=none guifg=fg'] },
                \ { 'w': ['Open Work org', 'SLoad Worgmode | highlight Folded guibg=none guifg=fg'] },
                \ ]
            let g:startify_enable_special = 0
            let g:startify_files_number = 3

            let g:startify_session_delete_buffers = 1
            let g:startify_session_delete_buffers = 1
            let g:startify_session_persistence = 1

            function! s:list_commits()
                let git = 'git '
                let commits = systemlist(git .' log --oneline | head -n10')
                let git = 'G'. git[1:]
                return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
            endfunction

            function! s:current_branch()
                let git = 'git '
                let branch = system(git . 'branch --show-current | tr -d "\n"')
                return branch
            endfunction

            let current_branch = s:current_branch()
            let g:startify_lists = [
                \ { 'type': 'commands',  'header': ['   Commands']       },
                \ { 'header': ['   Recent files in this directory'], 'type': 'dir' },
                \ { 'header': ['   Commits in branch ' .. current_branch ],        'type': function('s:list_commits') },
                \ ]
        ]]
    end,
}
