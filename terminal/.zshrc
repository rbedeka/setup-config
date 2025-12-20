# zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh"

# Prompt handled by Starship
ZSH_THEME=""

plugins=(
  git
	docker
  sudo
	postgres  
	zsh-autosuggestions
  zsh-syntax-highlighting
)

# Speed up completion initialization
zstyle ':completion:*' rehash true
ZSH_DISABLE_COMPFIX=true
zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh



# zprof

