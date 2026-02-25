#!/usr/bin/env bash
set -euo pipefail

echo "Configuring UFW firewall"

ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
echo "allow ssh"
ufw allow 22/tcp comment 'SSH access'

# Kubernetes / k3s
echo "allow k3s"
ufw allow 6443/tcp comment 'k3s API server'

ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'

ufw --force enable

ufw status verbose
