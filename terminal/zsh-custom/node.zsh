# --------------------------------------------------
# Lazy-loaded NVM
# --------------------------------------------------

export NVM_DIR="$HOME/.nvm"

# Lazy loader
__load_nvm() {
  unset -f node npm npx pnpm yarn nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

# Stub commands
node()  { __load_nvm; node  "$@"; }
npm()   { __load_nvm; npm   "$@"; }
npx()   { __load_nvm; npx   "$@"; }
pnpm()  { __load_nvm; pnpm  "$@"; }
yarn()  { __load_nvm; yarn  "$@"; }
nvm()   { __load_nvm; nvm   "$@"; }
