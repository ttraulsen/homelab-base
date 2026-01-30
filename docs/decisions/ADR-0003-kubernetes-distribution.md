# ADR-0003: Kubernetes Distribution

## Status

Accepted

## Context

The homelab requires Kubernetes to:

- Run on a single node
- Use minimal system resources
- Be easy to install and upgrade
- Integrate well with standard Kubernetes tooling

The cluster is primarily intended for personal and family services, not production-grade high availability.

## Decision

k3s was selected as the Kubernetes distribution.

## Rationale

k3s provides:

- Lightweight footprint
- Simple installation
- Bundled components (container runtime, networking)
- Full Kubernetes API compatibility
- Strong community adoption

It is well-suited for edge and homelab environments.

## Alternatives Considered

### kubeadm

Rejected due to:

- Higher operational complexity
- Manual management of cluster components

### MicroK8s

Rejected due to:

- Snap-based packaging
- Less transparent configuration
- Tighter coupling to Ubuntu

### Docker Compose

Rejected due to:

- Lack of Kubernetes abstractions
- Limited scalability and portability

## Consequences

Positive:

- Low memory and CPU usage
- Fast cluster startup
- Familiar Kubernetes workflows

Negative:

- Single-node cluster
- Some bundled defaults require understanding and tuning

This is acceptable for the intended environment.
