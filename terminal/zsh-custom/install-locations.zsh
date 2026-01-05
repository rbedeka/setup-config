export STORYBOOK_DISABLE_TELEMETRY=1
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"

# =============== CARGO ==================

export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"

# =============== BUN ==================

export BUN_INSTALL="$HOME/.local/share/bun"

# =============== NPM ==================

export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"

# =============== DOTNET ==================

export DOTNET_CLI_HOME="$HOME/.local/share/dotnet"

# =============== DOCKE  ==================

export DOCKER_CONFIG="$HOME/.config/docker"
