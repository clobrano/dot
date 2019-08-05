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


function _branchname() {
    printf $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1) /' -e 's/((HEAD detached at\(.*\)))/\1/') 2>/dev/null
}

function _gitstatus() {
   [[ $(git status --short 2>/dev/null | wc -l) > 0 ]] && printf "~"
}

function _virtualenv() {
    [[ ! -z $VIRTUAL_ENV ]] && echo "\[\e[0;32m\]($(basename $VIRTUAL_ENV))\[\e[m\]·" || echo ""
}

function _update_ps1() {
    dir=`basename $(dirname $PWD)`/`basename $PWD`
    PS1="${debian_chroot:+\[\e[0;31m\]($debian_chroot)\[\e[m\]·}$(_virtualenv)\[\e[31m\] \u\[\e[m\]\[\e[33m\] ● \[\e[m\]\[\e[31m\]${dir}\[\e[m\]$([[ $(which git | wc -l) > 0 ]] && _branchname && _gitstatus)$ "
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

export EDITOR="gvim -f"

source $HOME/.config/cconf/dotfiles/dotfiles.sh

export CDPATH=$HOME/workspace/devel
export GOROOT=/usr/local/go
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

# Redtimer
export REDTIMER_LOG_SESSION_PATH="${HOME}/Dropbox/Work/Telit/redtimer-session-log.txt"

# Enable gcc colours, available since gcc 4.9.0
GCC_COLORS=1
# Fix ZSH_VERSION unbound variable
ZSH_VERSION=${ZSH_VERSION-"none"}
# Let's have core dumps
ulimit -c unlimited

# Let's do configuration
letsbin=$(which lets 2>/dev/null)
[[ ! -z ${letsbin:x} ]] && [[ -f $HOME/.letsdo_completion ]] && source $HOME/.letsdo_completion

# Fuzzy finder configuration
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# aliases
alias bi='source ${HOME}/.bashrc'
alias sa='sudo apt'
alias ls='ls --color=auto --group-directories-first'
alias l='ls'
alias ll='ls -l'
alias la='ls -alF'
alias grep='grep --color=auto'
alias ccat='highlight --out-format=ansi'
alias node='nodejs'  # in ubuntu binary is called wrong
alias itsmine="sudo chown $USER"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias sendat='sudo $GOBIN/sendat'
alias hikeydefconf='make ARCH=arm64 hikey_defconfig'
alias hikeymenuconf='make ARCH=arm64 menuconfig'
alias hikeymake='make ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- -j2'
