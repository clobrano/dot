set runtimepath^=~/.config/nvim runtimepath+=~/.confi/nvim/after
let &packpath=&runtimepath
let mapleader = ' '
source ~/.config/nvim/init.vim
nnoremap <leader>ff :FZF!<cr>
