function date_in_seconds() {
    DEADLINE=$1 # e.g. 17:00 for today's 5pm

    deadline_full=$(date -d $DEADLINE +%s)
    now=$(date +%s)
    time_left=$(($deadline_full - $now))
    if [[ $time_left -gt 0 ]]; then
        echo $time_left
    fi
}

function humanizetime() {
    ELAPSED_TIME=$1
    MINUTE=60
    HOUR=3600

    hours=0
    minutes=0
    seconds=0

    if [[ $ELAPSED_TIME -ge $HOUR ]]; then
        hours=$(($ELAPSED_TIME / $HOUR))
        ELAPSED_TIME=$(($ELAPSED_TIME % $HOUR))
    fi

    if [[ $ELAPSED_TIME -ge $MINUTE ]]; then
        minutes=$(($ELAPSED_TIME / $MINUTE))
        ELAPSED_TIME=$(($ELAPSED_TIME % $MINUTE))
    fi

    seconds=$ELAPSED_TIME
    printf "%sh:%02sm" ${hours} ${minutes}
}

function precmd() {
    # update vcs_info at each prompt update
    vcs_info

    if [[ -z $CMD_START_TIME ]]; then
        return
    fi

    CMD_STOP_TIME=$(date +%s)
    CMD_ELAPSED_TIME=$(($CMD_STOP_TIME - $CMD_START_TIME))
    THRESHOLD=60
    if [[ $CMD_ELAPSED_TIME -gt $THRESHOLD ]]; then
        notify-send -i time "job finished after $(humanizetime $CMD_ELAPSED_TIME)" "$CMD_NAME"
    fi
    unset CMD_START_TIME
    unset CMD_STOP_TIME
    unset CMD_ELAPSED_TIME
}


function preexec() {
    # Save the name of the command and the time when it starts
    CMD_NAME=$1
    unset CMD_START_TIME

    WHITELIST="dw dmesg tig fzf fn f nvim ndm nd n vim vng vg v gvim taskell tsk msk mocp"
    for i in $(echo $WHITELIST); do
        if [[ "$CMD_NAME" =~ "$i" ]]; then
            return
        fi
    done

    CMD_START_TIME=$(date +%s)
}
