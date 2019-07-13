if has('linebreak')
  set breakindent              " indent wrapped lines to match start
  if exists('&breakindentopt')
    set breakindentopt=shift:2 " emphasize broken lines by indenting them
  endif
endif

set autowrite
set backspace=indent,eol,start            " fix backspace misbehavior
set clipboard+=unnamedplus
set cino+=(0                              " Align function arguments
set colorcolumn=0
set completeopt=longest,menu,preview      " Select block not limited to shortest line
set cursorline                            " Disable highlight current line
set expandtab

if has('folding')
    set foldenable
    if has('windows')
        set fillchars=vert:┃             " vertical split, U:2503 Box Drawings Heavy Vertical
        set fillchars+=fold:·            " folding filler, U:00B7 mid dot
    endif
    set foldmethod=indent
    set foldlevelstart=99
    set foldtext=WincentFoldtext()
endif

set formatoptions+=n                      " smart auto-indenting in numbered lists
set guifont=Source\ Code\ Pro\ for\ Powerline\ Medium\ 11
set guioptions-=m                         " Remove the menubar
set guioptions-=T                         " Remove the toolbar

if executable('ag')
    set grepprg=ag\ -s\ -H\ --nogroup\ --column\ --smart-case\ --follow
endif

set ignorecase                            " case management in search
set incsearch                             " search as characters are entered
set hlsearch                              " highlight matches
set hidden
"set highlight+=@:ColorColumn             " ~/@ at end of window, 'showbreak'
"set highlight+=N:DiffText                " make current line number stand out a little
"set highlight+=c:LineNr                  " blend vertical separators with line numbers
set lazyredraw                            " don't update screen during macro replay
set laststatus=2                          " always show status
set lcs=trail:·,tab:»·                    " Highlight spaces, tabs, end of line chars, wrap and brake lines
set linebreak                             " wrap long lines at characters in 'breakat'
if has('nvim')
else
  set lines=40 columns=200
  set linespace=1
endif
set list                                  " show whitespace
set listchars=nbsp:⦸                      " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:▷┅                     " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                          " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
set listchars+=extends:»                  " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«                 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•                    " BULLET (U+2022, UTF-8: E2 80 A2)
set mouse=a
set nobackup
set nojoinspaces                          " No add space when joining lines
set noswapfile
set number                                " Show line numbers
set path+=**
set relativenumber
set scrolloff=3                           " Keeping the cursor away from the last line
set sidescrolloff=3                       " Same as scrolloff, but for columns
set shiftround                            " always indent by multiple of shiftwidth
"set shiftwidth=2                          " spaces per tab (when shifting)
set shortmess+=A                          " ignore annoying swapfile messages
set shortmess+=I                          " no splash screen
"set shortmess+=W                          " don't echo "[w]"/"[written]" when writing
set shortmess+=a                          " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=o                          " overwrite file-written messages
set shortmess+=t                          " truncate file messages at start

if has('linebreak')
  let &showbreak='⤷ '                     " ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
endif

set showcmd                               " show last command in the very bottom right of VI
set showmatch

set smarttab                              " <tab>/<BS> indent/dedent in leading whitespace
set spelllang=en,it                       " accept both english and italian words
if has('syntax')
  set spellcapcheck=                      " don't check for capital letters at start of sentence
endif
set splitbelow                            " Style open split below
set splitright                            " Style open split on the right

set showtabline=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%{GitStatus()}\           " git branch
set statusline+=%f\                       " path
set statusline+=%h%m%R%W\                 " flags and buf no
set statusline+=%=                        " right side
set statusline+=%y\                       " file type
if has('nvim')
    set statusline+=%{LinterStatus()}\    " Linter status
endif
set statusline+=%20(ℓ:%l/%L\ 𝒸:%v\ [%P]%) " line and file percentage

set tabstop=4 shiftwidth=4 softtabstop=4
set tags=tags;/                           " Makes ctags visible from subdirectories

set thesaurus+=~/.config/nvim/thesaurus/thesaurus.txt

set updatetime=750
set virtualedit=block                     "  allow cursor to move where there is no text in visual block mode
set wildignore+=*.o,*.rej                 " patterns to ignore during file-navigation
set wildmode=longest:full,full            " shell-like autocomplete to unambiguous portion
set wildmenu                              " graphical menu of autocomplete matches
"set wildmode=list:longest,full
set wrap linebreak nolist


