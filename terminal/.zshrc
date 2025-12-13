# zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_FCNTL_LOCK

# Prompt handled by Starship
ZSH_THEME=""

plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Speed up completion initialization
zstyle ':completion:*' rehash true
ZSH_DISABLE_COMPFIX=true
zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh


# Directory jumping
eval "$(zoxide init zsh)"

# Prompt
eval "$(starship init zsh)"

# zprof
