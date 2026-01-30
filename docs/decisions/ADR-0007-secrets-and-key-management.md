# ADR-0007: Secrets Management and Key Strategy

## Status

Accepted

## Context

The homelab manages sensitive data, including:

- Application secrets
- Database credentials
- API tokens
- TLS-related material

Requirements:

- Secrets must never be stored in plaintext in Git
- Secrets must be manageable from multiple trusted machines
- Secrets must be usable both locally and in CI/CD environments
- Key rotation must be possible without redeploying the entire system

## Decision

Secrets are managed using:

- **SOPS** for encryption
- **age** as the encryption backend
- A small, controlled set of long-lived age keys

Secrets are stored encrypted in Git and decrypted only at deploy time.

## Rationale

### SOPS

SOPS allows:

- Version-controlled secrets
- Transparent encryption and decryption
- Integration with Helmfile and Kubernetes

### age

age was selected because:

- Simple key model
- Modern cryptography
- Minimal dependencies
- Easy distribution across machines

Each secret file is encrypted for one or more age public keys.

## Key Strategy

- One primary age key per operator
- Keys stored locally on trusted machines only
- Public keys committed to the repository
- Private keys never leave the operator machines

Environment variables are used to point tooling to the correct key material.

## Alternatives Considered

### GPG-based SOPS

Rejected due to:

- Higher operational complexity
- More fragile key management
- Difficult multi-device usage

### Kubernetes Secrets in Plaintext

Rejected due to:

- Lack of version control
- Poor auditability
- Increased risk of accidental exposure

### External Secret Managers

Rejected due to:

- Additional infrastructure
- Cloud dependencies
- Increased operational overhead

## Consequences

Positive:

- Secrets are safely stored in Git
- Deployments are reproducible
- Clear separation between encrypted data and keys

Negative:

- Requires discipline in key handling
- Initial setup effort on new machines

This trade-off is acceptable given the security benefits.
