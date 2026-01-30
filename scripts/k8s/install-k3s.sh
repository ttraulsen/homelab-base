#!/usr/bin/env bash
set -euo pipefail

echo "Installing k3s"

curl -sfL https://get.k3s.io | sh -s - \
  --disable traefik \
  --disable servicelb

systemctl enable k3s
