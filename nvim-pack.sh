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
DST=.config/nvim/pack/plugged/${MODE}/${NAME}
if [[ -n "$_add" ]]; then
    CMD="git submodule add --name ${NAME} ${URL} ${DST}"
else if [[ -n "$_remove" ]]; then
    CMD="git submodule deinit ${DST} && \
        git rm -r ${DST} && \
        git -rf .git/modules/${NAME}"
fi
fi

echo "[WARNING] Execute the following command [press ENTER]?"
echo ${CMD}
read
${CMD}
echo done
