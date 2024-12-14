#
# Configuration from Bashrc
#
setopt autocd     # cd into folder without typing 'cd'
source $HOME/.config/cconf/dot/dotfiles.sh
source $HOME/.config/cconf/environments/pyenv-init.sh

export ME=$HOME/Me

export CDPATH=$HOME/workspace
#export GOROOT=/usr/local/go/
export GOPATH=$HOME/workspace/golang
export GOBIN=${GOPATH}/bin
export GIT_TERMINAL_PROMPT=1

export KUBE=~/.kube
export KUBE_MAP=~/.kube/dsal-host-config-map.json

# PATH
PATH=~/.local/bin:$PATH
if [[ -d $HOME/.cargo ]]; then
    PATH=$HOME/.cargo/bin:$PATH
fi

PATH=$PATH:$HOME/toolkit
PATH=$PATH:$HOME/workspace/script-fu
PATH=$PATH:$HOME/workspace/toolbelt
PATH=$PATH:$HOME/.atuin/bin
PATH=$PATH:${GOBIN}
PATH=$PATH:${GOROOT}/bin
if [[ -d ${HOME}/workspace/me/flutter ]]; then
    PATH=$PATH:${HOME}/workspace/me/flutter/bin
fi

# Let's have core dumps
ulimit -c unlimited
# Enable gcc colours, available since gcc 4.9.0
GCC_COLORS=1

#
# Aliases
#
source ~/.config/cconf/dot/dotfiles.sh

#
# Bindings
#

# bindings (-e emacs, -v vi)
bindkey -v
# Re-enable history search in vi-mode
bindkey '^R' history-incremental-search-backward

bindkey jj vi-cmd-mode
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd m edit-command-line
#bindkey -s jj '\e'

# Remove mode switching delay.
#KEYTIMEOUT=5 > this break bindkey above

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# custom bindings
source ~/.config/cconf/zsh/bindings.zsh

#
# Editor for local and remote sessions
#
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi


# For thinkpad pointer (it only works on X11, but it is up to the script to detect it)
#[[ -e thinkpointer.sh ]] && thinkpointer.sh
#
# Completion
#
# extend change directory
#setopt auto_cd
# allow comments on the shell
setopt interactivecomments
cdpath=($HOME $HOME/workspace)

autoload -U compinit
compinit -u

# highlight current selected completion item on tab
zstyle ':completion:*' menu select
# some level of smart case sensitivness in autocompletion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Allow completion of "go upper directory" (e.g. ..<TAB>)
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
# Show first local directories, then directories in cdpath
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
zstyle ':completion:*:descriptions' format %B%d%b
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

#
# Functions and aliases
#
source ~/.config/cconf/zsh/functions.zsh

#
# History
#
HISTSIZE=5000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=5000               # Number of history entries to save to disk
setopt BANG_HIST            # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY     # Write the history file in the ":start:elapsed;command" format.
setopt HIST_FIND_NO_DUPS    # Do not display a line previously found.
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS     # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE    # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS    # Don't write duplicate entries in the history file.
setopt HIST_VERIFY          # Don't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY   # save history immediatly (not just as term closes)
setopt SHARE_HISTORY        # share history across terminals

#
# Plugins
#

ZSH_CUSTOM=~/.config/cconf/zsh
for plugin in $(ls $ZSH_CUSTOM/plugins); do
    if [[ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]]; then
        source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
    fi
done
source $ZSH_CUSTOM/plugins/zsh-async/async.plugin.zsh

unsetopt complete_aliases
unsetopt completealiases

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g "" -U'

#
# Prompt
#

# async vcs_info update wrapper
_vbe_vcs_info() {
    cd -q $1
    if [ -n vsc_info ]; then
        vcs_info 2>&1 >/dev/null
        print ${vcs_info_msg_0_}
    fi
}
# async vcs_info update worker
_vbe_vcs_info_done() {
    local stdout=$3
    vcs_info_msg_0_=$stdout
    zle reset-prompt
}

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info

# vcs info (for git)
zstyle ':vcs_info:*' enable git
() {
    zstyle ':vcs_info:git*:*' formats '\ue725 %F{green}%b%m%c%u%f' # default ' (%s)-[%b]%c%u-'
    zstyle ':vcs_info:git*:*' actionformats 'on %F{green}(%a)%b|%m%c%u%f' # default ' (%s)-[%b|%a]%c%u-'
    zstyle ':vcs_info:*' stagedstr "%F{green}+%f" # default 'S'
    zstyle ':vcs_info:*' unstagedstr "%F{red}!%f" # default 'U'
    zstyle ':vcs_info:*' use-simple true
    zstyle ':vcs_info:*' check-for-changes true
    #zstyle ':vcs_info:git+set-message:*' hooks git-untracked
    #+vi-git-untracked() {
        #emulate -L zsh
        #if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
            #hook_com[unstaged]+="%F{blue}!%f"
        #fi
    #}
}
source $ZSH_CUSTOM/plugins/zsh-async/async.zsh
async_init
async_start_worker vcs_info
async_register_callback vcs_info _vbe_vcs_info_done
# async vcs_info schedule
add-zsh-hook precmd () {
    now_timestamp_=$(date +%H:%M:%S)
    local cmd_end="$SECONDS"
    if [[ $cmd_start -gt 0 ]]; then
        elapsed=$((cmd_end-cmd_start))
        if [[ $elapsed -gt 10 ]]; then
            echo elapsed `humanizetime $elapsed`
            cmd_start=0
        fi
    fi
    vcs_info_msg_0_="[...]"
    if ! async_job vcs_info _vbe_vcs_info $PWD 2>&1 >/dev/null; then
        async_init
        async_start_worker vcs_info
        async_register_callback vcs_info _vbe_vcs_info_done
    fi
}
add-zsh-hook chpwd (){
    now_timestamp_=$(date +%H:%M:%S)
    vcs_info_msg_0_="[...]"
    switch_go_version
    auto_venv
}
add-zsh-hook preexec () {
    cmd_start="$SECONDS"
}

# kubectl completion
if command -v kubectl 2>&1 >/dev/null; then
    [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
fi

# run atuin if installed
if command -v atuin 2>&1 >/dev/null; then
    # Bind ctrl-r but not up arrow
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# source uncommitable env variables
if [[ -f ~/Documents/unsharable ]]; then
    source ~/Documents/unsharable
fi

NEWLINE=$'\n'
LPROMPT_BASE="%F{blue}%B%~%b%f"
setopt PROMPT_SUBST

export PS1=" \${now_timestamp_} $LPROMPT_BASE \${vcs_info_msg_0_}${NEWLINE} %(?.%F{green}%B➤ %b%f.%F{red}%B➤ %b%f) "
#export RPROMPT="$RPROMPT_BASE %F{yellow}%B%~%b%f"
export RPROMPT=""

# init starship if installed
if command -v starship 2>&1 >/dev/null; then
    export STARSHIP_CONFIG=$HOME/.dot/.config/starship.toml
    eval "$(starship init zsh)"
fi
