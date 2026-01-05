# ~/.oh-my-zsh/custom/path.zsh

typeset -U path
path=(
  # User Bins
  $HOME/.local/bin
  $HOME/bin

  # Bun (corrected path)
  $HOME/.local/share/bun/bin

  # pnpm
  $HOME/.local/share/pnpm

  # Cargo
  $HOME/.local/share/cargo/bin

  # Opencode
  $HOME/.opencode/bin

  # Keep existing system paths
  $path
)
