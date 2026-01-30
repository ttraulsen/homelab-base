#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Starting homelab bootstrap"

echo "==> Host configuration"
for f in "$SCRIPT_DIR/host/"*.sh; do
  echo "--> Running $(basename "$f")"
  sudo bash "$f"
done

echo "==> Kubernetes installation"
sudo bash "$SCRIPT_DIR/k8s/install-k3s.sh"
sudo bash "$SCRIPT_DIR/k8s/post-install.sh"

echo "==> Bootstrap completed successfully"
