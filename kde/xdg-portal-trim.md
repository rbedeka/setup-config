# 🔥 xdg-desktop-portal Trimming (KDE-correct way)

Your current top offender:

```
3.423s xdg-desktop-portal.service
419ms xdg-desktop-portal-gtk.service
408ms plasma-xdg-desktop-portal-kde.service
```

This means **multiple portals are competing**, and GTK is being started even though you’re on KDE.

---

## 🧠 What xdg-desktop-portal actually does (quick clarity)

It exists for:

* Flatpak sandbox permissions
* Screen sharing (PipeWire)
* File chooser portals
* Web browsers sandboxed via portals

👉 **You do NOT need all backends active.**
👉 KDE should prefer **plasma portal only**.
👉 GTK portal is unnecessary unless you use GNOME apps heavily.

---

## ✅ Target state (what we want)

| Component                | Status                   |
| ------------------------ | ------------------------ |
| `xdg-desktop-portal`     | ✅ enabled                |
| `xdg-desktop-portal-kde` | ✅ enabled                |
| `xdg-desktop-portal-gtk` | ❌ disabled               |
| Flatpak portals          | ❌ unless you use Flatpak |
| Extra portal probing     | ❌ minimized              |

---

## 🛠 Step 1 — Disable GTK portal (safe, big win)

GTK portal adds **~400ms** and causes backend probing.

```bash
systemctl --user mask xdg-desktop-portal-gtk.service
systemctl --user stop xdg-desktop-portal-gtk.service
```

✔ KDE apps unaffected
✔ Firefox still works
✔ Screen sharing still works (KDE backend)

---

## 🛠 Step 2 — Force KDE portal priority (important)

Create a portal preference file:

```bash
mkdir -p ~/.config/xdg-desktop-portal
nano ~/.config/xdg-desktop-portal/portals.conf
```

Paste:

```ini
[preferred]
default=kde
org.freedesktop.impl.portal.ScreenCast=kde
org.freedesktop.impl.portal.Screenshot=kde
org.freedesktop.impl.portal.FileChooser=kde
```

✔ Prevents backend probing
✔ Stops GTK fallback
✔ Reduces startup latency

---

## 🛠 Step 3 — Restart portal stack

```bash
systemctl --user restart xdg-desktop-portal.service
```

(Or just reboot — recommended for clean measurement.)

---

## 🔍 Step 4 — Verify active portals

After reboot:

```bash
systemctl --user status xdg-desktop-portal.service
```

You should **NOT** see GTK mentioned.

Check blame again:

```bash
systemd-analyze --user blame | head -20
```

---

## 🧯 Rollback (if ever needed)

```bash
systemctl --user unmask xdg-desktop-portal-gtk.service
rm ~/.config/xdg-desktop-portal/portals.conf
reboot
```

---
