"
"  _   _ _____ ___        _
" | \ | | ____/ _ \__   _(_)_ __ ___
" |  \| |  _|| | | \ \ / / | '_ ` _ \
" | |\  | |__| |_| |\ V /| | | | | | |
" |_| \_|_____\___/  \_/ |_|_| |_| |_|
"
"                   __ _                       _   _                __ _ _
"   ___ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __    / _(_) | ___
"  / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \  | |_| | |/ _ \
" | (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | | |  _| | |  __/
"  \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_| |_| |_|_|\___|
"                        |___/

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
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
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
Plug 'tpope/vim-abolish'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
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
Plug 'tpope/vim-repeat'
"}}}
" Generics                           {{{
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'janko/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'           " testing 2019-05-16
Plug 'vim-scripts/marvim' " give a name to macros
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'francoiscabrol/ranger.vim'
"}}}
let g:deoplete#enable_at_startup = 1
call plug#end()
set nocompatible
syntax enable
filetype on
"}}}

source ~/.config/nvim/clobrano/settings.vim
source ~/.config/nvim/clobrano/mappings.vim
source ~/.config/nvim/clobrano/autocommands.vim
source ~/.config/nvim/clobrano/abbreviations.vim
source ~/.config/nvim/clobrano/functions.vim


" Focus                              {{{
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

" editorconfig                       {{{
iabbr editorconfig <esc>:-1 r~/.config/nvim/snippets/editorconfig/template.vim
"}}}

" buftabline                         {{{
let g:buftabline_numbers=1
let g:buftabline_indicators=1
" }}}

" Cscope                             {{{
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

nnoremap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fd :cs find g <C-R>=expand("<cword>")<CR><CR>
command! CallTree :CCTreeTraceReverse
"}}}

" Ctags                              {{{
if executable("ctags")
    noremap T <Esc>:tag<space>
    " Move to next tag
    noremap <C-[> <C-o>
    " Open Tag in vertical split
    map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

    command! CtagsMake !ctags -R --extra=+f --exclude=.git .
    endif
" }}}

" Custom Snippets                    {{{
source ~/.config/nvim/snippets/browser.config.vim
source ~/.config/nvim/snippets/c_cpp.config.vim
source ~/.config/nvim/snippets/canonical.config.vim
source ~/.config/nvim/snippets/golang.vim
source ~/.config/nvim/snippets/licenses.config.vim
source ~/.config/nvim/snippets/python.config.vim
source ~/.config/nvim/snippets/shell.config.vim
source ~/.config/nvim/snippets/cisco.vim
"}}}

" Easy Align                         {{{
xmap <leader>ea  <Plug>(EasyAlign)
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
"}}}

" FZF                                {{{
if executable('fzf')
    if has('nvim')
        let g:fzf_launcher = 'xterm -T fzf -fa monaco -fs 10 -e bash -ic %s'
    endif

    nnoremap <leader>fa :Ag<cr>
    nnoremap <leader>fb :Buffers<cr>
    nnoremap <leader>ff :Files<cr>
    nnoremap <leader>fl :BLines<cr>
    nnoremap <leader>ft :Tags<cr>
    nnoremap <leader>fx :Commits<cr>
endif
" }}}

" Getting Things Done GTD            {{{

" Sort items by project
nnoremap <leader>nsj vip:sort '+[a-zA-z]*' r<cr>
" Sort items by priority
nnoremap <leader>nsp vip:sort '([A-Z])' r<cr>

" Change priority to A
nnoremap <leader>npa v$:s/([A-D])/(A)/g<CR><space><space>:nohlsearch<cr>
" Change priority to B
nnoremap <leader>npb v$:s/([A-D])/(B)/g<CR><space><space>:nohlsearch<cr>
" Change priority to C
nnoremap <leader>npc v$:s/([A-D])/(C)/g<CR><space><space>:nohlsearch<cr>
" Change priority to D
nnoremap <leader>npc v$:s/([A-D])/(D)/g<CR><space><space>:nohlsearch<cr>

" Move task UP in the same list
nnoremap <leader>tu dd?^#<cr>p<leader><space>``
" Move task to Done list
nnoremap <leader>td dd/^#.*Done<esc>p^a <C-R>=strftime("%y%W%u")<CR><esc>``
" MOve task to Idle list
nnoremap <leader>tl dd/^#.*Idle<esc>p^a <C-R>=strftime("%y%W%u")<CR><esc>``
"}}}

" Git                                {{{
nnoremap <leader>ga   <esc>:Gwrite
nnoremap <leader>gc   <esc>:Gcommit<cr>
nnoremap <leader>gca  <esc>:Gcommit --amend<cr>
nnoremap <leader>gcan <esc>:Gcommit --amend --no-edit<cr>
nnoremap <leader>gl   <esc>:Glog<cr>
nnoremap <leader>gph  <esc>:Gpush<cr>
nnoremap <leader>gpl  <esc>:Gpull<cr>
nnoremap <leader>gs   <esc>:Gstatus<cr>

" Fugitive vertical diff
nnoremap <leader>gd <esc>:Gvdiff<space>
" Gvdiff get from left split
nnoremap gdh :diffget //2
" Gvdiff get from right split
nnoremap gdl :diffget //3

" Push to gerrit review
cabbr gerrit  !git push origin HEAD:refs/for/master
" }}}

" Golang                             {{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

" Go build same shortcut as make (what if makeprg=go\ build ?)
au FileType go nmap <leader>1 <Plug>(go-build)
" Go def split, same shortcut as got to definition tag in C
au FileType go nmap <A-]> <Plug>(go-def-vertical)

au FileType go nmap <Leader>gI <Plug>(go-imports)
au FileType go nmap <Leader>gi <Plug>(go-install)
au FileType go nmap <Leader>gw <Plug>(go-doc-browser)
au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gt <Plug>(go-test)
" }}}

" Jedi-vim                           {{{
let g:jedi#force_py_version=3
let g:jedi#completions_enabled = 1
let g:jedi#completions_command = "<C-c>"
let g:jedi#goto_command = "<space>fd"
let g:jedi#usages_command = "<space>fc"
" }}}

" Look&Feel                          {{{
try
    echo g:colors_name
catch
    exe "colorscheme monokai"
    exe "set background=dark"
endtry

if &background ==# "dark"
    exe "highlight Search gui=bold guibg=NONE guifg=orange"
    exe "highlight Search cterm=bold ctermbg=NONE ctermfg=214"
    exe "highlight MatchParen gui=bold guibg=NONE guifg=magenta"
endif

command! PaperColor :colorscheme PaperColor | set background:light


if &background ==# "dark"
    let g:solarized_contrast = "high"
    let g:solarized_visibility = "high"
else
    let g:solarized_contrast = "normal"
    let g:solarized_visibility = "normal"
endif

" }}}

" Mark                               {{{
"vnoremap {Leader}/  n
"nnoremap <leader>n <Plug>Mark
" }}}

" Markdown                           {{{
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_toc_autofit = 1
let vim_markdown_preview_github=1
autocmd FileType markdown set conceallevel=2
cabbr toc Toc
cabbr toch Toch
" }}}

" netrw                              {{{
let g:netrw_banner=0
let g:netrw_liststyle = 3             " treetest-view
let g:netrw_list_hide= netrw_gitignore#Hide().'.*\.swp$'
let g:netrw_hide = 1
let g:netrw_preview = 0
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_winsize = -28             " absolute width of netrw window
" }}}

" Notes                              {{{
let g:goyo_width=100

nnoremap <leader>d a#<space><C-R>=strftime("%Y-%m-%d")<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
inoremap <A-d> <C-R>=strftime("%y%W%u")<CR>
nnoremap <A-d> a<C-R>=strftime("%y%W%u")<CR><Esc>
nnoremap <leader>snw :set nowrap<cr>
nnoremap <leader>sw :set wrap<cr>

autocmd FileType markdown,txt source ~/.config/nvim/snippets/markdown.vim
autocmd BufRead backlog set filetype=todo

command! SpellEn    setlocal spell! spelllang=en
command! SpellIt    setlocal spell! spelllang=it
"}}}

" ntpeters/vim-better-whitespace     {{{
nnoremap <leader>zz :StripWhitespace<cr>
"}}}

" Syntastic                          {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers=['clang_check', 'cppcheck']
let g:syntastic_cpp_checkers=['clang_check', 'cppcheck']
let g:syntastic_python_checkers=['flake8']
" }}}

" TagList                            {{{
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

nnoremap <leader>to :TlistOpen<cr>
nnoremap <leader>tc :TlistClose<cr>

autocmd FileType taglist set norelativenumber
" }}}

" ultisnips                          {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsEditSplit="vertical"  " If you want :UltiSnipsEdit to split your window.
" }}}

" vim-dispatch                       {{{
nnoremap <leader>1 :Make<cr>
"}}}

" vimrclocal                    {{{
if filereadable(expand('vimrc.local'))
    exe 'source vimrc.local'
endif
command! Svimrc :!cat vimrc.local
command! Evimrc :e vimrc.local
command! Lvimrc :exe 'source vimrc.local'
iabbr evimrc Evimrc
iabbr svimrc Svimrc
iabbr lvimrc Lvimrc
"}}}

" Writers                        {{{
augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  "autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END
hi clear SpellBad
hi clear SpellCap
hi SpellBad cterm=underline ctermfg=red
hi SpellCap ctermfg=blue
hi SpellBad gui=undercurl   guisp=red
hi SpellCap gui=undercurl   guisp=blue
" }}}
