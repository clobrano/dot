#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#sudo apt-get install dconf-cli
## options
## -g, --gnome      Install Dracula for gnome-terminal
## -k, --konsole    Install Dracula for Konsole


# CLInt GENERATED_CODE: start
# info: https://github.com/clobrano/CLInt.git

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--gnome") set -- "$@" "-g";;
"--konsole") set -- "$@" "-k";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hgk' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        g) _gnome=1 ;;
        k) _konsole=1 ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# CLInt GENERATED_CODE: end

if [[ -n $_gnome ]]; then
    if command -v gnome-terminal; then
        git clone https://github.com/dracula/gnome-terminal ~/workspace/toolkit/dracula-gnome-terminal
        pushd ~/workspace/toolkit/dracula-gnome-terminal
        ./install.sh
        popd
    fi
fi

if [[ -n $_konsole ]]; then
    if command -v konsole; then
        wget https://github.com/dracula/konsole/archive/master.zip
        unzip master.zip
        cp konsole-master/Dracula.colorscheme ~/.local/share/konsole/
        cat <<EOF
        Now go to Konsole > Settings > Edit Current Profile… > Appearance tab
        Select the Dracula scheme from the Color Schemes & Background… pane
EOF
        rm -r konsole-master master.zip
    fi
fi
