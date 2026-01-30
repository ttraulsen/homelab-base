# Bootstrap Procedure

## Purpose

This document describes the complete bootstrap process for setting up the homelab from scratch.

It assumes:

- Fresh hardware
- No pre-existing configuration
- Full reinstallation as a valid recovery scenario

The goal is a reproducible, mostly automated setup.

---

## High-Level Bootstrap Flow

1. Prepare hardware and firmware
2. Install host operating system
3. Apply host-level configuration
4. Install Kubernetes
5. Configure access and secrets
6. Deploy infrastructure services
7. Deploy core applications
8. Verify system state

Each step builds on the previous one.

---

## 1. Hardware Preparation

- Connect the system to a UPS
- Ensure reliable network connectivity
- Update firmware if required
- Disable unused peripherals in BIOS
- Enable virtualization support

No RAID or complex storage configuration is required on the host.

---

## 2. Operating System Installation

- Install **Ubuntu Server LTS**
- Minimal installation
- Enable OpenSSH
- Use a single filesystem for the root disk
- Create a non-root user with sudo privileges

Post-installation:

- Apply system updates
- Reboot once before continuing

---

## 3. Host Configuration

All host-level configuration is managed via scripts in the `homelab-base` repository.

Typical responsibilities:

- Package installation and removal
- SSH hardening
- Time synchronization
- Firewall configuration
- Disable unnecessary services

The host should not run application workloads.

The configuration scripts are designed to be:

- Idempotent
- Re-runnable
- Safe to execute multiple times

---

## 4. Kubernetes Installation

Kubernetes is installed using **k3s**.

Key characteristics:

- Single-node cluster
- Embedded container runtime
- Minimal external dependencies

After installation:

- Verify cluster health
- Export kubeconfig for local use
- Restrict kubeconfig permissions

---

## 5. Access and Secrets Setup

This step establishes secure access for operators.

Includes:

- SSH key-based access
- age key installation
- SOPS configuration
- Environment variable setup

Secrets are never committed in plaintext.

Each operator machine must be prepared individually.

---

## 6. Infrastructure Deployment

Infrastructure services are deployed first.

Typical examples:

- Ingress controller
- cert-manager
- Authentication provider
- Storage integration

Deployment is performed using Helmfile:

- Preview changes
- Apply declaratively
- Verify readiness

Infrastructure must be stable before proceeding.

---

## 7. Core Application Deployment

Core applications are deployed next.

Characteristics:

- Persistent data
- User-facing services
- Backup coverage

Applications are deployed gradually and verified individually.

---

## 8. Verification

After deployment, verify:

- Kubernetes node readiness
- Ingress routing
- TLS certificate issuance
- Authentication flows
- Backup jobs

Any issues should be resolved before adding additional services.

---

## Automation Notes

The bootstrap process is designed to evolve:

- Initial runs may involve manual steps
- Scripts should gradually replace manual actions
- The final goal is a single-command bootstrap

Documentation must be updated whenever the process changes.

---

## Recovery Considerations

This bootstrap procedure is also the primary recovery path.

If the system cannot be repaired in place:

- Reinstall the host
- Re-run bootstrap
- Restore data from backups

A system that cannot be rebuilt is considered broken by design.

---

## Summary

The bootstrap process prioritizes:

- Clarity over speed
- Reproducibility over convenience
- Explicit steps over hidden automation

This ensures long-term maintainability of the homelab.
