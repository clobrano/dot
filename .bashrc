# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

stty -ixon          # Disable terminal freeze shortcut C-s
shopt -s autocd     # cd into folder without typing 'cd'
shopt -s checkwinsize

# command history
shopt -s histappend # append to the history file, don't overwrite it
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
export HISTTIMEFORMAT="%d/%m/%y %T "

# terminal and color (more below)
COLORTERM=gnome-terminal
TERM=xterm-256color
color_prompt=yes

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

[[ -e /etc/profile.d/vte-2.91.sh ]] && source /etc/profile.d/vte-2.91.sh

function _update_ps1() {
    dir=`basename $(dirname $PWD)`/`basename $PWD`
    PS1="\u • ${dir} $ "
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

export EDITOR="gedit"

source $HOME/.config/cconf/dot/dotfiles.sh
source $HOME/.config/cconf/requirements/pyenv.sh

export CDPATH=$HOME/workspace/devel
export GOROOT=/usr/lib/go
export GOPATH=$HOME/workspace/golang
export GOBIN=${GOPATH}/bin
export GIT_TERMINAL_PROMPT=1

# PATH
ANDROID_REPO=$HOME/external/bin/
PATH=$PATH:$HOME/workspace/tscript
PATH=$PATH:$HOME/workspace/script-fu
PATH=$PATH:$HOME/toolkit
PATH=$PATH:${GOROOT}/bin
PATH=$PATH:${GOBIN}
PATH=$PATH:$ANDROID_REPO
PATH=~/.local/bin:$PATH
PATH=~/workspace/depot_tools:$PATH
PATH=~/workspace/codesonar/codesonar/bin:$PATH

# Redtimer
export REDTIMER_LOG_SESSION_PATH="${HOME}/MyBox/work/telit/redtimer-session-log.txt"
export REDTIMER_WORK_SESSION_TIME=40
export REDTIMER_PAUSE_SESSION_TIME=5

# Android/Chromebook
export USE_CCACHE=1
export PATH=~/workspace/depot_tools:$PATH

# Enable gcc colours, available since gcc 4.9.0
GCC_COLORS=1
# Fix ZSH_VERSION unbound variable
ZSH_VERSION=${ZSH_VERSION-"none"}
# Let's have core dumps
ulimit -c unlimited

# Fuzzy finder configuration
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# aliases
alias bi='source ${HOME}/.bashrc'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l'
alias la='ls -alF'
alias grep='grep --color=auto'
alias node='nodejs'  # in ubuntu binary is called wrong
alias itsmine="sudo chown $USER"
alias sendat='sudo $GOBIN/sendat'
alias mmake='meson compile'

# Local bash configuration I don't want to save upstream
[ -f $HOME/.local_bashrc ] && source $HOME/.local_bashrc
