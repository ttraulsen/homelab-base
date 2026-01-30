#!/usr/bin/env bash
set -euo pipefail

echo "Configuring UFW firewall"

ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow 22/tcp comment 'SSH access'

# Kubernetes / k3s
ufw allow 6443/tcp comment 'k3s API server'

# Optional: ICMP (Ping)
ufw allow proto icmp comment 'Allow ping'

ufw --force enable

ufw status verbose
