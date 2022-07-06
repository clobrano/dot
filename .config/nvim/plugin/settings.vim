colorscheme dracula
if has('linebreak')
  set breakindent              " indent wrapped lines to match start
  if exists('&breakindentopt')
    set breakindentopt=shift:1 " emphasize broken lines by indenting them
  endif
endif

set autowrite
set backspace=indent,eol,start            " fix backspace misbehavior
set clipboard+=unnamedplus
set cino+=(0                              " Align function arguments
set cmdheight=2
set conceallevel=2                        " conceal text hiddend unless it has a custom replacement.
set concealcursor=c                       " do not conceal text in normal mode, otherwise it is too hard to edit it.
set colorcolumn=0
set complete=.,w,b,u,t
set completeopt=longest,menu,preview      " Select block not limited to shortest line
set cursorline                          " Disable highlight current line
set cursorlineopt=number
highlight CursorLineNr ctermbg=yellow
set expandtab

if has('folding')
    if has('windows')
        set fillchars=vert:┃             " vertical split, U:2503 Box Drawings Heavy Vertical
        set fillchars+=fold:·            " folding filler, U:00B7 mid dot
    endif
    set foldenable
    set foldmethod=indent
    set foldlevelstart=99
    set foldtext=WincentFoldtext()
endif

set formatoptions+=n                      " smart auto-indenting in numbered lists
set guifont=FiraCode\ Nerd\ Font\ Mono:h10
set guioptions-=m                         " Remove the menubar
set guioptions-=T                         " Remove the toolbar

if executable('ag')
    set grepprg=ag\ -U\ --nogroup\ --smart-case
endif

set ignorecase                            " case management in search
set incsearch                             " search as characters are entered
set inccommand=split                      " Shows the effects of a command incrementally, as you type
set hlsearch                              " highlight matches
set hidden
"set highlight+=@:ColorColumn             " ~/@ at end of window, 'showbreak'
"set highlight+=N:DiffText                " make current line number stand out a little
"set highlight+=c:LineNr                  " blend vertical separators with line numbers
set nolazyredraw                          " disabled for now ( don't update screen during macro replay )
set laststatus=3                          " always show status
set linebreak                             " wrap long lines at characters in 'breakat'
if has('nvim')
else
  set lines=40 columns=180
  set linespace=1
endif
set list                                  " show whitespace
set listchars=nbsp:⦸                      " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:··»                    " BULLET, followed by N BULLETS and ends with a double arrow
                                          "
set listchars+=extends:»                  " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«                 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:·                    " BULLET
set mouse=a
set nobackup
set nojoinspaces                          " No add space when joining lines
set noswapfile
set path+=**
set number norelativenumber                 " Set hybrid numbering: absolute number on current line and relative on other lines
set scrolloff=5                           " Keeping the cursor away from the last line
set sidescrolloff=5                       " Same as scrolloff, but for columns
set signcolumn=yes:2
set shiftround                            " always indent by multiple of shiftwidth
"set shiftwidth=2                          " spaces per tab (when shifting)
set shortmess+=A                          " ignore annoying swapfile messages
set shortmess+=I                          " no splash screen
"set shortmess+=W                          " don't echo "[w]"/"[written]" when writing
set shortmess+=a                          " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=o                          " overwrite file-written messages
set shortmess+=t                          " truncate file messages at start

if has('linebreak')
  let &showbreak='↳ '                     " ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
endif

set showcmd                               " show last command in the very bottom right of VI
set showmatch

set smarttab                              " <tab>/<BS> indent/dedent in leading whitespace
set spelllang=en,it                       " accept both english and italian words
set nospell
if has('syntax')
  set spellcapcheck=                      " don't check for capital letters at start of sentence
endif
set splitbelow                            " Style open split below
set splitright                            " Style open split on the right

set t_Co=256
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set tabstop=4 shiftwidth=4 softtabstop=4
set tags=tags;/                           " Makes ctags visible from subdirectories

set thesaurus+=~/.config/nvim/thesaurus/thesaurus.txt

set updatetime=250
set virtualedit=block                     " allow cursor to move where there is no text in visual block mode
set wildignore+=*.o,*.rej                 " patterns to ignore during file-navigation
set wildmode=longest:full,full            " shell-like autocomplete to unambiguous portion
"set wildmode=list:longest,full
set wildmenu                              " graphical menu of autocomplete matches
set wrap linebreak
