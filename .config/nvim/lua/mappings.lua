local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end
local function nmap(k, v) map('n', k, v) end
local function vmap(k, v) map('v', k, v) end
local function imap(k, v) map('i', k, v) end

-- toggle background
nmap('<F4>', ':call ToggleBackground()<cr>')
-- toggle transparent background
nmap('<F8>', ':hi Normal guibg=none ctermbg=none<cr>')
-- variable definition in command line
nmap('<leader>fi', '[i')
nmap('<leader>fI', ':TlistShowPrototype<cr>')

-- align block of text.
vmap('<', '<gv')
vmap('>', '>gv')
nmap('>', '>>')
nmap('<', '<<')

-- buffer: delete till the end of the line
nmap('X', 'vg_x')

-- buffer: motion
nmap('<A-Left>',  '<Esc>:bprevious<CR>')
nmap('<A-Right>', '<Esc>:bnext<CR>')
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
nmap('<leader>e', ':e<cr>')
nmap('ct', ':checktime<cr>')

-- buffer select ALL
--nmap(C :%y+<cr>
nmap('C', 'ggvG$')

-- buffer: show full path
nmap('<leader>g', ":echo expand('%')<cr>")
-- buffer: copy full path
nmap('<leader>G', ':!echo % | xclip -sel clipboard<cr>')

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
nmap('<leader>bdo', ':%bd<CR><C-O>:bd#<CR>')
-- end buffer: close

-- buffer: save
imap('<C-s>',  '<Esc>:write<CR>')
nmap('<C-s>',   '<Esc>:write<CR>')
nmap('ss',   '<Esc>:write<CR>')
--

-- buffer: show list
nmap('<C-b>', ':b')

-- register 0 hold latest Yank, let's map yp to `--0p`
nmap('yp', '"0p')
-- clipboard yank till the end of the line
vmap('Y', '"+y')
-- clipboard paste
nmap('P', '"+p')

--directory explore
--nmap(<leader>ex <esc>:Explore<cr>
nmap('<leader>ex', ':!%:p<cr>')


-- directory change here
nmap('<leader>here', ':lcd %:p:h<CR>')

-- vimdiff
nmap('<leader>do', ':call ToggleDiff()<cr>')


-- edit font (effects on GUI only)
nmap('<leader>ef', ':set guifont=')

-- edit: remove trailing space
nmap('<leader>ss', ':TrimTrailingSpaces<cr>')

-- enter command mode
nmap(';', ':')
vmap(';', ':')
imap('<C-c>', '<c-x><c-o>')

-- no ex-mode
nmap('Q', '<nop>')

-- execute current line as command in bash (ex. zathura path/to/pdf -P 10)
nmap('<leader>z', ':.w !bash<cr>')
nmap('<leader>Z', ':.w !sudo bash<cr>')

-- execute external command
nmap('!', ':!')
-- exit vim
nmap('qa', '<esc>:qa!<cr>')

-- terminal opened below any other vertical split
nmap('<leader>x', ':botright split | resize 20 | terminal<cr>')
nmap('<leader>vx', ':vertical split | terminal<cr>')

-- fold: always toggle all fold at current position
nmap('za', 'zA')
-- toggle folding
nmap('<leader>z', 'zA')

-- git diff shortcuts: enhance diff put and diff obtain moving automatically to
-- the next change
nmap('dp', 'dp]c')
nmap('do', 'do]c')
nmap('<leader>wds', ':windo diffthis')
nmap('<leader>wdo', ':windo diffoff')

-- highlight selected word
vmap("*", ":let @/='<<C-R>=expand(--<cword>--)<CR>>'<CR>:set hls<CR>")
-- highlight current word and do not move to next match
nmap('*', '*``')

-- jumplist: store relative line number jumps if they exceed a thresholt (thanks Wincent)
-- nmap(<expr> k (v:count > 5 ? --m'-- . v:count : '') . 'k'
-- nmap(<expr> j (v:count > 5 ? --m'-- . v:count : '') . 'j'

-- macro repeat last in normal buffer.
--nmap(<expr> <cr> empty(&buftype) ? '@@' : '<cr>'

-- make
nmap('<F3>', ':make<cr>')

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
nmap('<C-l>', 'w')
nmap('<C-h>', 'b')
nmap('<C-k>', '10k')
nmap('<C-j>', '10j')
nmap('E', '$')
vmap('E', '$')
nmap('B', '^')
vmap('B', '^')


-- move to previous buffer
nmap('<leader>p', '<C-^>')


-- move between tabs
nmap('tn', 'gt')
nmap('tb', 'gT')
nmap('<M-l>', 'gt')
nmap('<M-h>', 'gT')
-- also create and delete tabs
nmap('tc', ':tabnew<cr>')
nmap('td', ':tabclose<cr>')


-- normal mode enter (map both jj and kk so that I can type j and `Esc` with kk)
imap('jj', '<Esc>')
imap('kk', '<Esc>')

-- Notes (see plugin/tasks)

-- open file with xdg-open (e.g. images in markdown files)
nmap('<leader>gx', ':!xdg-open %:p:h/<cfile>')

-- replace current word with confirmation and magic \v
nmap('<leader>c*', '<esc>:%s///gc<left><left><left><left><C-r><C-w><right>')
vmap('<leader>c*', 'y<esc>:%s///gc<left><left><left><left><C-r>--<right>')

-- replace in all buffer
nmap('rep', '<Esc>:%s/')

-- resize horizontal window splits (using --=-- in place of --+-- to avoid
-- combinations)
--nmap(<silent> <leader>= :exe --vertical resize +5--<CR>
--nmap(<silent> <leader>- :exe --vertical resize -5--<CR>
-- resize vertical window splits
nmap('<silent>', '= :exe --resize +2--<CR>')
nmap('<silent>', '- :exe --resize -2--<CR>')

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
nmap('wh', '<C-w>h')
nmap('wj', '<C-w>j')
nmap('wk', '<C-w>k')
nmap('wl', '<C-w>l')

-- move selected lines up and down
vmap('<A-Down>', ":m '>+1<CR>gv=gv")
vmap('<A-Up>', ":m '<-2<CR>gv=gv")

-- quickfix (and local) window mapping to open at the full bottom (even with splits)
nmap('<leader>co', ':Copen<cr>')
nmap('<leader>lo', ':botright lwindow<cr>')

-- reload vimrc
nmap('<silent>', '<leader>vr :source $MYVIMRC<CR>')
-- reload vim and install plugins
nmap('<silent>', '<leader>V  :source $MYVIMRC<CR>:PlugInstall<CR>')

-- scrollbind
nmap('<leader>sb', ':call ToggleScrollBind()<cr>')

-- tag open in split
nmap('D', '<C-w>}')

-- tag jump to occurence if there's only one (use always tselect instead of tag)
nmap('<C-]>', 'g<C-]>')

-- yank till the end of the line
nmap('Y', 'yg_')

-- wrap/unwrap
nmap('<leader>w', 'set wrap<cr>')
nmap('<leader>wn', 'set nowrap<cr>')
