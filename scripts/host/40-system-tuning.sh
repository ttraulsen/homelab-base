#!/usr/bin/env bash
set -euo pipefail

echo "Applying system tuning"

cat > /etc/sysctl.d/99-homelab.conf <<EOF
vm.swappiness=10
fs.inotify.max_user_watches=1048576
EOF

sysctl --system
