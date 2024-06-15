let g:mapleader=' '
set nocompatible
filetype plugin indent on
syntax on

set path=**
set incsearch
set hlsearch
set ignorecase
set smartcase
set lazyredraw
set number
set relativenumber
set mouse = "a"

inoremap jj <esc>
nnoremap ss :w<cr>
nnoremap qa :qa<cr>
nnoremap <leader><space> :nohlsearch<cr>
nnoremap <leader>ff :find *

nnoremap <L> :bn<cr>
nnoremap <H> :bp<cr>
inoremap <C-s> :write<cr>
nnoremap <C-s> :write<cr> 
