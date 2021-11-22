#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## helper script to track dotfiles for later backup
## dot will move the original dotfiles in a given directory for backup
## and replace it with a symlink.
## options:
##    -d, --deploy          Deploy dotfiles in HOME directory
##    -a, --add <path>      Add <path> to dotfiles
##    -r, --remove <path>   Remove <path> from dotfiles


# CLInt GENERATED_CODE: start

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--deploy") set -- "$@" "-d";;
"--add") set -- "$@" "-a";;
"--remove") set -- "$@" "-r";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hda:r:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        d) _deploy=1 ;;
        a) _add=$OPTARG ;;
        r) _remove=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# CLInt GENERATED_CODE: end

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

if [ ${_deploy} == 1 ]; then
    SRC=$(pwd)
    for file in ${to_link[@]}; do
        echo ln -sf ${SRC}/${file} ${HOME}/${file}
        ln -sf ${SRC}/${file} ${HOME}/${file}
    done
fi

# install vim-plug
${HOME}/.dot/.config/cconf/requirements/vim-plug-install.sh
