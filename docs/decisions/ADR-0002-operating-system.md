# ADR-0002: Operating System Selection

## Status

Accepted

## Context

The host operating system is responsible for:

- Running a single-node Kubernetes cluster
- Providing long-term stability
- Receiving timely security updates
- Being well-documented and widely supported
- Allowing reproducible reinstallation and upgrades

The system is intended to run unattended for long periods and should require minimal manual intervention.

## Decision

Ubuntu Server LTS was selected as the host operating system.

## Rationale

Ubuntu Server LTS provides:

- Predictable long-term support (5 years)
- Frequent security updates
- Excellent hardware compatibility
- Large community and documentation ecosystem
- First-class support for Kubernetes tooling

Using a widely adopted distribution reduces operational risk and simplifies troubleshooting.

## Alternatives Considered

### NixOS

Rejected due to:

- Higher initial complexity
- Steep learning curve
- Increased risk during early homelab stages

NixOS remains a potential future option.

### Debian Stable

Rejected due to:

- Slower update cadence
- Slightly older kernel and packages

### BSD (e.g. OpenBSD)

Rejected due to:

- Limited Kubernetes ecosystem support
- Different operational model
- Higher friction for container workloads

## Consequences

Positive:

- Stable and predictable base system
- Easy automation and scripting
- Straightforward upgrade path between LTS releases

Negative:

- Less declarative than NixOS
- Requires discipline to keep host configuration minimal

This trade-off is acceptable for the current goals.
