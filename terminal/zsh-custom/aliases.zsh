# --------------------------------------------------
# Aliases & functions
# --------------------------------------------------

alias pn=pnpm
alias upgrade='sudo dnf update -y && sudo dnf autoremove -y'
alias boot_log="$HOME/Utilities/mesaure_boot.sh"

# Tor browser launcher (function > alias)
torada() {
  cd "$HOME/.rada/tor-browser" || return
  ./start-tor-browser.desktop
  cd ~
}

alias c='wl-copy'
alias p='wl-paste'
alias ll='ls -lah --color=auto'
alias cat='bat'
alias grep='rg'
alias cls='clear'
alias jelly='cd /srv/media/library'
alias sonarr='systemctl --user start sonarr.service'
alias radarr='systemctl --user start radarr.service'
alias remedia='systemctl start jellyfin.service'
alias qbt='systemctl --user start qbittorrent-nox'
