#
# Aliases
#
source ~/.config/cconf/dot/dotfiles.sh

#
# Bindings
#

# emacs based bindings because I am used to
bindkey -e
# custom bindings
source ~/.config/cconf/zsh/bindings.zsh

#
# Editor for local and remote sessions
#
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='gedit'
fi

#
# Completion
#

# extend change directory
#setopt auto_cd
cdpath=($HOME $HOME/workspace $HOME/workspace/devel)

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

ZSH_CUSTOM=~/.dot/.config/cconf/zsh
for plugin in $(ls $ZSH_CUSTOM/plugins); do
    source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
done

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g "" -U'

#
# Prompt
#

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info

# vcs info (for git)
zstyle ':vcs_info:*' stagedstr "%F{green}!%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}!%f" # default 'U'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u]' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[(%a)%b|%m%c%u]' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}!%f"
  fi
}

LPROMPT_BASE=" %F{yellow}%B%n%b%f • %c"
RPROMPT_BASE="\${vcs_info_msg_0_}"
setopt PROMPT_SUBST

export PS1="$LPROMPT_BASE%F{yellow}%B%(1j.*.)%b%f » "
export RPROMPT="$RPROMPT_BASE %F{yellow}%B%~%b%f"
