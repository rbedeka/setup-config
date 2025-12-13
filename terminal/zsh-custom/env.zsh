# --------------------------------------------------
# General environment variables
# --------------------------------------------------

# Bun
export BUN_INSTALL="$HOME/.bun"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"

# Cargo (safe to source)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Dir
[[ -f ~/.dircolors ]] && eval "$(dircolors ~/.dircolors)"

