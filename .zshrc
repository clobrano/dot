setopt AUTO_CD

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='gvim'
fi

#
# Plugins
#

ZSH_CUSTOM=~/.config/cconf/zsh
for plugin in $(ls $ZSH_CUSTOM/plugins); do
    source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
done

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

#
# Functions and aliases
#
source ~/.config/cconf/zsh/functions.zsh
source ~/.config/cconf/zsh/bindings.zsh
source $HOME/.config/cconf/dotfiles/dotfiles
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# PROMPT
#

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u]' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u]' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

LPROMPT_BASE="\${vcs_info_msg_0_}"
setopt PROMPT_SUBST

export PS1="$LPROMPT_BASE%F{yellow}%B%(1j.*.)%b%f $ "
export RPROMPT=%F{blue}%~%f
