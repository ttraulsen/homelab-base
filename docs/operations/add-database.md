# Adding a New PostgreSQL Database

## Purpose

This document describes how to add a new database and user to the shared PostgreSQL instance
for a new application.

The shared PostgreSQL instance runs in the `database` namespace and is managed via
`homelab-k8s-apps/postgres/`. Each application gets its own database and a dedicated user
with access limited to that database.

---

## Overview

Adding a database involves two parts:

1. **Add credentials** to the secrets chart so a password exists in the `postgres-credentials` secret.
2. **Create the database and user** — either manually on a running cluster, or by updating the
   init script for future fresh installations.

---

## Step 1 — Add the password to the secrets chart

Edit `homelab-k8s-apps/secrets-chart/secrets.yaml` (decrypt first if encrypted):

```bash
sops secrets-chart/secrets.yaml
```

Add a new key under `postgres-credentials.data`:

```yaml
secrets:
  postgres-credentials:
    namespace: database
    data:
      adminPassword: "..."
      authentikPassword: "..."
      vaultwardenPassword: "..."
      myappPassword: "your-new-password-here"   # add this
```

Re-encrypt and deploy the secrets chart:

```bash
sops -e secrets-chart/secrets.yaml > secrets-chart/secrets.sops.yaml
helmfile sync --selector app=secrets-chart
```

---

## Step 2 — Create the database on the running cluster

The PostgreSQL `initdb` scripts only run on first-time initialisation (empty data directory).
For a running cluster, create the user and database manually:

```bash
kubectl exec -n database -it deploy/postgres -- psql -U postgres
```

Then in the psql shell:

```sql
CREATE USER myapp WITH PASSWORD 'your-new-password-here';
CREATE DATABASE myapp OWNER myapp;
\q
```

Verify:

```bash
kubectl exec -n database -it deploy/postgres -- psql -U postgres -c "\l"
kubectl exec -n database -it deploy/postgres -- psql -U postgres -c "\du"
```

---

## Step 3 — Update the init script for future fresh installations

Edit `homelab-k8s-apps/postgres/values.yaml` to include the new database in the init script.
This ensures it is created automatically if the cluster is ever rebuilt from scratch.

Add an `IF NOT EXISTS` branch inside the `DO` block:

```yaml
psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authentik') THEN
            CREATE USER authentik WITH PASSWORD '${authentikPassword}';
        END IF;
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'vaultwarden') THEN
            CREATE USER vaultwarden WITH PASSWORD '${vaultwardenPassword}';
        END IF;
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'myapp') THEN
            CREATE USER myapp WITH PASSWORD '${myappPassword}';
        END IF;
    END
    \$\$;
EOSQL
```

Note: `CREATE USER IF NOT EXISTS` is not valid PostgreSQL syntax. The `DO` block is required
for idempotency. `\$\$` must be escaped so bash does not expand `$$` to the current PID.

Add the database name to the `for` loop:

```yaml
for db in authentik vaultwarden myapp; do
```

The variable `${myappPassword}` is automatically available because `extraEnvVarsSecret: postgres-credentials`
exposes all keys from that secret as environment variables in the PostgreSQL pod.

---

## Step 4 — Configure the new application

In the application's `values.yaml`, point it at the shared PostgreSQL instance:

```yaml
env:
  - name: DATABASE_URL
    value: "postgresql://myapp:$(MYAPP_DB_PASSWORD)@postgres.database.svc.cluster.local/myapp"
  - name: MYAPP_DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: postgres-credentials
        key: myappPassword
```

Or using individual connection parameters if the application requires them:

```yaml
database:
  host: postgres.database.svc.cluster.local
  port: 5432
  name: myapp
  user: myapp
  password:
    valueFrom:
      secretKeyRef:
        name: postgres-credentials
        key: myappPassword
```

---

## Notes

- **Naming convention:** database name, username, and secret key all follow the pattern of the
  application name (e.g. application `myapp` → database `myapp`, user `myapp`, key `myappPassword`).
- **User isolation:** each user only has access to its own database. No cross-database access is granted.
- **The init script is idempotent** — safe to re-run on a fresh installation. It will not fail
  if users or databases already exist.
- **Step 2 is always required for a live cluster.** Updating `postgres/values.yaml` alone does
  not create the database in an already-running PostgreSQL instance.
