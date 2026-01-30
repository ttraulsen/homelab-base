# ADR-0005: Authentication and Identity Management

## Status

Accepted

## Context

The homelab hosts multiple services accessed by family members.

Requirements include:

- Central user management
- Support for Single Sign-On
- Compatibility with modern authentication methods
- Low maintenance overhead

## Decision

Authentik is used as the central identity provider.

## Rationale

Authentik provides:

- Modern SSO protocols (OIDC, OAuth2, SAML)
- Support for passkeys and hardware tokens
- Good Kubernetes integration
- Active development and documentation

It balances feature richness with usability.

## Alternatives Considered

### Keycloak

Rejected due to:

- Higher operational complexity
- Heavier resource usage

### Authelia

Rejected due to:

- More limited identity management features
- Less suitable as a central IdP

### Individual Service Accounts

Rejected due to:

- Poor user experience
- Difficult credential management

## Consequences

Positive:

- Centralized authentication
- Improved user experience
- Easier onboarding for family members

Negative:

- Additional service to maintain
- Requires backup and recovery planning

This is acceptable given its central role.
