# ADR-0001: Hardware Platform Selection

## Status

Accepted

## Context

The homelab requires a hardware platform that:

- Is energy efficient (24/7 operation)
- Provides sufficient performance for Kubernetes workloads
- Is affordable and available on the used market
- Is quiet and suitable for a home environment
- Supports future growth (memory, storage)

The system will run a Kubernetes cluster with:

- Core infrastructure services
- Stateful applications
- Media-related workloads
- Home automation integrations

## Decision

A Lenovo ThinkCentre M625Q Thin Client was selected with the following configuration:

- AMD E2-9000E CPU
- 16 GB RAM
- 512 GB NVMe SSD
- External NAS for bulk storage

## Rationale

Reasons for this choice:

- Very low power consumption compared to traditional servers
- Sufficient CPU and memory for a single-node Kubernetes cluster
- Widely available and inexpensive on the used market
- Compact, silent form factor
- NVMe support allows fast local storage for system workloads

The NAS remains responsible for:

- Large file storage
- Media files
- Backup targets

## Alternatives Considered

### Dedicated Server Hardware

Rejected due to:

- Higher power consumption
- Noise
- Overkill for the intended workload

### Raspberry Pi Cluster

Rejected due to:

- Operational complexity
- Limited IO performance
- ARM-specific compatibility issues

### Cloud-only Setup

Rejected due to:

- Recurring costs
- Privacy concerns
- Dependence on external providers

## Consequences

Positive:

- Low operational cost
- Simple physical setup
- Good balance between performance and efficiency

Negative:

- Single-node cluster (no high availability)
- Limited CPU headroom for very heavy workloads

This trade-off is acceptable for the intended use case.

## HomeAssistant

The existing Raspberry Pi will still run HomeAssistant because it needs close compatibility to the hardware.
The combination of HomeAssistant and Raspberry is proven.
I can move the special addons which currently run inside HomeAssistant (Influx, Grafana, ...) to run inside the k8s cluster.
