#!/usr/bin/env bash
## Helper script to ADD/REMOVE packages for Neovim package manager (packadd + git-submodule).
## options
##      -a, --add <package>      Add a package
##      -r, --remove <package>   Remove a package
##      -n, --name <name>        Rename the package
##      -o, --optional           Used when adding a module (--add), makes it optional [default: 0]

# CLInt GENERATED_CODE: start
# Default values
_optional=0

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--add") set -- "$@" "-a";;
"--remove") set -- "$@" "-r";;
"--name") set -- "$@" "-n";;
"--optional") set -- "$@" "-o";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hoa:r:n:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        o) _optional=1 ;;
        a) _add=$OPTARG ;;
        r) _remove=$OPTARG ;;
        n) _name=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# CLInt GENERATED_CODE: end

if [[ "$_optional" == "1" ]]; then
    MODE="opt"
else
    MODE="start"
fi

PACKAGE=${_add:-$_remove}
NAME=${_name:-`basename ${PACKAGE}`}
URL=https://github.com/${PACKAGE}

add_submodule() {
    # Add NVIM package as submodule.
    # MODE: opt/start -> either the package is optional or not
    # NAME: package name (e.g. nerdtree)
    pushd ${HOME}/.dot
    DST=.config/nvim/pack/plugged/${MODE}/${NAME}
    echo "[WARNING] adding ${URL} to ${DST} [press ENTER]?"
    read
    git submodule add --name ${NAME} ${URL} ${DST}
    popd
}

remove_submodule() {
    # Remove NVIM submodule package
    # NAME: package name (e.g. nerdtree)
    pushd ${HOME}/.dot

    # detect where the package is stored (start or opt folder)
    DST=$(find . -name ${NAME}| grep "pack" | grep "plugged")
    if [[ ! ${DST} ]]; then
        DST=$(find . -name ${NAME}| grep "pack" | grep "plugged")
        echo "[!] could not find package ${NAME}"
        popd
        return -1
    fi
    [[ "start" =~ DTS ]] && MODE="start"
    [[ "opt" =~ DTS ]] && MODE="opt"

    DST=.config/nvim/pack/plugged/${MODE}/${NAME}
    echo "[WARNING] removing ${DST} [press ENTER]?"
    read
    git submodule deinit ${DST} \
        && git rm -r ${DST} \
        && rm -rf .git/modules/${NAME}
    popd
}

[[ -n "$_add" ]] && add_submodule
[[ -n "$_remove" ]] && remove_submodule
