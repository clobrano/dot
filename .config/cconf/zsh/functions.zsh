function auto_venv() {
    # automatically activate python virtualenv

    if [ -n "$VIRTUAL_ENV" ]; then
        # already in virtualenv
        return
    fi

   declare -a VENV_DIRS
    VENV_DIRS=(.venv venv env)
    for d in ${VENV_DIRS[@]}; do
        if [ -d $d ]; then
            source $d/bin/activate
            return
        fi
    done
}

function fzf_git_branches() {
    if ! is_in_git_repo; then
        echo "[!] not a git repository"
        return
    fi
    if ! command -v fzf 2>/dev/null; then
        echo "[!] fzf is not installed"
        return
    fi
    if ! command -v git 2>/dev/null; then
        echo "[!] git is not installed"
        return
    fi
    git checkout $(git branch -a | fzf)
}

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function switch_go_version() {
    GO_MOD_FILE="$(pwd)/go.mod"
    if [ ! -f $GO_MOD_FILE ]; then
        return
    fi
    GOMOD_VERSION=$(grep -E "go [[:digit:]]\.[[:digit:]][[:digit:]]" $GO_MOD_FILE | awk '{print $2}')
    # go.mod only supports major.minor versions, adding ".x" at the end to instruct Gimme to get the latest patch version
    GOMOD_VERSION+=".x"
    [[ -z $GOMOD_VERSION ]] && eval $(gimme stable) && return

    GO_VERSION=`go version | awk '{print $3}'`
    if [[ "go$GOMOD_VERSION" != $GO_VERSION ]]; then
        if [[ $GOMOD_VERSION = "1.17" ]]; then
            echo "[!] Go.mod has version $GOMOD_VERSION, but gimme cannot get it"
            return
        fi
        #echo "[+] switching to $GOMOD_VERSION"   # using starship this is not needed anymore
        eval $(gimme $GOMOD_VERSION)
    fi
}

function swgo() {
    switchGoVersion ./go.mod
}

function fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

function mkdir() {
    # extend mkdir with custom features
    # propose adding "--parents" flag.
    echo $1 | grep -E -q '[\S+/]+'
    if [[ $? == 0 && ! -d $1 ]]; then
        # one of the directories in $1 path do not exist
        # suggest adding "--parents" flag.
        echo "# Some parents in $1 do not exist. Press ENTER to run mkdir with --parents."
        read
        echo "# done"
        command mkdir --parents $@
    else
        command mkdir $@
    fi
}

function rm() {
    executed=0
    # extend rm with custom features
    if [[ $1 =~ "-r" ]]; then
        command rm $@
        executed=1
    fi

    for arg in $@; do
        # propose adding "recursive" flag
        if [[ -d $arg ]]; then
            # $1 is a directory. Add --recursive
            echo "$arg is a directory. Press ENTER to run rm with --recursive flag."
            read
            executed=1
            command rm --recursive $@
        fi
    done

    if [[ ! $executed == 1 ]]; then
        command rm $@
    fi
}


function time_left_in_seconds() {
    DEADLINE=$1 # e.g. 17:00 for today's 5pm

    deadline_full=$(date -d $DEADLINE +%s)
    now=$(date +%s)
    time_left=$(($deadline_full - $now))
    if [[ $time_left -gt 0 ]]; then
        echo $time_left
    fi
}

function time_since_in_seconds() {
    TIME_START=$1 # e.g. 17:00 for today's 5pm

    time_start_full=$(date -d $TIME_START +%s)
    now=$(date +%s)
    time_since=$(($now - time_start_full))
    if [[ $time_since -gt 0 ]]; then
        echo $time_since
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
    printf "%sh:%sm.%ss" ${hours} ${minutes} ${seconds}
}

function mkdin() {
    # create directory and cd into in
    mkdir -p $1 && cd $1
}

function zsh_kube_prompt() {
    if ! command -v kubectl 2>&1 >/dev/null; then
        return
    fi
    context=$(kubectl config current-context 2>/dev/null)
    if [[ -z $context ]]; then
        return
    fi
    cluster="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.cluster}")"
    if [[ -n $cluster ]]; then
        printf "(cluster %s)" ${cluster}
    else
        printf ""
    fi
}
