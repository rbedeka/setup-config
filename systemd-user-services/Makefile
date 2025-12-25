USER_SYSTEMD_DIR := $(HOME)/.config/systemd/user

.PHONY: help restore enable restart status lint

help:
	@echo "Targets:"
	@echo "  restore  - Copy systemd user units into place"
	@echo "  enable   - Enable user services"
	@echo "  restart  - Restart user services"
	@echo "  status   - Show status of services"
	@echo "  lint     - Validate unit files"

restore:
	mkdir -p $(USER_SYSTEMD_DIR)
	cp -a systemd/user/* $(USER_SYSTEMD_DIR)/
	systemctl --user daemon-reload

enable:
	systemctl --user enable sonarr radarr prowlarr qbittorrent-nox

restart:
	systemctl --user restart sonarr radarr prowlarr qbittorrent-nox

status:
	systemctl --user status sonarr radarr prowlarr qbittorrent-nox

lint:
	systemd-analyze verify systemd/user/*.service systemd/user/*.service.d/*.conf
