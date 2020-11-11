let mapleader = ' '
let maplocalleader=' '


inoremap jj <esc>
nnoremap <L> :bn<cr>
nnoremap <H> :bp<cr>
inoremap <C-s> :write<cr>
nnoremap <C-s> :write<cr>

" VimPlug configuration              {{{
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source ~/.vim/init.vim
endif

call plug#begin()

Plug 'dracula/vim'
Plug 'ap/vim-buftabline'
Plug 'clobrano-forks/onehalf', {'rtp': 'vim/'}
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf',                     { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'szw/vim-g' " Quick Google lookup
Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'  " <leader>gm to show line's commit message

call plug#end()
set nocompatible
syntax enable
filetype on


colorscheme dracula
