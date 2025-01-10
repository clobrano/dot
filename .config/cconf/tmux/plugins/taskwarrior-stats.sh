#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
interval_time_min=5
current_time_min=$(date +%M)
if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    "$HOME"/workspace/script-fu/taskwarrior-update-stats.sh
fi
# sometimes updating taskwarrior stats fails. Avoid presenting
# partial information on tmux output
if ! grep "?" "$HOME"/.taskwarrior-stats >/dev/null; then
    cat "$HOME"/.taskwarrior-stats
fi


reminder_interval_time_min=10
if [ $((current_time_min % reminder_interval_time_min)) -eq 0 ]; then
    "$HOME"/workspace/script-fu/taskwarrior-reminder.sh
fi
