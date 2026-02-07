#!/usr/bin/env bash
set -euo pipefail

echo "Applying SSH hardening"

SSHD_DIR="/etc/ssh/sshd_config.d"
CONF_FILE="$SSHD_DIR/99-homelab.conf"

mkdir -p "$SSHD_DIR"

install -m 644 "$(dirname "$0")/ssh.conf.d/99-homelab.conf" "$CONF_FILE"

echo "Validating SSH configuration"
sshd -t

echo "Reloading SSH daemon"
systemctl reload ssh

echo "SSH hardening applied successfully"
