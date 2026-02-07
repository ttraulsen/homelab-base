#!/usr/bin/env bash
set -euo pipefail

# === Konfiguration ===
NAS_SERVER="diskstation"
NAS_EXPORT="/volume1/homelab/k8s-pv"
MOUNT_POINT="/mnt/nas/k8s"
FSTAB_ENTRY="${NAS_SERVER}:${NAS_EXPORT} ${MOUNT_POINT} nfs defaults 0 0"

echo "==> Setting up NAS mount"

# 1. Mount-Punkt erstellen
if [ ! -d "$MOUNT_POINT" ]; then
  echo "Creating mount point $MOUNT_POINT"
  mkdir -p "$MOUNT_POINT"
else
  echo "Mount point $MOUNT_POINT already exists"
fi

# 2. Prüfen, ob fstab schon einen Eintrag hat
if grep -qsF "$FSTAB_ENTRY" /etc/fstab; then
  echo "fstab entry already exists, skipping"
else
  echo "Adding entry to /etc/fstab"
  echo "$FSTAB_ENTRY" | tee -a /etc/fstab
fi

# 3. Mounten, falls noch nicht gemountet
if mountpoint -q "$MOUNT_POINT"; then
  echo "$MOUNT_POINT already mounted"
else
  echo "Mounting $MOUNT_POINT"
  mount "$MOUNT_POINT"
fi

echo "==> NAS mount setup complete"
