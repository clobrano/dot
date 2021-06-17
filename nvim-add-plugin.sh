#!/usr/bin/env bash
MODE=$1
if [[ ${MODE} != "start" ]] && [[ ${MODE} != "opt" ]]; then
    echo "[!] MODE must be [start|opt], it was '${MODE}'"
    exit
fi
PACKAGE=$2
NAME=${3:-`basename ${PACKAGE}`}
URL=https://github.com/${PACKAGE}
DST=.config/nvim/pack/plugged/${MODE}/${NAME}
CMD="git submodule add --name ${NAME} ${URL} ${DST}"
echo ${CMD}
${CMD}
