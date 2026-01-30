# Homelab Architecture Overview

## Purpose

This document provides a high-level overview of the homelab architecture.

It is intended to:

- Explain how the system fits together
- Show clear responsibility boundaries
- Provide a mental model for future changes
- Support recovery and reinstallation scenarios

Detailed configuration and implementation details are documented elsewhere.

---

## High-Level Overview

The homelab is built around a **single-node Kubernetes cluster** running on dedicated hardware at home.

The architecture follows a layered approach:

1. Hardware and host operating system
2. Kubernetes base infrastructure
3. Core applications
4. Optional and experimental services
5. External dependencies and backups

Each layer is designed to be as independent as possible.

---

## Hardware and Host Layer

The physical base consists of:

- A low-power thin client acting as the main compute node
- An external NAS for bulk storage
- A UPS for controlled shutdowns

Responsibilities of this layer:

- Provide stable compute resources
- Handle power and storage reliability
- Remain mostly static over time

The host operating system is kept minimal and only runs:

- Kubernetes
- Essential system services
- Monitoring and management tools

All application logic runs inside Kubernetes.

---

## Kubernetes Layer

Kubernetes acts as the central abstraction layer.

Key characteristics:

- Single-node cluster
- k3s distribution
- No high-availability guarantees

Kubernetes is responsible for:

- Service lifecycle management
- Networking between services
- Resource isolation
- Declarative application deployment

The cluster is intentionally simple and avoids advanced features that provide little value in a homelab context.

---

## Infrastructure Services

Infrastructure services are deployed inside Kubernetes and provide shared functionality.

Examples include:

- Ingress controller
- Certificate management
- Authentication and identity provider
- Monitoring and status services
- Storage integration

These services are considered **foundational** and are required for most applications to function.

They are managed separately from application workloads.

---

## Application Layer

Applications are grouped into two categories:

### Core Applications

These are services used regularly by the household, such as:

- Authentication and identity management
- Photo library and media services
- Dashboards and status pages
- Home automation integrations

Core applications are expected to be:

- Stable
- Backed up
- Documented
- Maintained long-term

### Additional Applications

These include:

- Experimental services
- Media-related tooling
- Optional utilities

They are isolated from core applications and can be removed without affecting the overall system.

---

## Storage Architecture

Storage is split across multiple tiers:

- Local NVMe storage for system and fast-access data
- NAS storage for large and persistent datasets
- Offsite encrypted backups for disaster recovery

This separation ensures:

- Efficient resource usage
- Clear ownership of data
- Reduced blast radius in case of failures

Applications explicitly declare which storage tier they depend on.

---

## Networking and Access

External access follows these principles:

- Centralized ingress routing
- Automatic TLS certificate management
- Minimal public exposure
- VPN-based access for administrative services

DNS is dynamically updated to handle changing public IP addresses.

Internally, services communicate using Kubernetes networking without relying on external access paths.

---

## Secrets and Configuration

Secrets and configuration data are handled separately:

- Configuration is stored in Git
- Secrets are encrypted before entering Git
- Decryption only happens at deploy time

This ensures:

- Reproducibility
- Auditability
- Reduced risk of secret leakage

---

## Deployment Model

Deployments follow a Git-centric workflow:

- Declarative configuration stored in Git
- Helmfile used to manage releases
- Manual execution during early stages

This approach favors:

- Transparency
- Easy debugging
- Gradual evolution toward automation

Full GitOps automation remains an option for the future.

---

## External Dependencies

The homelab intentionally minimizes external dependencies.

Current external services include:

- Domain provider and DNS
- Offsite backup storage
- Certificate authorities

The system is designed to continue functioning locally even if some external services are temporarily unavailable.

---

## Design Principles

The architecture is guided by the following principles:

- Prefer simplicity over cleverness
- Optimize for understanding, not maximum automation
- Accept single points of failure where appropriate
- Document decisions and trade-offs explicitly

This homelab is not a production system, but it is treated with production-level care where it matters.

---

## Summary

The homelab architecture balances:

- Reliability and pragmatism
- Learning and stability
- Automation and control

It is intentionally conservative, evolvable, and well-documented.

Future changes are expected and planned for.
