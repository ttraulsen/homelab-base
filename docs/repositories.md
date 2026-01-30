# Repository Structure

The homelab is split into multiple repositories to reduce coupling and cognitive load.

## homelab-base

Host setup, documentation, bootstrap and recovery procedures.

## homelab-k8s-infra

Kubernetes-level infrastructure:

- Ingress
- Cert-manager
- Storage
- Monitoring

## homelab-k8s-apps

Core applications required for daily usage.

## homelab-k8s-apps-additional

Optional or experimental applications.

This separation allows:

- Clear ownership boundaries
- Easier recovery
- Selective sharing of repositories
