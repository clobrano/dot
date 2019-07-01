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
set foldenable
set foldmethod=indent
set foldlevelstart=99
"set foldtext=MyFoldText()                 " Set a nicer foldtext function
"function! MyFoldText()
    "let line = getline(v:foldstart)
    "if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
        "let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
        "let linenum = v:foldstart + 1
        "while linenum < v:foldend
            "let line = getline( linenum )
            "let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
            "if comment_content != ''
                "break
            "endif
            "let linenum = linenum + 1
        "endwhile
        "let sub = initial . ' ' . comment_content
    "else
        "let sub = line
        "let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
        "if startbrace == '{'
            "let line = getline(v:foldend)
            "let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
            "if endbrace == '}'
                "let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
            "endif
        "endif
    "endif
    "let n = v:foldend - v:foldstart
    "let info = " " . n . " lines"
    "let sub = sub . "                                                                                                                  "
    "let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    "let fold_w = getwinvar( 0, '&foldcolumn' )
    "let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
    "return sub . info
"endfunction

set formatoptions+=n                      " smart auto-indenting in numbered lists
set guifont=Source\ Code\ Pro\ for\ Powerline\ medium\ 10
set guioptions-=m                         " Remove the menubar
set guioptions-=T                         " Remove the toolbar
set grepprg=ack                           " Configure vimgrep
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ackprg = 'ag'
    let g:ack_default_options = " -s -H --nogroup --column --smart-case --follow"
    let g:ackhighlight = 1
endif
set ignorecase                            " ignorecase in search by default
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
if has('syntax')
  set spellcapcheck=                      " don't check for capital letters at start of sentence
endif
set splitbelow                            " Style open split below
set splitright                            " Style open split on the right

set showtabline=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%{StatusLineGit()}\       " git branch
set statusline+=%f\                       " path
set statusline+=%h%m%R%W\                 " flags and buf no
set statusline+=%=                        " right side
set statusline+=%y\                       " file type
if has('nvim')
    set statusline+=%{LinterStatus()}\    " Linter status
endif
set statusline+=%20(𝓁:%l/%L\ 𝒸:%v\ [%P]%) " line and file percentage

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


