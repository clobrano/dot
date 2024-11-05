#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
if ! tmux attach-session -t "1st"  2>&1 >/dev/null; then
    tmux new -s "1st"
fi
