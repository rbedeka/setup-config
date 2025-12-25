#!/usr/bin/env bash
set -e

echo "===== Network Audit ====="
date
echo

echo "## Interfaces & Zones"
sudo firewall-cmd --get-active-zones
echo

echo "## Firewall: FedoraWorkstation"
sudo firewall-cmd --list-all --zone=FedoraWorkstation
echo

echo "## Firewall: trusted (Tailscale)"
sudo firewall-cmd --list-all --zone=trusted
echo

echo "## Listening TCP Ports"
ss -tulpen | grep LISTEN
echo

echo "## Listening UDP Ports"
ss -ulpen
echo

echo "## Avahi Status"
systemctl is-enabled avahi-daemon.service avahi-daemon.socket 2>/dev/null || true
systemctl is-active avahi-daemon.service avahi-daemon.socket 2>/dev/null || true
echo

echo "## Tailscale Status"
systemctl is-enabled tailscaled
systemctl is-active tailscaled
tailscale status 2>/dev/null || echo "tailscale not authenticated"
echo

echo "## SSH Status"
systemctl is-active sshd
sudo sshd -T | rg 'permitrootlogin|passwordauthentication|kbdinteractiveauthentication'
echo

echo "===== Audit Complete ====="
