function preexec() {
    # Save the name of the command and the time when it starts
    CMD_NAME=$1
    unset CMD_START_TIME

    # it seems that short name like "n" do not work in zsh, while this
    # function works fine tested in bash, try to avoid them, e.g. use nvim
    WHITELIST="tig fzf fn f nvim ndm nd n vim vng vg v gvim"
    if [[ $WHITELIST =~ (^|[[:space:]])$CMD_NAME($|[[:space:]]) ]]; then
        return
    fi

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
        notify-send -i time 'job finished' "$CMD_NAME: $CMD_ELAPSED_TIME seconds"
    fi
    unset CMD_START_TIME
    unset CMD_STOP_TIME
    unset CMD_ELAPSED_TIME
}
