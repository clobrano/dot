#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## helper script to track dotfiles for later backup
## dot will move the original dotfiles in a given directory for backup
## and replace it with a symlink.

deploy() {
    to_link=(
        ".gitignore_global"
        ".inputrc"
        ".tmux.conf"
        ".vimrc"
        ".zshrc"
        ".config/cconf"
        ".config/ranger"
        ".config/zathura"
        ".config/espanso/match/base.yml"
        ".config/nvim/after"
        ".config/nvim/autoload"
        ".config/nvim/ginit.vim"
        ".config/nvim/init.vim"
        ".config/nvim/plugin"
        ".config/nvim/lua"
        ".config/nvim/spell"
        ".config/nvim/thesaurus"
    )

    # nvim directory needs to be created first
    mkdir -pv ${HOME}/.config/nvim

    SRC=$(pwd)
    
    for file in ${to_link[@]}; do
        if [[ -e ${HOME}/${file} ]]; then
            confirmed=false
            while ! $confirmed; do
                echo [+] ${HOME}/${file} exists, override [y/n]?
                read confirm
                case $confirm in
                    n|y)
                        confirmed=true
                        [[ $confirm == "n" ]] && continue
                        echo ln -fs ${SRC}/${file} ${HOME}/${file}
                        ln -fs ${SRC}/${file} ${HOME}/${file}
                        ;;
                    *)
                        echo [!] please write 'y' or 'n'
                        ;;
                esac
            done
        else
            echo ln -fs ${SRC}/${file} ${HOME}/${file}
            ln -fs ${SRC}/${file} ${HOME}/${file}
        fi
    done

    # source custom bash inside default .bashrc

    if `grep -ic "dot-bashrc" $HOME/.bashrc`; then
	echo "[+] bashrc already configured"
    else
	echo ". $HOME/.dot/dot-bashrc" >> $HOME/.bashrc
    fi
}

# -- main --
deploy
