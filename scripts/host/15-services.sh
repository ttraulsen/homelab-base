#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/services.conf"

systemctl_exists() {
  systemctl list-unit-files | grep -q "^$1"
}

echo "Disabling unwanted services"
for svc in "${DISABLE_SERVICES[@]}"; do
  if systemctl_exists "$svc"; then
    systemctl stop "$svc" || true
    systemctl disable "$svc" || true
  fi
done

echo "Masking forbidden services"
for svc in "${MASK_SERVICES[@]}"; do
  if systemctl_exists "$svc"; then
    systemctl mask "$svc" || true
  fi
done

echo "Enabling required services"
for svc in "${ENABLE_SERVICES[@]}"; do
  if systemctl_exists "$svc"; then
    systemctl enable "$svc"
    systemctl start "$svc" || true
  fi
done

echo "Service configuration completed"
