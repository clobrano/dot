#!/usr/bin/env bash
PACKAGE=$1
NAME=${2:-`basename ${PACKAGE}`}
URL=https://github.com/${PACKAGE}
DST=${HOME}/.dot/.config/nvim/pack/plugged/start/${NAME}
CMD="git submodule add --name ${NAME} ${URL} ${DST}"
echo ${CMD}
${CMD}
