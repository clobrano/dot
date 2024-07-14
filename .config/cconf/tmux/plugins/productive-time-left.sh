#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# productive-time-deadline file contains the daily (usual) deadline time, e.g. 17:00, 5PM, etc.

[[ ! -f $HOME/.productive-time-deadline ]] && exit 0
[[ ! -f $HOME/.config/cconf/zsh/functions.zsh ]] && exit 1

source $HOME/.config/cconf/zsh/functions.zsh

started=$(cat $HOME/.productive-time-started)
deadline=$(cat $HOME/.productive-time-deadline)
left=$(time_left_in_seconds $deadline)
since=$(time_since_in_seconds $started)
# drop seconds from the output
s=$(humanizetime $since)
l=$(humanizetime $left)
if [[ $left -gt 0 ]] && [[ $since -gt 0 ]]; then
    echo "   ▲${s%'.'*} ▼${l%'.'*}"
elif [[ $since -gt 0 ]]; then
    echo "   ▲${s%'.'*} ◆$deadline"
elif [[ $left -gt 0 ]]; then
    echo "   ▼${l%'.'*}"
fi
