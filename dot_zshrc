export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"

ZSH_THEME="ys"

# update automatically without asking
zstyle ':omz:update' mode auto

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

_comp_options+=(globdots)

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh
command -v fzf > /dev/null && source <(fzf --zsh)
[ -f $HOME/.config/aliasrc ] && source "$HOME/.config/aliasrc"

