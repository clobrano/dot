#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# This script is a container for utilities that needs to be run
# at a given interval.

# GH unread notifications
#interval_time_min=15
#current_time_min=$(date +%M)
#if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    #"$HOME/workspace/script-fu/gh-pr-notifier.sh"
#fi


## ccusage stats view
interval_time_min=10
current_time_min=$((10#$(date +%M)))
ccusage_bin="$HOME/.npm-global/bin/ccusage"
if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    MONTHLY_VIEW=$("$ccusage_bin" monthly --last 1 --json | jq '(.totals.totalCost | . * 100 | round / 100)')
    DAILY_VIEW=$("$ccusage_bin" daily --last 1 --json | jq '(.totals.totalCost | . * 100 | round / 100)')
    MONTHLY_BUDGET=300
    MONTHLY_VIEW_INT=$(echo "${MONTHLY_VIEW}" | cut -d "." -f1)
    PERC=$((MONTHLY_VIEW_INT*100 / MONTHLY_BUDGET))
    echo "\$${DAILY_VIEW} \$${MONTHLY_VIEW} %${PERC}" > "$HOME/.ccusage.txt"
fi

## Taskwarrior stats view
interval_time_min=10
current_time_min=$((10#$(date +%M)))
if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    "$HOME/workspace/script-fu/taskwarrior-update-stats.sh"
fi
# sometimes updating taskwarrior stats fails. Avoid presenting
# partial information on tmux output
if ! grep "?" "$HOME"/.taskwarrior-stats >/dev/null; then
    cat "$HOME"/.taskwarrior-stats
fi

## Taskwarrior reminder
reminder_interval_time_min=10
current_reminder_lock="$HOME/.taskwarrior-reminder-$current_time_min"
if [ $((current_time_min % reminder_interval_time_min)) -eq 0 ]; then
    if [ ! -f "$current_reminder_lock" ]; then
        touch "$current_reminder_lock"
        "$HOME/workspace/script-fu/taskwarrior-reminder.sh"
    fi
fi

# TODO: replace with find -exec
for oldreminders_lock in $(find "$HOME" -maxdepth 1 -name ".taskwarrior-reminder-*"); do
    if [ "$oldreminders_lock" != "$current_reminder_lock" ]; then
        rm "$oldreminders_lock"
    fi
done


## Calcurse agenda reminder - there is no such thing anymore
#reminder_interval_time_min=10
#current_reminder_lock="$HOME/.calcurse-reminder-$current_time_min"
#if [ $((current_time_min % reminder_interval_time_min)) -eq 0 ]; then
    #if [ ! -f "$current_reminder_lock" ]; then
        #touch "$current_reminder_lock"
        #"/home/clobrano/Apps/Quick/calcurse-reminder.sh"
    #fi
#fi

# TODO: replace with find -exec
for oldreminders_lock in $(find "$HOME" -maxdepth 1 -name ".calcurse-reminder-*"); do
    if [ "$oldreminders_lock" != "$current_reminder_lock" ]; then
        rm "$oldreminders_lock"
    fi
done

