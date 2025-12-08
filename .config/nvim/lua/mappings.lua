require 'functions'

local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true, noremap = true })
end
local function nmap(k, v) map('n', k, v) end
local function vmap(k, v) map('v', k, v) end
local function imap(k, v) map('i', k, v) end
local function xmap(k, v) map('x', k, v) end


-- journal
nmap('<leader>jd', ":lua require'functions'.create_note_entry('today')")
nmap('<leader>jt', ":lua require'functions'.create_note_entry(vim.fn.expand('%:p'))")

-- background toggle
nmap('<F4>', ":lua require'functions'.toggle_theme()<cr>")
-- background transparent toggle
nmap('<F8>', ':hi Normal guibg=none ctermbg=none<cr>')
-- variable definition in command line
nmap('<leader>fi', '[i')

-- align block of text.
nmap('<', '<<')
nmap('>', '>>')
vmap('<', '<gv')
vmap('>', '>gv')

vim.keymap.set('i', '<A-i>', '<C-t>', { desc='Indent the line from the start' })
vim.keymap.set('i', '<A-d>', '<C-d>', { desc='De-indent the line from the start' })

-- format: align the paragraph to textwidth (the last <C-o> is to move the cursor back to the initial position)
vim.keymap.set('n', '<leader>ap', 'gq}', { desc = "[A]lign [P]aragraph (alias for 'gq')" })

-- buffer: find
vim.keymap.set('n', '<leader>bb', ':b', { desc = "[F]ind [B]uffer (among opened)" })
-- buffer: move to last visited buffer
vim.keymap.set('n', '<leader>bl', ':b#<cr>', { desc = "[F]ind [L]ast buffer" })


-- buffer: reload
nmap('<leader>rl', ':e! | LspRestart <cr>')
-- buffer: delete till the end of the line
nmap('X', 'vg_x')

-- buffer: motion
--nmap('<A-Left>',  '<Esc>:bprevious<CR>')
--nmap('<A-Right>', '<Esc>:bnext<CR>')
nmap('H',         '<Esc>:bprevious<CR>')
nmap('L',         '<Esc>:bnext<CR>')
nmap('<c-b>',    '<esc>:b<space>')
nmap('m1',       ':bfirst<cr>')
nmap('m2',       ':bfirst<cr>:bn<cr>')
nmap('m3',       ':bfirst<cr>:2bn<cr>')
nmap('m4',       ':bfirst<cr>:3bn<cr>')
nmap('m5',       ':bfirst<cr>:4bn<cr>')
nmap('m6',       ':bfirst<cr>:5bn<cr>')
nmap('m7',       ':bfirst<cr>:6bn<cr>')
nmap('m8',       ':bfirst<cr>:7bn<cr>')
nmap('m9',       ':bfirst<cr>:8bn<cr>')


-- buffer: reload
nmap('<leader>e', ':e!<cr>')
nmap('ct', ':checktime<cr>')

-- buffer select ALL
nmap('C', 'ggvG$')

-- buffer: show full path
nmap('<leader>g', ":echo expand('%')<cr>")
-- buffer: copy full path
nmap('<leader>G', ':!realpath "%" | wl-copy<cr>')

-- buffer: close
nmap('xx', ':bd<CR>')
nmap('x1', ':m1:bd')
nmap('x2', ':m2<cr>:bn<cr>:bd')
nmap('x3', ':m3<cr>:2bn<cr>:bd')
nmap('x4', ':m4<cr>:3bn<cr>:bd')
nmap('x5', ':m5<cr>:4bn<cr>:bd')
nmap('x6', ':m6<cr>:5bn<cr>:bd')
nmap('x7', ':m7<cr>:6bn<cr>:bd')
nmap('x8', ':m8<cr>:7bn<cr>:bd')
nmap('x9', ':m9<cr>:8bn<cr>:bd')
-- buffer: close all buffers except the current one
nmap('<leader>bx', ':%bd<CR><C-O>:bd#<CR>')
-- end buffer: close

-- buffer: save
imap('<C-s>',  '<Esc>:silent write<CR>')
nmap('<C-s>',   '<Esc>:write<CR>')
nmap('ss',   '<Esc>:silent write<CR>')
--

-- buffer: show list
nmap('<C-b>', ':b')

-- register 0 hold latest Yank, let's map yp to `--0p`
nmap('yp', '"0p')
-- clipboard yank till the end of the line
vmap('Y', 'vg_y')
-- clipboard paste
--nmap('P', '"+p')
-- paste below current line (introduced for Orgmode capture new link)
nmap('<C-p>', ':put<cr>')
-- do not override default register when pasting in selection
xmap('p', 'P')

-- alternate register "k"
vim.keymap.set('v', '<leader>y', '"ky')
vim.keymap.set('n', '<leader>p', '"kP')

-- completion shorcuts
imap('<C-f>', '<C-x><C-f>')
--directory explore
--nmap(<leader>ex <esc>:Explore<cr>
nmap('<leader>ex', ':!%:p<cr>')

-- ctags create
vim.keymap.set("n", "<leader>ct", ":!ctags -R .<cr>", { desc = "Create [C][t]ags", noremap = true, silent = true })

-- directory change here
nmap('<leader>here', ':lcd %:p:h<CR>')

-- vimdiff: Diff Start, Diff Off, Diff Put, Diff Get
--nmap('<leader>ds', ':windo diffthis<cr>')
--nmap('<leader>do', ':windo diffoff<cr>')
nmap('<leader>dh', ':diffget //2<cr>')
nmap('<leader>dl', ':diffget //3<cr>')
-- enhance diff put and diff obtain moving automatically to the next change
nmap('dp', 'dp]c')
nmap('do', 'do]c')


-- edit font (effects on GUI only)
nmap('<leader>ef', ':set guifont=')

-- edit: remove trailing space
nmap('<leader>ss', ':let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>')

-- enter command mode
nmap(';', ':')
vmap(';', ':')
imap('<C-c>', '<c-x><c-o>')

-- no ex-mode
nmap('Q', '<nop>')

-- execute current line as command in bash (ex. zathura path/to/pdf -P 10)
nmap('<leader>Z', ':.w !bash<cr>')

-- execute external command
nmap('!', ':!')
-- exit vim
nmap('qa', '<esc>:qa!<cr>')

-- terminal opened below any other vertical split
nmap('<leader>x', ':botright split | resize 20 | terminal<cr>')
nmap('<leader>vx', ':vertical split | terminal<cr>')
--tmap('<Esc>', '<c-\\><c-n>')
--tmap('jj', '<c-\\><c-n>')

-- fold: always toggle all fold at current position
--nmap('za', 'zA')
-- toggle folding
--nmap('<leader>z', 'zA')
nmap('zn', 'zr')
-- Fold all except current section
nmap('<leader>zh', 'zM | zo | zo | zo | zo')

-- GBrowse selection
xmap('<leader>gy', ":GBrowse!")


-- highlight selected word
vim.cmd[[
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
]]
--vmap("*", ":let @/='<<C-R>=expand(\"<cword>\")<CR>>'<CR>:set hls<CR>")
-- highlight current word and do not move to next match
nmap('*', '*``')

-- jumplist: store relative line number jumps if they exceed a thresholt (thanks Wincent)
-- nmap(<expr> k (v:count > 5 ? --m'-- . v:count : '') . 'k'
-- nmap(<expr> j (v:count > 5 ? --m'-- . v:count : '') . 'j'

-- macro repeat last in normal buffer.
--nmap(<expr> <cr> empty(&buftype) ? '@@' : '<cr>'

-- make
--nmap('<F3>', ':make<cr>')

-- move: fix weird chars in terminal using arrow keys in insert mode {{{
imap('[1;5A', '<esc>ki')
imap('[1;5C', '<esc>li')
imap('[1;5B', '<esc>ji')
imap('[1;5D', '<esc>hi')
--}}}


-- move to next/prev error
nmap('[e', ':lprev<cr>')
nmap(']e', ':lnext<cr>')


-- move to next/prev build error
nmap('[b', ':cprev<cr>')
nmap(']b', ':cnext<cr>')


-- move: always move line by line, regardless wrap
nmap('k', 'gk')
nmap('j', 'gj')


-- move fast
nmap('<C-l>', '10l')
nmap('<C-h>', '10h')
nmap('<C-k>', '10k')
nmap('<C-j>', '10j')
nmap('E', 'g_')
vmap('E', 'g_')
nmap('B', '^') -- move to first non-blank character (use '0' to move to the beginning of the line)
vmap('B', '^') -- selection to first non-blank character


-- move to previous buffer
--nmap('<leader>p', '<C-^>')


-- move between tabs
nmap('tn', 'gt')
nmap('tb', 'gT')

-- also create and delete tabs
nmap('tc', ':tabnew<cr>')
nmap('td', ':tabclose<cr>')

-- navigation
-- move to parent folder (until I prevent changing cwd in Notes)
nmap('<leader>cd', ':cd ..<cr>')

-- normal mode enter (map both jj and kk so that I can type j and `Esc` with kk)
imap('jj', '<Esc>')
--imap('jj',   '<Esc>:write<CR>')

-- Notes (see plugin/tasks)
-- open file with xdg-open (e.g. images in markdown files)
nmap('<leader>xo', ':!xdg-open %:p:h/<cfile>')

-- replace current word with confirmation and magic \v
nmap('<leader>c*', '<esc>:%s///gc<left><left><left><left><C-r><C-w><right>')
vmap('<leader>c*', 'y<esc>:%s///gc<left><left><left><left><C-r>--<right>')

-- replace in all buffer
nmap('<leader>rep', '<Esc>:%s/')

-- 2025-03-09 Comment out these resize mapping as I never use them
-- resize horizontal window splits (using = in place of + to avoid combinations)
--nmap(<silent> <leader>= :exe --vertical resize +5--<CR>
--nmap(<silent> <leader>- :exe --vertical resize -5--<CR>
-- resize vertical window splits
-- mnemonics: H -> High (increase window width)
-- mnemonics: L -> Low (decrease window width)
--nmap('w.', '2<C-w>>') -- use . in place of > to avoid typing shift
--nmap('w,', '2<C-w><') -- use , in place of < to avoid typing shift
--nmap('w-', '<C-w>-')
--nmap('w=', '<C-w>+') -- use = in place of + to avoid typing shift
--nmap('-', ':exe --resize -2--<CR>')
--nmap('w3', ':vertical resize -30<cr>')

-- zoom current window
nmap('<leader>zz', '<C-w>|<C-w>_')

-- sudo save
--cmap w!! w !sudo tee > /dev/null %

-- search with * with smartcase (if set): Store cword in search register, with
-- search-magic and boundaries, then search forward and go to next
--nmap(* :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=1<cr>n``
--nmap(# :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=0<cr>n``
--nmap(g* :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=1<cr>n``
--nmap(g# :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=0<cr>n``

-- search word in all visible filesystem
--nmap(fa <Esc>:grep! ""<left>

-- search word under cursor in all visible filesystem
--nmap(fc <Esc>:grep! --\b<C-R><C-W>\b--<CR>:cw<CR>

-- search for selected text, forwards or backwards. {{{
--vmap(<silent> * :<C-U>
  --\let old_reg=getreg('--')<Bar>let old_regtype=getregtype('--')<CR>
  --\gvy/<C-R><C-R>=substitute(
  --\escape(@--, '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  --\gV:call setreg('--', old_reg, old_regtype)<CR>
  --\``
--vmap(<silent> # :<C-U>
  --\let old_reg=getreg('--')<Bar>let old_regtype=getregtype('--')<CR>
  --\gvy?<C-R><C-R>=substitute(
  --\escape(@--, '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  --\gV:call setreg('--', old_reg, old_regtype)<CR>
nmap('<leader><space>', ':nohlsearch<CR>')
--}}}

-- search or go to Next/Prev match {{{
--nmap(fn /
--vmap(fn y/<C-r>"<cr>
--nmap(fp <esc>?
--vmap(fp y?<C-r>"<cr>
nmap('n', 'nzz')
nmap('N', 'Nzz')
nmap('}', '}zz')
--}}}

-- search file
--if ! executable('fzf')
    --nmap(<leader>ff :find **/*
--endif

-- select till the end of the line
vmap('T', '$h')

-- simplify windows-command mappings (first remap move-to-next-word)
--vim.keymap.set('n', 'mm', 'w', { silent = true, noremap = true })
vim.keymap.set('n', '<M-w>', '<C-w>', { silent = true, noremap = true })

--close splits
nmap('cl', ':close<cr>')
nmap('xl', '<C-w>l:close<CR>')
nmap('xh', '<C-w>h:close<CR>')
nmap('xj', '<C-w>j:close<CR>')
nmap('xk', '<C-w>k:close<CR>')
-- keep only current split
nmap('<leader>o', '<C-w>o')
-- maximize current split
nmap('<C-w>m', '<C-w>|<C-w>_')

-- toggle highlight word under cursor
nmap('<leader>hw', ':call ToggleHlCurWord()<cr>')

-- convert horizontal splits to vertical and vice versa
nmap('<leader>tv', '<C-w>t<C-w>H')
nmap('<leader>th', '<C-w>t<C-w>K')

-- moves between splits
--nmap('wh', '<C-w>h')
--nmap('wj', '<C-w>j')
--nmap('wk', '<C-w>k')
--nmap('wl', '<C-w>l')

-- move selected lines up and down
vmap('<A-Down>', ":m '>+1<CR>gv=gv")
vmap('<A-Up>', ":m '<-2<CR>gv=gv")

-- quickfix (and local) window mapping to open at the full bottom (even with splits)
nmap('<leader>co', ':Copen<cr>')
nmap('<leader>lo', ':botright lwindow<cr>')

-- reload vimrc
nmap('<leader>vr', ':source $MYVIMRC<CR>')
-- reload vim and install plugins
nmap('<leader>V',  ':source $MYVIMRC<CR>:PlugInstall<CR>')

-- scrollbind
nmap('<leader>sb', ':call ToggleScrollBind()<cr>')

-- session
nmap('<leader>sc', ':SClose<cr>')

-- tag open in split
nmap('D', '<C-w>}')

-- tag jump to occurence if there's only one (use always tselect instead of tag)
nmap('<C-]>', 'g<C-]>')

-- find vim tags with telescope
nmap('<leader>fv', 'vt: & <leader>fa')

-- lsp servers mappings
nmap('<leader>lr', ':LspRestart<cr>')

-- paste a UUID for referencing text content (e.g. in markdown files)
--imap('<C-u>', "<esc>:lua require'functions'.executeAndPaste('uuidgen | cut -d\"-\" -f1')<cr>ea")
-- zettelkasted UUID (date + time)
imap('<C-u>', "<esc>:lua require'functions'.executeAndPaste('date +%Y%m%d%H%M%S')<cr>ea")
nmap('<leader>zk', "<esc>:lua require'functions'.zettelkastenID()<cr>")
nmap('<leader>gl', ":lua require'functions'.makeGmailSearchLink()<cr>")

-- find todos in all files (needs folke/todo-comments)
--nmap('<leader>td', ':TodoTelescope keywords=TODO<cr>')
-- find todos in current buffer (local) (needs folke/todo-comments)
--nmap('<leader>tdl', ':TodoTelescope keywords=TODO cwd=%<cr>')

--vim.keymap.set('n', '<leader>tdl', ':exe ":TodoQuickFix cwd=" .. fnameescape(expand("%:p"))', {desc = "search TODOs in current file"})
-- yank till the end of the line
nmap('Y', 'yg_')

-- wrap/unwrap toggle
nmap('<leader>w', ':set wrap!<cr>')
nmap('<leader>wa', ':windo set wrap!<cr>')

-- markdown section
-- bold
vmap('<leader>bo', '"adi**<esc>"apa**<esc>')
-- wikilink
--vmap('<leader>ml', '"adi[[<esc>"apa]]<esc>')
vmap('<leader>ml', ':<C-u>lua CreateFileAndWikiLink()<CR>')
-- strikethrough
vmap('<leader>st', '"adi~~<esc>"apa~~<esc>')

-- Some plugins things
-- TODO: move it to zenmode
nmap('<leader>zm', ':ZenMode<cr>')

-- TODO: move it to neogit configuration file
nmap('<leader>gs', ':Neogit<cr>')

-- add space below cursor (_p_ush)
nmap('<leader>k', ":call append(line('.'), '')<CR>")

vim.api.nvim_set_keymap(
  'n',
  '<leader>scp',
  [[:execute '!scp % helios:/root/2no-lab/' . expand('%:h:t') . '/' . expand('%:t')<CR>]],
  { noremap = true, silent = true }
)

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Quickly highlight yanked text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Avante
vim.keymap.set("n", "<leader>jaa", ":AvanteAsk<cr>",
  { desc = "[C]odecompanion [A]ction", silent = true, noremap = true })
vim.keymap.set("n", "<leader>jac", ":AvanteChat<cr>",
  { desc = "[C]odecompanion [C]hat", silent = true, noremap = true })
vim.keymap.set("n", "<leader>jae", ":AvanteChat<cr>",
  { desc = "[C]odecompanion [C]hat", silent = true, noremap = true })
vim.keymap.set("n", "<leader>jat", ":AvanteToggle<cr>",
  { desc = "[C]odecompanion [C]hat", silent = true, noremap = true })

-- Remapping arrow keys in Command mode
vim.api.nvim_set_keymap('c', '<C-k>', '<Cmd>call feedkeys("<Up>", "n")<CR>', { noremap = true, silent = true, desc = "Remap Up arrow key to C-k" })
vim.api.nvim_set_keymap('c', '<C-l>', '<Cmd>call feedkeys("<Down>", "n")<CR>', { noremap = true, silent = true, desc = "Remap Down arrow key to C-l" })
