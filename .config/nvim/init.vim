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

"
" global
"

" Shortcut to full configuration
" ~/.config/nvim/
source ~/.config/nvim/clobrano/settings.vim
source ~/.config/nvim/clobrano/mappings.vim
source ~/.config/nvim/clobrano/autocommands.vim
source ~/.config/nvim/clobrano/abbreviations.vim
source ~/.config/nvim/clobrano/functions.vim


" Custom Snippets {{{
source ~/.config/nvim/snippets/browser.config.vim
source ~/.config/nvim/snippets/c_cpp.config.vim
source ~/.config/nvim/snippets/canonical.config.vim
source ~/.config/nvim/snippets/golang.vim
source ~/.config/nvim/snippets/licenses.config.vim
source ~/.config/nvim/snippets/python.config.vim
source ~/.config/nvim/snippets/shell.config.vim
source ~/.config/nvim/snippets/cisco.vim
"}}}

" Gerrit review {{{
cabbr gerrit  !git push origin HEAD:refs/for/master
" }}}

" Look&Feel {{{
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

" Markdown {{{
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_toc_autofit = 1
let vim_markdown_preview_github=1
autocmd FileType markdown set conceallevel=2
cabbr toc Toc
cabbr toch Toch
" }}}

" Notes {{{
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

" Writers {{{
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


" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" this shall have a better place than this
if g:colors_name == 'monokai'
    exe "hi statusline ctermbg=251"
    exe "hi comment ctermfg=244"
endif
