# ADR-0004: Deployment and GitOps Strategy

## Status

Accepted

## Context

The homelab requires a deployment workflow that:

- Is understandable and debuggable
- Allows manual control during early stages
- Can evolve into automated GitOps later
- Avoids unnecessary operational complexity

The operator prefers transparency over full automation.

## Decision

Helmfile is used as the primary deployment mechanism, executed manually at first.

## Rationale

Helmfile allows:

- Declarative management of Helm releases
- Clear diffs before applying changes
- Familiar tooling
- Easy local execution

Manual execution ensures full understanding of system behavior before introducing automation.

## Alternatives Considered

### FluxCD

Rejected initially due to:

- Increased operational complexity
- Additional controllers and RBAC
- Debugging happening inside the cluster

Flux remains a future option once the system stabilizes.

### ArgoCD

Rejected due to:

- UI-centric workflow
- Higher resource usage
- Overhead not justified for a homelab

## Consequences

Positive:

- Full control over deployments
- Easy troubleshooting
- Simple mental model

Negative:

- No automatic reconciliation
- Requires manual deployment steps

This trade-off is intentional during early stages.
