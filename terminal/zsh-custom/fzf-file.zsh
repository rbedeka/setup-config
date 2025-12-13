# ----------------------------------------
# Lazy fzf file picker (Ctrl-T)
# ----------------------------------------

__fzf_file_loaded=false

__load_fzf_file() {
  if [[ "$__fzf_file_loaded" != true ]]; then
    source /usr/share/fzf/shell/key-bindings.zsh
    __fzf_file_loaded=true
  fi
}

fzf-file-widget() {
  __load_fzf_file
  zle fzf-file-widget
}

zle -N fzf-file-widget
bindkey '^T' fzf-file-widget
