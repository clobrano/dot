set runtimepath^=~/.config/nvim/
set runtimepath+=~/.config/nvim/plugins
set runtimepath+=~/.config/nvim/snippets
set runtimepath+=~/.config/nvim/spell
set runtimepath+=~/.config/nvim/thesaurus
let &packpath=&runtimepath
let mapleader = ' '

source ~/.config/nvim/init.vim
nnoremap <leader>ff :FZF!<cr>
set guifont=SauceCodePro\ Nerd\ Font\ Medium\ 12
