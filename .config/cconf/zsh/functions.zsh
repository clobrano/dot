function preexec() {
    # Save the name of the command and the time when it starts
    CMD_NAME=$1
    CMD_START_TIME=$(date +%s)
}

function precmd() {
    if [[ -z $CMD_START_TIME ]]; then
        return
    fi

    CMD_STOP_TIME=$(date +%s)
    CMD_ELAPSED_TIME=$(($CMD_STOP_TIME - $CMD_START_TIME))
    THRESHOLD=60
    if [[ $CMD_ELAPSED_TIME -gt $THRESHOLD ]]; then
        notify-send -i time 'job finished' "$CMD_NAME"
    fi
}