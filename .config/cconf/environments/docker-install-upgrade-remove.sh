#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Convenience script to install, update and remove Docker
## options
##     -i, --install
##     -s, --setup
##     -r, --remove

# CLInt GENERATED_CODE: start
# info: https://github.com/clobrano/CLInt.git

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--install") set -- "$@" "-i";;
"--setup") set -- "$@" "-s";;
"--remove") set -- "$@" "-r";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hisr' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _install=1 ;;
        s) _setup=1 ;;
        r) _remove=1 ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# CLInt GENERATED_CODE: end

install () {
    # install using the "convenience script"
    curl -fsSL https://get.docker.com -o get-docker.sh
    chmod u+x ./get-docker.sh
    ./get-docker.sh
    rootless
}

rootless () {
    sudo systemctl enable docker
    sudo usermod -G docker -a $USER
    newgrp docker
    sudo systemctl restart docker
    docker version
    docker run --rm hello-world
}

remove () {
    echo remove
    return
    sudo dnf remove docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
}

[[ $_install ]] && install
[[ $_setup ]] && rootless
[[ $_remove ]] && remove
