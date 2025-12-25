# 🧠 System Build — Fedora Dev Workstation + Media Stack

**Owner:** `[user]`
**OS:** Fedora (NVMe root + encrypted home)
**Primary role:** High-performance development workstation
**Secondary role:** Always-on media services (server-style tuning)

---

## 🧱 Hardware & Storage

* **CPU:** Intel Ice Lake (iGPU available)
* **GPU:** Intel iGPU (VAAPI / Quick Sync)
* **OS / Home:** NVMe (Btrfs + LUKS for `/home`)
* **Media:** HDD `/dev/sda4` → `/srv/media` (ext4, `noatime`)
* **Backup Store:** NVMe exFAT, mounted on demand at
  `/run/media/[user]/Store`

---

## 🧩 Core Services (systemd *user* services)

Location:

```
~/.config/systemd/user/
```

Tracked in Git:

```
sonarr.service
radarr.service
prowlarr.service
qbittorrent-nox.service
*.service.d/
```

Restore:

```bash
make restore enable restart
```

Lingering (required for boot start):

```bash
loginctl enable-linger [user]
```

---

## 📦 Media Stack

### Sonarr / Radarr / Prowlarr

* Installed as **user services**
* Data in `~/.config/*`
* Hardlinks enabled
* Atomic moves enabled
* Indexers fully managed by Prowlarr

### qBittorrent-nox

* User service
* Category-based routing
* Hardlink-safe paths

### Jellyfin

* Runs as system service
* Media path: `/srv/media`
* **GPU acceleration:** Intel iGPU via **VAAPI**
* **Transcoding:** Hardware-accelerated when needed
* **Direct play preferred**
* **Trickplay:** Enabled, *on-demand only*
* **Streaming limits:** Internet bitrate capped (≈8–10 Mbps)
* **Realtime scanning:** Disabled
* **Scheduled scans only**

---

## ⚙️ Performance & Resource Tuning

### .NET GC (Sonarr / Radarr / Prowlarr)

* Server GC disabled
* Workstation GC enabled
* Heap hard-limit: **512 MB**
* Result: bounded memory, no runaway growth

### CPU Scheduling (Nice)

| Service         | Nice |
| --------------- | ---- |
| Jellyfin        | 0    |
| Sonarr / Radarr | 10   |
| Prowlarr        | 15   |
| qBittorrent     | 15   |

### Disk I/O Priority

* Media services: `best-effort / prio 7`
* Jellyfin: `best-effort / prio 0`

---

## 🔋 Power & Disk Management

### HDD Spindown (`/dev/sda`)

* Managed via **udev rule**
* APM: 127
* Spindown: ~60 minutes (longevity-friendly)
* HDD sleeps when idle, wakes on access

### PowerTOP

* `powertop --auto-tune` enabled via systemd oneshot
* Server-style idle savings only
* **No CPU frequency caps**
* **No dev workflow impact**

---

## 🧹 Log & Cache Hygiene

### journald

* Max usage: **500 MB**
* Retention: **30 days**
* Compression enabled
* Predictable disk usage

### App logs

* Info level
* Retention: 14 days
* Logs & caches excluded from backups

---

## 📦 Backups (Config-Only)

### What is backed up

```
~/.config/Sonarr
~/.config/Radarr
~/.config/Prowlarr
~/.config/qBittorrent*
```

### Where

```
/run/media/[user]/Store/backups/media-stack/
```

### How

* Weekly systemd *user* timer
* `tar.zst` archives
* exFAT-safe (no symlinks)
* Retention: last 6 backups
* Logs/cache excluded

### Restore

```bash
tar --zstd -xpf latest.tar.zst -C "$HOME"
systemctl --user restart sonarr radarr prowlarr qbittorrent-nox
```

---

## 📁 Configuration Versioning

Repo:

```
~/repos/systemd-user-services
```

Includes:

* All `.service` files
* All `.service.d` overrides
* Makefile for restore
* pre-commit validation using `systemd-analyze verify`

---

## 🔐 Security & Scope

* Services bound to localhost where applicable
* No Docker
* No root-run media services
* No laptop-style aggressive power management
* Background services tuned like a server
* Foreground dev workloads always win

---

## 🎯 Design Principles (non-negotiable)

* Measure → then tune
* Bounded resources
* Declarative config in Git
* Rebuildable in minutes
* Zero impact on dev performance
* No “magic” tooling

---

## ✅ System Status

* Stable
* Predictable
* Quiet
* Efficient
* Reproducible

**This system is “done”.**
Any future changes should preserve these principles.

---
