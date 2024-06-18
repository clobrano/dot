#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Read current Letsdo task title and time, and show it in TMUX status bar.
## Notify when working on the same task for more than 45 minutes straight.

shopt -s extglob  # bash only

# No Letsdo configuration
[ ! -f $HOME/.letsdo ] && exit 0


DATA_DIRECTORY=$(sed -n 's/DATA_DIRECTORY:\s*\(.*\)/\1/p' "$HOME/.letsdo")

# no running tasks
if [ ! -f  "$DATA_DIRECTORY/letsdo-task" ]; then
    echo ""
    dconf write /org/gnome/shell/extensions/one-thing/thing-value "''"
    exit 0
fi

name=$(sed -n 's_"name": "\(.*\)",_\1_p' "$DATA_DIRECTORY/letsdo-task")
name=${name##+([[:space:]])}    # strip leading whitespace;  no quote expansion!
name=${name%%+([[:space:]])}   # strip trailing whitespace; no quote expansion!

# Warn if speding "too much time" on the same task
if [[ ! -f $HOME/.letsdo-warning-sent ]]; then
    set -x
    warn_time_minutes=45  # 45 minutes limit
    work_time_seconds=$(($end - $begin))
    work_time_minutes=$(($work_time_seconds / 60))
    if [[ $(($work_time_minutes % $warn_time_minutes)) -eq 0 ]]; then
        notify-send "working on the same task for some time already"
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga
        echo $name > $HOME/.letsdo-warning-sent
    fi
else
    task_warned=$(cat $HOME/.letsdo-warning-sent)
    if [[ "$task_warned" != "$name" ]]; then
        rm $HOME/.letsdo-warning-sent
    fi
fi

begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")

task_len=${#name}
if [[ $task_len > 40 ]]; then
    name=${name:0:27}...
fi
end=$(date +%s)

# TODO: Why I need an 1h offset to get the right value? Is it for the daylight setting?
elapsed_time=$(date +"%H:%M.%S" --date="@$(($end - $begin - 3600))")
dconf write /org/gnome/shell/extensions/one-thing/thing-value "'$name $elapsed_time'"
echo "󰔛 $name $elapsed_time"

