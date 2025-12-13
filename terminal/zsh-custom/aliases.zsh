# --------------------------------------------------
# Aliases & functions
# --------------------------------------------------

alias pn=pnpm
alias upgrade='sudo dnf update -y && sudo dnf autoremove -y && omz update'
alias boot_log="$HOME/Utilities/mesaure_boot.sh"

# Tor browser launcher (function > alias)
torada() {
  cd "$HOME/.rada/tor-browser" || return
  ./start-tor-browser.desktop
  cd ~
}
