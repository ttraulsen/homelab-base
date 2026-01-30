#!/usr/bin/env bash
set -euo pipefail

echo "Post-install Kubernetes setup"

mkdir -p /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
chmod 600 /root/.kube/config
