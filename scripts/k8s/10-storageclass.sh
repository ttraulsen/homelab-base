#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up k3s Local Path Storage on NAS"

STORAGE_CLASS_NAME="local-nas"
NAS_MOUNT_PATH="/mnt/nas/k8s"
SC_YAML="/tmp/local-path-storage.yaml"

# 1️⃣ Prüfen, ob StorageClass schon existiert
if kubectl get storageclass "$STORAGE_CLASS_NAME" &>/dev/null; then
    echo "StorageClass $STORAGE_CLASS_NAME already exists, skipping creation"
else
    echo "Creating StorageClass $STORAGE_CLASS_NAME"

    cat > "$SC_YAML" <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $STORAGE_CLASS_NAME
provisioner: rancher.io/local-path
parameters:
  path: $NAS_MOUNT_PATH
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
EOF

    kubectl apply -f "$SC_YAML"
    rm "$SC_YAML"
    echo "StorageClass $STORAGE_CLASS_NAME created"
fi

echo "==> Storage setup complete"
