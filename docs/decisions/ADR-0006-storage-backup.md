# ADR-0006: Storage and Backup Strategy

## Status

Accepted

## Context

The homelab hosts a mix of workloads with different storage characteristics:

- Kubernetes system components
- Stateful applications (e.g. authentication, photo library)
- Large media files
- Backups and long-term retention data

Key requirements:

- Clear separation between system and bulk storage
- Low operational complexity
- Data durability beyond a single machine
- Encrypted offsite backups
- Compatibility with Kubernetes workloads

## Decision

A multi-tier storage strategy is used:

1. **Local NVMe storage on the host**
   - Used for the operating system
   - Kubernetes components
   - Fast-access application data

2. **External NAS (Synology DS414)**
   - Used for bulk storage
   - Media files (photos, videos)
   - Persistent application data that does not require high IOPS

3. **Offsite backups to Hetzner Storage**
   - Encrypted backups of NAS and critical application data
   - Regular, automated backup jobs

## Rationale

### Local Storage

Local NVMe storage provides:

- Low latency
- High throughput
- Independence from network availability

It is suitable for:

- Kubernetes control plane components
- Databases with moderate size
- Caches and temporary data

### NAS Storage

The existing NAS remains in use because:

- It already provides redundancy
- It is optimized for large data volumes
- It separates bulk data from the Kubernetes node

Mounting NAS storage into Kubernetes allows:

- Reuse of existing infrastructure
- Easier capacity expansion
- Reduced wear on local SSDs

### Offsite Backups

Offsite backups are required to protect against:

- Hardware failure
- Accidental deletion
- Catastrophic local events

Hetzner Storage was chosen due to:

- Predictable pricing
- Good performance
- Compatibility with standard backup tools

All backups are encrypted before leaving the local network.

## Alternatives Considered

### Local Storage Only

Rejected due to:

- Single point of failure
- Limited storage capacity
- Difficult recovery after hardware failure

### Cloud-Native Storage (S3-first)

Rejected due to:

- Higher recurring costs
- Increased latency
- Stronger dependency on external providers

### Fully Kubernetes-native Storage (Ceph, Longhorn)

Rejected due to:

- Operational complexity
- Resource overhead
- Limited benefit for a single-node cluster

## Consequences

Positive:

- Clear responsibility separation between storage layers
- Efficient use of existing hardware
- Improved data safety through offsite backups

Negative:

- Requires managing NAS mounts
- Backup processes must be monitored

These trade-offs are acceptable for the intended use case.
