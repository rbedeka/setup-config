# systemd user services (media stack)

This repo contains systemd *user* service definitions for:

- Sonarr
- Radarr
- Prowlarr
- qBittorrent-nox

## Backup instructions

cp -a ~/.config/systemd/user/*.service systemd/user/
cp -a ~/.config/systemd/user/*.service.d systemd/user/


## Restore instructions

```bash
cp -a systemd/user/* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable sonarr radarr prowlarr qbittorrent-nox
systemctl --user restart sonarr radarr prowlarr qbittorrent-nox
