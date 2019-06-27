" Plugins                            {{{
" VimPlug configuration              {{{
let mapleader = ' '
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source ~/.config/nvim/init.vim
endif

call plug#begin()

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
"}}}
" Look & Feel                        {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'crusoexia/vim-monokai'
Plug 'dracula/vim'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'rakr/vim-one'
"}}}
" Search & Replace                   {{{
Plug 'MattesGroeger/vim-bookmarks'
Plug 'derekwyatt/vim-fswitch'
Plug 'junegunn/fzf',                     { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/Mark--Karkat',         { 'on': 'Mark'}
Plug 'vim-scripts/taglist.vim'
"}}}
" Text and Code Checking/Linting     {{{
Plug 'chrisbra/Colorizer'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/vim-easy-align'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/IndexedSearch'
Plug 'vim-syntastic/syntastic'
"}}}
" GIT helpers                        {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'jreybert/vimagit'
"}}}
" C/C++                              {{{
Plug 'chazy/cscope_maps',                {'for': ['c', 'cpp']}
Plug 'hari-rangarajan/CCTree',           {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
Plug 'vim-utils/vim-man',                {'for': ['c', 'cpp']}
Plug 'vim-scripts/DoxygenToolkit.vim',   {'for': ['c', 'cpp']}
"}}}
" Go                                 {{{
Plug 'fatih/vim-go', {'for': 'go', 'do': 'GoUpdateBinaries'}
"}}}
" Markdown/Notes                     {{{
Plug 'plasticboy/vim-markdown',           {'for': 'markdown'}
Plug 'JamshedVesuna/vim-markdown-preview',{'for': 'markdown'}
Plug 'vim-jp/vital.vim'
"}}}
" NodeJS                             {{{
"Plug 'moll/vim-node',                    {'for': 'javascript'}
"Plug 'guileen/vim-node-dict',            {'for': 'javascript'}
"}}}
" Javascript                         {{{
Plug 'pangloss/vim-javascript',          {'for': 'javascript'}
"Plug 'digitaltoad/vim-pug',              {'for': 'pug'}
"}}}
" Python                             {{{
Plug 'davidhalter/jedi',                 {'for': 'python'}
Plug 'davidhalter/jedi-vim',             {'for': 'python'}
Plug 'ambv/black',                       {'for': 'python'}
"}}}
" For Writers                        {{{
"Plug 'reedes/vim-pencil'           " Super-powered writing things
Plug 'reedes/vim-lexical'          " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'      " Better autocorrections
Plug 'reedes/vim-textobj-sentence' " Treat sentences as text objects
Plug 'reedes/vim-wordy'            " Weasel words and passive voice
Plug 'junegunn/goyo.vim'
Plug 'sotte/presenting.vim'
Plug 'tpope/vim-eunuch'
"}}}
" Generics                           {{{
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'janko/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'           " testing 2019-05-16
Plug 'vim-scripts/marvim' " give a name to macros
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"}}}
let g:deoplete#enable_at_startup = 1
call plug#end()
set nocompatible
"}}}
" Editor                             {{{
syntax enable
filetype on
set updatetime=750
set linespace=1
set hidden
set thesaurus+=~/.vim/thesaurus/thesaurus.txt

autocmd VimResized * execute "normal! \<c-w>="

" Look&Feel
command! HighlightDark highlight Search gui=bold guibg=NONE guifg=orange <bar> highlight Search cterm=bold ctermbg=NONE ctermfg=214
command! Parens highlight MatchParen gui=bold guibg=NONE guifg=magenta

function! MonokaiSet()
    exe "colorscheme monokai"
    exe "set background=dark"
    exe "hi Normal ctermbg=235 ctermfg=15"
    exe "Parens"
    exe "HighlightDark"
    exe "nnoremap * *``"
    exe "set textwidth=0"
    exe "hi StatusLine cterm=italic ctermbg=252"
endfunction
command! Monokai    :call MonokaiSet()

function! PapercolorSet()
    exe "colorscheme PaperColor"
    exe "set background=light"
    exe "HighlightDark"
    exe "nnoremap * *``"
    exe "set textwidth=0"
endfunction
command! Papercolor :call PapercolorSet()

if has('nvim')
else
  set guifont=Source\ Code\ Pro\ for\ Powerline\ medium\ 10
  set lines=35 columns=150
  nnoremap <leader>ef <esc>:set guifont=Source\ Code\ Pro\ for\ Powerline\ medium\<space>
endif

try
    echo g:colors_name
catch
  call PapercolorSet()
endtry

" }}}
" System settings                    {{{
source ~/.config/nvim/plugins/settings.vim
nnoremap ; :
vnoremap ; :
inoremap <C-c> <c-x><c-o>
" Reload open buffers
nnoremap <F5> :checktime<cr>
cabbr cs colorscheme
"}}}
" System mappings                    {{{

" Fix weird chars in terminal using arrow keys (INSERT mode)
inoremap [1;5A <esc>ki
inoremap [1;5C <esc>li
inoremap [1;5B <esc>ji
inoremap [1;5D <esc>hi

" ------------------------------------------ Esc button is too far and No Ex mode
inoremap jj <Esc>
nnoremap Q <nop>

" ------------------------------------------ Navigation
noremap <silent> <Up> gk
noremap <silent> <Down> gj
noremap <silent> k gk
noremap <silent> j gj

" Remap fast moves
nnoremap <C-l> w
nnoremap <C-h> b
nnoremap <C-k> 10k
nnoremap <C-j> 10j
nnoremap E g_
vnoremap E g_
nnoremap B ^
vnoremap B ^

" Open previous buffer
nnoremap <leader>p <C-^>

" Move between tabs
nnoremap tn gt
nnoremap tb gT

" Moves between splits
nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l

" ------------------------------------------ Copy & Paste as normal people (in progress)
vnoremap Y "+y<CR>
nnoremap P "+p
xnoremap <silent> p p:let @+=@0<CR>
vnoremap <m-c> "+y<CR>
inoremap <m-v> <esc>"+p
noremap  <m-v> "+p
nnoremap <leader>va ggvGE
" select all
let @a='ggvGE'
" ------------------------------------------ Align blocks of text
vmap < <gv
vmap > >gv
nnoremap > >>
nnoremap < <<
" ------------------------------------------ Search & Replace
" Highlight current word
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

nnoremap c* <esc>:%s/\v//gc<left><left><left><left><C-r><C-w><right>

noremap rep <Esc>:%s//gc<Left><Left><Left>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
  \``
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
nnoremap <leader><space> :nohlsearch<CR>

" Look for text in current buffer
nnoremap fb <Esc>:g//#<left><left>
vnoremap fb y:g/<C-r>"/#<CR>

" Vertically resize window splits
nnoremap <silent> + :exe "resize +2"<CR>
nnoremap <silent> - :exe "resize -2"<CR>
" ------------------------------------------ Find or go to Next/Prev match
nnoremap fn <esc>/\v
vnoremap fn y/<C-r>"<cr>
nnoremap fp <esc>?
vnoremap fp y?<C-r>"<cr>
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
" ------------------------------------------ Fzf fuzzy searcher (ff = find file)
if has('nvim')
    nnoremap <leader>ff <esc>:FZF<cr>
    cabbr ! term
else
    nnoremap <leader>ff <esc>:FZF<cr>
endif
nnoremap fa <Esc>:Ack! --ignore-dir=TAGS --ignore-dir=tags --ignore-dir=cscope.* ""<left>
nnoremap fc <Esc>:Ack! --ignore-dir=TAGS --ignore-dir=tags --ignore-dir=cscope.* ""<left><C-r><C-w>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
" ------------------------------------------ Make
nnoremap <F5> <esc>:make<cr>
" }}}
" Buffers                            {{{
" -- Save, Close and Force close current buffer
inoremap <C-s> <Esc>:w<CR>
noremap <C-s> <Esc>:w<CR>
nnoremap x <Esc>:bd
nnoremap xx <Esc>:bd<CR>
nnoremap <leader>fx <Esc>:bd!<CR>

" testing delete buffers by positional index
nnoremap x1 m1:bd<cr>
nnoremap x2 m2<cr>:bn<cr>:bd<cr>
nnoremap x3 m3<cr>:2bn<cr>:bd<cr>
nnoremap x4 m4<cr>:3bn<cr>:bd<cr>
nnoremap x5 m5<cr>:4bn<cr>:bd<cr>
nnoremap x6 m6<cr>:5bn<cr>:bd<cr>
nnoremap x7 m7<cr>:6bn<cr>:bd<cr>
nnoremap x8 m8<cr>:7bn<cr>:bd<cr>
nnoremap x9 m9<cr>:8bn<cr>:bd<cr>
" close preview window
nnoremap xp <C-w>z<CR>
nnoremap xl <C-w>l:bd<CR>
nnoremap xh <C-w>h:bd<CR>
nnoremap xj <C-w>j:bd<CR>
nnoremap xk <C-w>k:bd<CR>
" Close quickfix window only
nnoremap <leader>x :cclose<cr>
nnoremap qa <esc>:qa
nnoremap qx <esc>:qa!
" Maximize current window
nnoremap <C-w>m <C-w>\|<C-w>_
" Keep only current window
nnoremap <leader>o <C-w>o

function! CleanClose(tosave)
if (a:tosave == 1)
    w!
endif
let todelbufNr = bufnr("%")
let newbufNr = bufnr("#")
if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
    exe "b".newbufNr
else
    bnext
endif

if (bufnr("%") == todelbufNr)
    new
endif
exe "bd".todelbufNr
endfunction

" ------------------------------------------ Move among buffers
nnoremap <A-w> <C-w>
noremap <A-Left> <Esc>:bp<CR>
noremap H <Esc>:bp<CR>
noremap <A-Right> <Esc>:bnext<CR>
noremap L <Esc>:bnext<CR>
nnoremap <c-b> <esc>:b<space>
nnoremap m1 :bfirst<cr>
nnoremap m2 :bfirst<cr>:bn<cr>
nnoremap m3 :bfirst<cr>:2bn<cr>
nnoremap m4 :bfirst<cr>:3bn<cr>
nnoremap m5 :bfirst<cr>:4bn<cr>
nnoremap m6 :bfirst<cr>:5bn<cr>
nnoremap m7 :bfirst<cr>:6bn<cr>
nnoremap m8 :bfirst<cr>:7bn<cr>
nnoremap m9 :bfirst<cr>:8bn<cr>

" Convert horizontal splits to vertical and vice versa
nnoremap <leader>htv <C-w>t<C-w>H
nnoremap <leader>vth <C-w>t<C-w>K
" ------------------------------------------ Tabs

" }}}
" File exploring                     {{{
cabbr fn find *
let g:netrw_winsize = -28             " absolute width of netrw window
let g:netrw_liststyle = 3             " treetest-view
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_preview = 0
let g:netrw_banner=0
nnoremap <leader>e <esc>:Lexplore<cr>
command! Sethere lcd %:p:h
nnoremap <leader>h <Esc>:Sethere<CR>
" }}}
" Folding                            {{{
nnoremap za zA
nnoremap zM zm
" folding method for css, scss
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}
" }}}
" Init.vim edit and reload           {{{
cabbr einit :edit $MYVIMRC
nnoremap <silent> <leader>vr :source ~/.vimrc<CR>:exe ":echo 'vimrc reloaded'"<CR>:e<CR>
nnoremap <silent> <leader>V  :source ~/.vimrc<CR>:PlugInstall<CR>:exe ":echo 'vimrc reloaded'"<CR>
" }}}

" SW Develop                         {{{
inoremap {<CR>  {<CR>}<Esc>O
inoremap {<Tab>  {}<Left>
" Align function arguments
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" Show alternate file (ex. .c/.cpp <-> .h)
nnoremap <space>a :FSHere<cr>
nnoremap <space>la :FSSplitRight<cr>
" Jump to next/prev error
nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>
" Jump to next/prev build error
nnoremap [b :cprev<cr>
nnoremap ]b :cnext<cr>
" Show variale definition
nnoremap I [i
" Open preview window on current name
nnoremap D <C-w>}
if filereadable(expand('vimrc.local'))
    exe 'source vimrc.local'
endif
" -------------------------------------------------------- Align text
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <leader>ea  <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <leader>ea  <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   1,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }

" Shorcuts for stdints
iabbr u8t  uint8_t
iabbr u16t uint16_t
iabbr u32t uint32_t
iabbr u64t uint64_t
iabbr i8t  int8_t
iabbr i16t int16_t
iabbr i32t int32_t
iabbr i64t int64_t

" Local vimrc
command! Svimrc :!cat vimrc.local
command! Evimrc :e vimrc.local
command! Lvimrc :exe 'source vimrc.local'
iabbr evimrc Evimrc
iabbr svimrc Svimrc
iabbr lvimrc Lvimrc

" Strip whitespaces
nnoremap <leader>zz :StripWhitespace<cr>

"}}}
" Statusline                         {{{
function! ShortFilename()
  let _ = ''
  let name = expand('%')
  if empty(name)
    let _ .= '[No Name]'
  else
    let _ .= fnamemodify(name, ':p:h:t') . '/' . fnamemodify(name, ':t')
  endif
  return _
endfunction

function! StatusLineGit()
    let l:branchname = FugitiveHead()
    return strlen(branchname) > 0 ? '['.l:branchname.']' : ''
endfunction

function! LinterStatus()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let _ = ''

    if l:counts.total == 0
        let _ .= ''
    else
        let _ .= '[' . all_errors . 'E,' . all_non_errors . 'W]'
    endif
    return _
endfunction

let g:buftabline_numbers=1
let g:buftabline_indicators=1
" }}}
" Cscope                             {{{
if has("cscope")
    command! CscopeMake !find . -name '*.c' -o -name '*.cpp' -o -name '*.h' > cscope.files && cscope -b -i cscope.files
    command! CscopeLoad cs add cscope.out
    function! _TagsReload()
        exec "!rm cscope.files cscope.out"
        exec "CscopeMake"
        exec "cscope reset"
        exec "CtagsMake"
    endfunction
    command! TagsReload :call _TagsReload()
    nnoremap <leader>tr :silent TagsReload<cr>
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
    set cscopetag nocscopeverbose
endif

nnoremap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fd :cs find g <C-R>=expand("<cword>")<CR><CR>
command! CallTree :CCTreeTraceReverse
"}}}
" Ctags                              {{{
command! CtagsMake !ctags -R --extra=+f --exclude=.git .

noremap T <Esc>:tag<space>
" Move to next tag
noremap <C-[> <C-o>
" Open Tag in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" }}}
" TagList                            {{{
nnoremap <leader>to :TlistOpen<cr>
nnoremap <leader>tc :TlistClose<cr>
autocmd FileType taglist set norelativenumber
let Tlist_Auto_Highlight_Tag=1
let Tlist_Auto_Update=1
let Tlist_Display_Prototype=0
let Tlist_Enable_Fold_Column=0
let Tlist_Inc_Winwidth=1
let Tlist_Show_One_File=1
let Tlist_WinWidth=40
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1

" }}}
" FZF                                {{{
if has('nvim')
    let g:fzf_launcher = 'xterm -T fzf -fa monaco -fs 10 -e bash -ic %s'
endif
" New shortcuts for fzf
nnoremap <leader>fa :Ag<cr>
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fx :Commits<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fl :BLines<cr>
"nnoremap fa :Ag<cr>
" }}}
" Getting Things Done GTD            {{{
" Task Done, Up, Idle, Next, change Prio (do not use them directly, see iabbr)
nnoremap <leader>at a-<space><C-R>=strftime("%y%W%u")<CR><space>(A)
nnoremap <leader>bt a-<space><C-R>=strftime("%y%W%u")<CR><space>(B)
nnoremap <leader>ct a-<space><C-R>=strftime("%y%W%u")<CR><space>(C)
nnoremap <leader>td dd/^#.*Done<esc>p^a <C-R>=strftime("%y%W%u")<CR><esc>``
nnoremap <leader>tu dd?^#<cr>p<leader><space>``
nnoremap <leader>tl dd/^#.*Idle<esc>p^a <C-R>=strftime("%y%W%u")<CR><esc>``
nnoremap <leader>npa v$:s/([A-C])/(A)/g<CR><space><space>:nohlsearch<cr>
nnoremap <leader>npb v$:s/([A-C])/(B)/g<CR><space><space>:nohlsearch<cr>
nnoremap <leader>npc v$:s/([A-C])/(C)/g<CR><space><space>:nohlsearch<cr>
iabbr taska <esc><leader>at
iabbr taskb <esc><leader>bt
iabbr taskc <esc><leader>ct
cabbr sprj sort '+[a-zA-z]*' r
cabbr spri sort '([A-Z])' r
nnoremap <leader>nsj vip:sort '+[a-zA-z]*' r<cr>
nnoremap <leader>nsp vip:sort '([A-Z])' r<cr>
"}}}
" Git                                {{{
nnoremap <leader>gs   <esc>:Gstatus<cr>
nnoremap <leader>gl   <esc>:Glog<cr>
nnoremap <leader>ga   <esc>:Gwrite
nnoremap <leader>gc   <esc>:Gcommit<cr>
nnoremap <leader>gca  <esc>:Gcommit --amend<cr>
nnoremap <leader>gcan <esc>:Gcommit --amend --no-edit<cr>
nnoremap <leader>gph  <esc>:Gpush<cr>
nnoremap <leader>gpl  <esc>:Gpull<cr>

cabbr gerrit  !git push origin HEAD:refs/for/master

nnoremap <leader>gpr <esc>:Git push origin HEAD:refs/for/
" Shortcut for Fugitive vertical diff
nnoremap <leader>gd <esc>:Gvdiff<space>
" conflict resolution (to use with gvdiff, not mergetool)
nnoremap gdh :diffget //2
nnoremap gdl :diffget //3
" }}}
" Golang                             {{{
"au FileType go nmap <Leader>gdt <Plug>(go-def-tab)
au FileType go nmap <Leader>gdv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gi <Plug>(go-install)
au FileType go nmap <Leader>gI <Plug>(go-imports)
au FileType go nmap <Leader>fd <Plug>(go-def-split)
au FileType go nmap <Leader>gw <Plug>(go-doc-browser)
au FileType go nmap <leader>1 <Plug>(go-build)
"au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gt <Plug>(go-test)
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" }}}
" Jedi-vim                           {{{
let g:jedi#force_py_version=3
let g:jedi#completions_enabled = 1
let g:jedi#completions_command = "<C-c>"
let g:jedi#goto_command = "<space>fd"
let g:jedi#usages_command = "<space>fc"

" }}}
" Letsdo                             {{{

nnoremap <leader>ld :!lets do<space>
nnoremap <leader>ls :!lets stop<space>
nnoremap <leader>lv :!lets see<space>
nnoremap <leader>lc :!lets cancel<space>
nnoremap <leader>le :!lets edit<space>
" }}}
" Mark                               {{{
"vnoremap {Leader}/  n
"nnoremap <leader>n <Plug>Mark
" }}}
" Markdown                           {{{
autocmd FileType markdown set conceallevel=2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_toc_autofit = 1
let vim_markdown_preview_github=1
iabbr toc Toc
" }}}
" Syntastic                          {{{
let g:syntastic_always_populate_loc_list = 1                    "syntastic
let g:syntastic_auto_loc_list = 0                               "syntastic
let g:syntastic_check_on_open = 1                               "syntastic
let g:syntastic_check_on_wq = 0                                 "syntastic
let g:syntastic_c_checkers=['clang_check', 'cppcheck']
let g:syntastic_cpp_checkers=['clang_check', 'cppcheck']
let g:syntastic_python_checkers=['flake8']
" }}}
" Snippets                           {{{
augroup Shebang
  autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl># -*- coding: UTF-8 -*-\<nl>\"|$
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl># -*- coding: utf-8 -*-\<nl># vi: set ft=python :\<nl>\"|$
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: None -*-\<nl>\"|$
  autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
  autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
augroup END

source ~/.config/nvim/snippets/browser.config.vim
source ~/.config/nvim/snippets/c_cpp.config.vim
source ~/.config/nvim/snippets/canonical.config.vim
source ~/.config/nvim/snippets/golang.vim
source ~/.config/nvim/snippets/licenses.config.vim
source ~/.config/nvim/snippets/python.config.vim
source ~/.config/nvim/snippets/shell.config.vim
source ~/.config/nvim/snippets/other.vim

nnoremap <leader>1 :Make<cr>
iabbr editorconfig <esc>:-1 r~/.config/nvim/snippets/editorconfig/template.vim

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}
" Notes                              {{{
command! SpellEn    setlocal spell! spelllang=en
command! SpellIt    setlocal spell! spelllang=it
nnoremap <leader>d a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%y%W%u")<CR>
nnoremap <A-d> a<C-R>=strftime("%y%W%u")<CR><Esc>
let g:goyo_width=100
nnoremap <leader>snw :set nowrap<cr>
nnoremap <leader>sw :set wrap<cr>
autocmd FileType markdown,txt source ~/.config/nvim/snippets/markdown.vim
autocmd BufRead backlog set filetype=todo
iabbr isnt isn't
iabbr dont don't
iabbr doesnt doesn't
iabbr wasnt wasn't
iabbr didnt didn't
iabbr wont won't
" For Writers
augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END
hi clear SpellBad
hi clear SpellCap
hi SpellBad cterm=underline ctermfg=red
hi SpellCap ctermfg=blue
hi SpellBad gui=undercurl   guisp=red
hi SpellCap gui=undercurl   guisp=blue
" }}}
" Focus                              {{{
autocmd * set textwidth=0
" Make current window more obvious by turning off/adjusting some features in non-current
" windows.
if exists('+winhighlight')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
    autocmd FocusLost,WinLeave * set winhighlight=LineNr:ColorColumn,CursorLineNr:ColorColumn,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
    if exists('+colorcolumn')
        autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
    endif
elseif exists('+colorcolumn')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
    autocmd FocusLost,WinLeave * let &l:colorcolumn=join(range(1, 255), ',')
endif
"}}}

