# ADR-0008: Networking and Remote Access

## Status

Accepted

## Context

The homelab runs on a residential internet connection with:

- Dynamic public IP addresses
- NAT-based routing
- Limited control over upstream networking

Requirements:

- Secure access to services from outside the home network
- Minimal exposure of internal services
- Automatic TLS certificate management
- Support for family-friendly access patterns

## Decision

The following networking strategy is used:

- Kubernetes Ingress for HTTP(S) traffic
- cert-manager with Let's Encrypt for TLS certificates
- Dynamic DNS via the domain provider
- VPN-based access for administrative and sensitive services

## Rationale

### Ingress

Ingress provides:

- Centralized traffic routing
- TLS termination
- Simple service exposure via hostnames

It keeps application configuration independent of network details.

### TLS via cert-manager

cert-manager automates:

- Certificate issuance
- Renewal
- Validation

This removes the need for manual certificate management.

### Dynamic DNS

Dynamic DNS ensures:

- Stable hostnames despite changing public IPs
- Minimal manual intervention
- Compatibility with residential connections

### VPN Access

VPN access is used for:

- Administrative interfaces
- Internal-only services
- Maintenance and troubleshooting

This limits public exposure and improves security.

## Alternatives Considered

### Exposing Services Directly via Port Forwarding

Rejected due to:

- Increased attack surface
- Poor scalability
- Manual certificate handling

### Cloud-based Reverse Proxies

Rejected due to:

- External dependency
- Privacy concerns
- Additional latency

### Service Mesh

Rejected due to:

- High complexity
- Resource overhead
- Limited benefit for the use case

## Consequences

Positive:

- Secure and manageable external access
- Automated TLS handling
- Clear separation between public and private services

Negative:

- Requires maintaining DNS updates
- VPN adds an extra access step for some services

These trade-offs are acceptable for a home environment.
