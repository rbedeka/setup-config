## 0️⃣ Design goals (locked)

* **No remote desktop by default**
* **No GUI dependency** for daily work
* **Single source of truth**: the Fedora box
* **Mobile-first access** (Safari + SSH)
* **Tailscale-secured**, no WAN exposure
* **Reproducible & observable**

---

## 1️⃣ Core access layers (what exists, what doesn’t)

### Exists (and stays)

* SSH (key-only)
* Tailscale (trusted interface)
* systemd user services (linger enabled)

### Explicitly absent

* VNC / RDP / RustDesk / AnyDesk
* X11 forwarding
* GUI login requirement

This ensures the machine behaves like a **headless server** even though it’s a workstation.

---

## 2️⃣ Primary workflow: VS Code without a desktop

### A. VS Code Tunnel (default path)

**What it gives you**

* Full VS Code experience in **Safari on iPhone/iPad**
* No port forwarding
* No inbound firewall changes
* No GUI session required
* Excellent latency and stability

**Mental model**

> Fedora runs the editor backend.
> Your iPad is just a thin client.

**How it runs**

* On-demand command
* Or systemd **user service** (opt-in)

**Why this is the default**

* It replaces 90% of “remote desktop” needs
* It’s stateless on the client
* Works equally well on phone, tablet, or laptop

---

### B. SSH + terminal editor (fallback / low-bandwidth)

Use this when:

* You’re on a slow network
* You only need quick edits
* You want maximal battery efficiency

**Client options (iOS)**

* Blink
* a-Shell
* Termius

**Server**

* tmux
* neovim / vim
* standard CLI tools

**Pattern**

```text
SSH → tmux → editor + build + logs
```

This is your **failsafe path**. Always available.

---

## 3️⃣ Command execution & builds (headless by design)

### tmux as the session backbone

* Long-running builds
* Log tails
* Detached sessions survive disconnects

Recommended baseline:

* One tmux session per project
* Named windows: `editor`, `build`, `logs`, `shell`

No GUI dependency, zero friction.

---

## 4️⃣ File access & artifacts

### Code

* Accessed via VS Code tunnel or SSH
* Git is authoritative

### Artifacts (build outputs, logs)

* Read via VS Code explorer
* Or `scp` / `rsync` over SSH when needed

Avoid:

* Network file shares
* GUI file managers

---

## 5️⃣ Observability (no dashboards)

### Logs

* `journalctl` for services
* App logs via files or stdout
* VS Code terminal for quick inspection

### Network & security

* `ss -tulpen`
* `firewall-cmd`
* `tailscale status`

Everything is **CLI-visible and scriptable**.

---

## 6️⃣ Service lifecycle (headless-safe)

### Pattern used everywhere

* systemd user services
* `loginctl enable-linger [user]`
* No dependency on login sessions

This guarantees:

* Services run after reboot
* SSH works without GUI login
* VS Code tunnel can be started remotely

---

## 7️⃣ Optional: “break glass” GUI access (off by default)

Only if you **explicitly need it**.

**Rules**

* Not enabled at boot
* Bound to Tailscale only
* Started manually
* Stopped immediately after use

Examples:

* Waypipe (on-demand)
* RDP via `xrdp` (masked by default)

This remains an **exception path**, not a workflow.

---

## 8️⃣ iPhone / iPad ergonomics (important)

### Input

* Hardware keyboard recommended
* Modifier remapping in iPadOS
* VS Code Web handles shortcuts well

### Display

* Safari in desktop mode
* Split view for docs + editor

No special apps required.

---

## 9️⃣ Security posture (resulting state)

* One ingress protocol: **SSH (and VS Code tunnel auth)**
* One trusted overlay: **Tailscale**
* No persistent GUI listeners
* No third-party remote control software
* Auditable with a single `ss -tulpen`

---

## 🔒 Final architecture (summary)

```
iPhone / iPad
   │
   ├─ Safari → VS Code Tunnel ─┐
   │                           │
   └─ SSH → tmux → CLI tools ──┼─ Fedora workstation
                               │
                         systemd user services
                         (headless, persistent)
```

---

## Final verdict

This workflow:

* scales from phone → tablet → laptop
* survives reboots and disconnects
* minimizes attack surface
* avoids GUI brittleness
* matches how modern remote dev is actually done
