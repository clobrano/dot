set runtimepath^=~/.config/nvim
set runtimepath+=~/.config/nvim/after
let &packpath=&runtimepath
let mapleader = ' '

source ~/.config/nvim/init.vim
nnoremap <leader>ff :FZF!<cr>
set guifont=SauceCodePro\ Nerd\ Font\ Medium\ 14
