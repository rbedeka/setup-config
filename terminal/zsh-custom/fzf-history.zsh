# ----------------------------------------
# Lazy fzf history search (Ctrl-R override)
# ----------------------------------------

__fzf_hist_loaded=false

__load_fzf_hist() {
  if [[ "$__fzf_hist_loaded" != true ]]; then
    # Fedora path
    source /usr/share/fzf/shell/key-bindings.zsh
    __fzf_hist_loaded=true
  fi
}

fzf-history-widget() {
  __load_fzf_hist
  zle fzf-history-widget
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
