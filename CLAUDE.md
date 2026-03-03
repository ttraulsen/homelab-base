# CLAUDE.md — homelab-base

This repository is the **foundation layer** of a single-node homelab running k3s on a Lenovo ThinkCentre M625Q.
It contains host-level configuration, bootstrap scripts, and all architectural documentation (ADRs).

## Repository Role

homelab-base provides:
- Bootstrap and recovery procedures
- Host OS configuration scripts
- Architecture Decision Records (ADRs 0001–0008)
- Operational guides

**Deployment order:** homelab-base → homelab-k8s-infra → homelab-k8s-apps

## Architecture Overview

```
Hardware:     Lenovo ThinkCentre M625Q (AMD E2-9000E, 16GB RAM, 512GB NVMe)
OS:           Ubuntu Server LTS
Kubernetes:   k3s (single-node, Traefik and servicelb disabled)
Ingress:      Traefik (deployed via homelab-k8s-infra)
Certs:        cert-manager + Let's Encrypt
Auth:         Authentik (OIDC/OAuth2/SAML/passkeys)
Database:     PostgreSQL (shared, Bitnami chart)
Storage:      local NVMe + NAS (Synology DS414) + offsite Hetzner backups
Secrets:      SOPS + age encryption
Deployment:   Helmfile (manual execution, not GitOps)
Domain:       .hestia (local) + dynamic DNS for public services
```

## Directory Structure

```
docs/              → Architecture docs, ADRs, operational guides
scripts/
  host/            → OS-level setup scripts (run as root on the server)
  k8s/             → k3s install and StorageClass setup
  operator/        → age and SOPS setup (run on operator machine)
```

## Scripts

All scripts use `#!/usr/bin/env bash` with `set -euo pipefail`. They are **idempotent** — safe to re-run.
Config is kept in separate `.conf` files (not hardcoded in scripts).

Host scripts run in order:
- `00-preflight.sh` → `05-networking.sh` → `10-packages.sh` → `15-services.sh` → `20-ssh.sh`
- `30-firewall.sh` → `40-system-tuning.sh` → `50-mount-nas.sh` → `99-cleanup.sh`

When modifying scripts: keep the pattern of self-documenting echo statements, maintain idempotency, and
store configurable values in the corresponding `.conf` file.

## ADR Convention

ADRs live in `docs/decisions/`. Format:
- **Status:** Accepted / Superseded / Deprecated
- **Context:** Why a decision was needed
- **Decision:** What was decided
- **Rationale:** Why this option
- **Alternatives:** What was rejected and why
- **Consequences:** Trade-offs accepted

When proposing architectural changes, create or update an ADR before changing scripts.

## Key Design Principles

- **Simplicity over cleverness** — prefer readable, understandable solutions
- **Documented pragmatism** — explicit trade-offs beat implicit assumptions
- **Reproducibility** — system can be rebuilt from scratch using these scripts
- **Manual control** — deployment is deliberate, not automatic
- **No HA** — single-node is an accepted trade-off for a homelab

## What NOT to Do

- Do not add automation that hides what is happening
- Do not make scripts non-idempotent
- Do not store plaintext secrets anywhere (use SOPS)
- Do not bypass UFW or SSH hardening without explicit instruction
- Do not introduce unnecessary complexity (no Ansible, Chef, etc.)
