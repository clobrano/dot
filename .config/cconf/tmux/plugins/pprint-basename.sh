#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
PWD=$1
if [[ ${PWD} == ${HOME} ]]; then
    echo "~"
else
    parent=$(dirname ${PWD})
    current=$(basename ${PWD})
    if [[ $parent != ${HOME} ]]; then
        echo $(basename "$parent")/"$current"
    else
        echo "$current"
    fi
fi
