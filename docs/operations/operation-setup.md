# Operator Setup Guide

## Purpose

This document describes how to prepare an operator machine to access and manage the homelab.

An operator is any trusted person or device with administrative access.

---

## Prerequisites

- Linux or macOS
- OpenSSH >= 8.2
- age
- sops
- kubectl
- helm
- helmfile

---

## SSH Access

### Generate SSH key

Recommended options:

- Hardware-backed (YubiKey):

  ```console
  ssh-keygen -t ed25519-sk
  ```

- Software fallback:

  ```console
  ssh-keygen -t ed25519
  ```

### Install public key on server

Append the public key to:

```console
~/.ssh/authorized_keys
```

Verify access before proceeding.

---

## age & SOPS Setup

### Generate age key

```console
age-keygen -o ~/.config/age/key.txt
```

Set permissions:

```console
chmod 600 ~/.config/age/key.txt
```

### Export environment variable

```console
export SOPS_AGE_KEY_FILE=~/.config/age/key.txt
```

Persist this in your shell profile.

---

## Kubernetes Access

- Copy kubeconfig securely
- Restrict permissions:

  ```console
  chmod 600 kubeconfig
  ```

- Set context:

  ```console
  export KUBECONFIG=~/kubeconfig
  ```

---

## Security Notes

- Never commit private keys
- Never share kubeconfig files
- Use hardware-backed keys where possible
- Rotate keys regularly

---

## Summary

An operator machine is considered trusted.

Compromise of an operator machine is equivalent to full system compromise.
