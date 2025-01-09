#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
interval_time_min=2
current_time_min=$(date +%M)
if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    $HOME/workspace/script-fu/taskwarrior-update-stats.sh
    cat /home/clobrano/.taskwarrior-stats
fi

reminder_interval_time_min=10
if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    $HOME/workspace/script-fu/taskwarrior-reminder.sh
fi
