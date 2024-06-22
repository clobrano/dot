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
# Sanitize task name
name=$(echo "$name" | tr -d '"'\''')

begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")

task_len=${#name}
if [[ $task_len > 40 ]]; then
    name=${name:0:27}...
fi
end=$(date +%s)

# Warn if speding "too much time" on the same task
set -x
warn_time_minutes=45  # 45 minutes limit
work_time_seconds=$(($end - $begin))
work_time_minutes=$(($work_time_seconds / 60))
if [[ $work_time_minutes -gt 0 ]] && [[ $(($work_time_minutes % $warn_time_minutes)) -eq 0 ]]; then
    # do not repeat the same notification twice.
    # This might happen during 60 seconds after the condition above holds true.
    # To keep into account all conditions, we use a file containing the name of the
    # task for which the warning was sent.
    # - if the task name in the file is different, ignore it and delete
    # - if the file is older than 60 seconds, ignore it and delete it (this might only
    #   happen in "the next" occurrence of the condition above. Yeah I know it's tricky.)
    if [[ -f $HOME/.letsdo-warning-sent ]]; then
        # if it is not the same task, delete the file
        task_warned=$(cat $HOME/.letsdo-warning-sent)
        if [[ "$task_warned" != "$name" ]]; then
            echo "[+] the warning comes from another task"
            rm $HOME/.letsdo-warning-sent
        else
            # if it is older than 60 seconds, delete the file
            now_seconds_since_epoc=$(date +%s)
            file_birth_date_seconds_since_epoc=$(stat $HISTORY --printf=%W)
            t=$(($now_seconds_since_epoc - $file_birth_date_seconds_since_epoc))
            if [[ "$t" -gt 60 ]]; then
                echo "[+] the warning is old"
                rm $HOME/.letsdo-warning-sent
            fi
        fi 
    fi

    # all checks passed, we can send the notification
    echo $name > $HOME/.letsdo-warning-sent
    notify-send "working on the same task for some time already"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
else
    rm $HOME/.letsdo-warning-sent
fi

# TODO: Why I need an 1h offset to get the right value? Is it for the daylight setting?
elapsed_time=$(date +"%H:%M.%S" --date="@$(($end - $begin - 3600))")
dconf write /org/gnome/shell/extensions/one-thing/thing-value "'$name $elapsed_time'"
echo "󰔛 $name $elapsed_time"

