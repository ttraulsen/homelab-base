#!/usr/bin/env bash
set -euo pipefail

echo "Applying sysctl configuration"

CONF_SRC="$(dirname "$0")/sysctl.d/99-homelab.conf"
CONF_DST="/etc/sysctl.d/99-homelab.conf"

install -m 644 "$CONF_SRC" "$CONF_DST"

sysctl --system

echo "Sysctl configuration applied"
