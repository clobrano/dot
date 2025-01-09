#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Read current Letsdo task title and time, and show it in TMUX status bar.
## Notify when working on the same task for more than 45 minutes straight.

shopt -s extglob  # bash only

clean_warning_file() {
    rm ${WARNING_FILE}
}

YAML_CONFIG=$HOME/.letsdo.yaml
if [[ ! -f ${YAML_CONFIG} ]]; then
    exit 0
fi

YQ=`which yq`
if ! command -v $YQ >/dev/null; then
    echo "config error: yq is missing. Please install it."
    exit 1
fi

DATA_DIRECTORY=$($YQ -r ".data_directory" ${YAML_CONFIG})
if [[ -z ${DATA_DIRECTORY} ]]; then
    echo "config error: could not find data_directory from ${YAML_CONFIG}"
    exit 1
fi

WARNING_FILE=${HOME}/.letsdo-warning-file
if [ ! -f  "${DATA_DIRECTORY}/letsdo-task" ]; then
    # no running tasks
    dconf write /org/gnome/shell/extensions/one-thing/thing-value "''"
    exit 0
fi

full_name=$(sed -n 's_"name": "\(.*\)",_\1_p' "$DATA_DIRECTORY/letsdo-task")
full_name=${full_name##+([[:space:]])}    # strip leading whitespace;  no quote expansion!
full_name=${full_name%%+([[:space:]])}   # strip trailing whitespace; no quote expansion!
# Sanitize task name
full_name=$(echo "$full_name" | tr -d '"'\''')

begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")


end=$(date +%s)

# TODO: Why I need an 1h offset to get the right value? Is it for the daylight setting?
elapsed_time=$(date +"%H:%M.%S" --date="@$(($end - $begin - 3600))")
echo " $full_name $elapsed_time"

# Short name for OneThing Gnome extention
#name=$full_name
#task_len=${#full_name}
#if [[ $task_len > 40 ]]; then
    #name=${full_name:0:27}...
#fi
#dconf write /org/gnome/shell/extensions/one-thing/thing-value "'  $name $elapsed_time'"

# Reminder of time spent on the same task
warn_time_minutes=15
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
    if [[ -f ${WARNING_FILE} ]]; then
        # if it is not the same task, delete the file
        task_warned=$(cat ${WARNING_FILE})
        if [[ "${task_warned}" != "${full_name}" ]]; then
            echo "[+] the warning comes from another task"
            clean_warning_file
        else
            # if it is older than 60 seconds, delete the file
            now_seconds_since_epoc=$(date +%s)
            file_birth_date_seconds_since_epoc=$(stat $HISTORY --printf=%W)
            t=$(($now_seconds_since_epoc - $file_birth_date_seconds_since_epoc))
            if [[ "$t" -gt 60 ]]; then
                echo "[+] the warning is old"
                clean_warning_file
            fi
        fi 
    fi

    # all checks passed, we can send the notification
    echo $full_name > ${WARNING_FILE}
    notify-send --app-name "Tmux|Letsdo" "$elapsed_time on - $full_name -"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
else
    clean_warning_file
fi



