#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# productive-time-deadline file contains the daily (usual) deadline time, e.g. 17:00, 5PM, etc.

[[ ! -f $HOME/.productive-time-deadline ]] && exit 0
[[ ! -f $HOME/.config/cconf/zsh/functions.zsh ]] && exit 1

source $HOME/.config/cconf/zsh/functions.zsh


time=$(cat $HOME/.productive-time-deadline)
left=$(date_in_seconds $time)
echo $left
if [[ $left -gt 0 ]]; then
    echo " ❪-$(humanizetime $left)❫ "
fi
