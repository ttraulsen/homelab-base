#!/usr/bin/env bash
set -euo pipefail

echo "==> Configuring kubeconfig"

K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
KUBECONFIG_PATH="$HOME/.kube/config"

mkdir -p "$(dirname "$KUBECONFIG_PATH")"
cp "$K3S_KUBECONFIG" "$KUBECONFIG_PATH"
chmod 600 "$KUBECONFIG_PATH"

export KUBECONFIG="$KUBECONFIG_PATH"

echo "==> Validating cluster"
kubectl get nodes
kubectl get pods -A

echo "==> k3s installation and post-configuration done"
