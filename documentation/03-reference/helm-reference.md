---
title: "Helm reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# Helm reference

## Scope

- **In scope:** core Helm commands, release lifecycle, chart/value inspection, common flags.
- **Out of scope:** chart authoring deep dive, Helm plugins catalog, vendor-specific charts.

## Cheat sheet

| Task | Command |
|---|---|
| List releases | `helm ls -A` |
| Release status | `helm status <release> -n <ns>` |
| Release history | `helm history <release> -n <ns>` |
| Install/upgrade | `helm upgrade --install <release> <chart> -n <ns> -f values.yaml` |
| Rollback | `helm rollback <release> <rev> -n <ns>` |
| Uninstall | `helm uninstall <release> -n <ns>` |
| Show chart metadata | `helm show chart <chart>` |
| Show default values | `helm show values <chart>` |
| Render templates | `helm template <release> <chart> -n <ns> -f values.yaml` |

## Quick start (minimal)

```bash
helm ls -A
```

## Interfaces

### CLI commands

#### `helm repo`

```bash
helm repo add <name> <url>
helm repo update
helm search repo <term>
```

#### `helm show`

```bash
helm show chart <chart>
helm show values <chart>
```

#### `helm upgrade` / `helm install`

```bash
helm upgrade --install <release> <chart> -n <ns> -f values.yaml
```

High-value flags:

| Flag | Description |
|---|---|
| `--namespace <ns>` / `-n <ns>` | target namespace |
| `--create-namespace` | create namespace if missing |
| `--version <ver>` | pin chart version |
| `--timeout <dur>` | wait timeout |
| `--atomic` | rollback on failure (use intentionally) |
| `--dry-run` | simulate (still renders; does not persist) |

#### `helm rollback`

```bash
helm rollback <release> <revision> -n <ns>
```

#### `helm uninstall`

```bash
helm uninstall <release> -n <ns>
```

### Configuration

#### Common concepts

| Term | Meaning |
|---|---|
| chart | templates + defaults packaged for reuse |
| release | installed chart instance with revision history |
| values | configuration input used to render templates |

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `HELM_CACHE_HOME` | no | (varies) | cache location |
| `HELM_CONFIG_HOME` | no | (varies) | config location |
| `HELM_DATA_HOME` | no | (varies) | data location |

## Best Practices

- Keep Reference safe and scannable; link multi-step operations to the How-to guide.
- Pin versions and review rendered output before applying.
- Avoid unsafe suggestions like disabling TLS verification in examples.

## Security

### Authentication and authorization

- Helm uses your kubeconfig identity; cluster RBAC controls what it can create.

### Secrets handling

- Values files may contain secrets; avoid committing them unless encrypted/approved.

## Observability

```bash
helm status <release> -n <ns>
kubectl -n <ns> get events --sort-by=.lastTimestamp | tail -n 50
```

## Compatibility

- Chart behavior varies by chart version and Kubernetes version; pin and promote versions.

## Limits and known behaviors

- Helm rendering is local; the cluster still enforces admission/RBAC and may reject resources.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

