#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing k3s"

# Optional: define channel or version
K3S_CHANNEL="stable"
K3S_EXEC="--disable traefik --disable servicelb --write-kubeconfig-mode 644"

curl -sfL https://get.k3s.io | sh -s - \
    --channel "$K3S_CHANNEL" \
    $K3S_EXEC

echo "==> Enabling and starting k3s service"
systemctl enable --now k3s
