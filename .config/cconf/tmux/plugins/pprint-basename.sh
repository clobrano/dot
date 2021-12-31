#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
PWD=$1
if [[ ${PWD} == ${HOME} ]]; then
    echo "~"
else
    echo `basename ${PWD}`
fi
