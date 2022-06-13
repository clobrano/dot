#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## helper script to track dotfiles for later backup
## dot will move the original dotfiles in a given directory for backup
## and replace it with a symlink.
## options:
##    -d, --deploy          Deploy dotfiles in HOME directory
##    -i, --install         Install programs and dependencies


# CLInt GENERATED_CODE: start
# info: https://github.com/clobrano/CLInt.git

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--deploy") set -- "$@" "-d";;
"--install") set -- "$@" "-i";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hdi' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        d) _deploy=1 ;;
        i) _install=1 ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# CLInt GENERATED_CODE: end

install() {
    pushd ${HOME}/.dot/.config/cconf/environments

    # install basic programs
    ./batch-install.sh req-base.txt
    ./github-cli-install.sh
    ./lsp/python-lsp.sh
    ./lsp/c-cpp.lsp.sh
    ./z-directory-jump.sh
    ./neovim-from-source.sh
    ./vim-plug-install.sh
    popd
}

deploy() {
    to_link=(
        ".bashrc"
        ".gitignore_global"
        ".inputrc"
        ".tigrc"
        ".tmux.conf"
        ".vimrc"
        ".zshrc"
        ".config/cconf"
        ".config/ranger"
        ".config/zathura"
        ".config/nvim/after"
        ".config/nvim/autoload"
        ".config/nvim/ginit.vim"
        ".config/nvim/init.vim"
        ".config/nvim/plugin"
        ".config/nvim/spell"
        ".config/nvim/thesaurus"
        ".config/nvim/UltiSnips"
    )

    # nvim directory needs to be created first
    mkdir -pv ${HOME}/.config/nvim

    SRC=$(pwd)
    for file in ${to_link[@]}; do
        echo ln -s ${SRC}/${file} ${HOME}/${file}
        ln -s ${SRC}/${file} ${HOME}/${file}
    done
}

[ ! -z $_install ] && install
[ ! -z $_deploy ] && deploy
