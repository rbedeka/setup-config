# --------------------------------------------------
# Aliases & functions
# --------------------------------------------------

alias pn=pnpm
alias upgrade='sudo dnf update -y && sudo dnf autoremove -y'
alias boot_audit="$HOME/work/setup/utils/mesaure_boot.sh"
alias net_audit="$HOME/work/setup/utils/network-audit.sh"

# Tor browser launcher (function > alias)
alias torada='./.local/share/tor-browser/Browser/start-tor-browser --detach'
alias c='wl-copy'
alias p='wl-paste'
alias ll='ls -lah --color=auto'
alias cat='bat'
alias grep='rg'
alias cls='clear'
alias jelly='cd /srv/media/library'
alias sonarr='systemctl --user restart sonarr.service'
alias radarr='systemctl --user restart radarr.service'
alias remedia='sudo systemctl restart jellyfin.service'
alias qbt='systemctl --user restart qbittorrent-nox'
alias nord='nordvpn'
alias re-wifi='nmcli radio wifi off && nmcli radio wifi on'
alias re-tail='sudo tailscale down && sleep 2 && sudo tailscale up'
