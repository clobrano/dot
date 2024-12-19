-- [[ Setting options ]]
-- See `:help vim.o`

-- GUI options: no menubar and no toolbar
vim.cmd[[
"set guifont=Source\ Code\ Pro:h11
"set guifont=Hasklig:h11
set guioptions-=m
set guioptions-=T]]

vim.cmd.colorscheme 'catppuccin-frappe'
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.opt.foldmethod='expr'
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--vim.o.foldcolumn= '0'
vim.o.foldlevelstart=99
vim.opt.foldlevelstart=99
vim.o.foldlevel=99
vim.opt.foldlevel=99
vim.o.foldenable = false

vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true
vim.o.incsearch = true -- search as characters are entered
vim.o.inccommand = "split" -- Show the effects of a command incrementally as you type
vim.o.hlsearch = true -- Set highlight on search
vim.opt.hidden = true
vim.opt.lazyredraw = false -- no screen refresh during macro replay
vim.opt.laststatus = 3 -- always show status
vim.opt.linebreak = true -- wrap long lines at characters in 'breakat'

vim.wo.signcolumn = 'yes:2' -- Keep signcolumn on by default
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 500 -- This is also the timeout for which-key
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true -- You should make sure your terminal supports this

vim.opt.autowrite = true
vim.opt.backspace = {'indent', 'eol', 'start'} -- fix backspace misbehavior
vim.opt.cmdheight = 2

vim.opt.conceallevel = 2 -- conceal text hidden unless it has a custom replacement
vim.opt.concealcursor = 'c' -- do not conceal in normal mode, simpler editing

vim.opt.colorcolumn = '0'
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.cmd[[highlight CursorLineNr ctermfg=yellow guifg=yellow]]

vim.opt.expandtab = true
vim.opt.formatoptions = 'tcroqn2bljp' -- smart auto-indenting in numbered list

vim.opt.list = true -- show whitespace

vim.opt.listchars:append('nbsp:⦸')  --set listchars=nbsp:⦸  -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
vim.opt.listchars:append( 'tab:··»' ) --set listchars+=tab:··»  -- BULLET, followed by N BULLETS and ends with a double arrow
vim.opt.listchars:append('extends:»') --set listchars+=extends:» -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
vim.opt.listchars:append('precedes:«') --set listchars+=precedes:« -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
vim.opt.listchars:append('trail:·') --set listchars+=trail:· -- BULLET

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.joinspaces = false -- do not add space when joining lines

vim.opt.scrolloff = 8
vim.opt.shiftround = true                            -- always indent by multiple of shiftwidth
vim.shiftwidth = 4                          -- spaces per tab (when shifting)
vim.opt.shortmess:append('A')                          -- ignore annoying swapfile messages
vim.opt.shortmess:append('I')                          -- no splash screen
vim.opt.shortmess:append('W')  --set shortmess+=W   -- don't echo --[w]--/--[written]-- when writing
vim.opt.shortmess:append('a')                          -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
vim.opt.shortmess:append('o')                          -- overwrite file-written messages
vim.opt.shortmess:append('t')                          -- truncate file messages at start

-- ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
if vim.fn.has('linebreak') then
  vim.cmd[[let &showbreak='  ']]
end

vim.opt.showcmd = true                              -- show last command in the very bottom right of VI
vim.opt.showmatch = true

vim.opt.smarttab = true                              -- <tab>/<BS> indent/dedent in leading whitespace
vim.opt.spelllang = 'en,it'                       -- accept both english and italian words
vim.opt.spell = false
vim.opt.spellcapcheck = "false"                      -- don't check for capital letters at start of sentence
vim.opt.splitbelow = true                            -- Style open split below
vim.opt.splitright = true                            -- Style open split on the right

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tags = 'tags;/'                           -- Makes ctags visible from subdirectories

vim.opt.textwidth = 10000 -- use larger text limit, unless required (e.g. commit message)

vim.opt.thesaurus:append('~/.config/nvim/thesaurus/thesaurus.txt')

vim.opt.virtualedit = 'block'                     -- allow cursor to move where there is no text in visual block mode
vim.opt.wildignore:append('*.o,*.rej')                 -- patterns to ignore during file-navigation
vim.opt.wildmode = 'longest:full,full'            -- shell-like autocomplete to unambiguous portion
vim.opt.wildmenu = true                              -- graphical menu of autocomplete matches
