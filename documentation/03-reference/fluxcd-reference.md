---
title: "FluxCD reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# FluxCD reference

## Scope

- **In scope:** common Flux objects (sources, kustomizations, helmreleases) and high-signal commands for operations.
- **Out of scope:** provider-specific bootstrap details, full CRD schemas, advanced multi-tenancy patterns.

## Cheat sheet

| Task | Command |
|---|---|
| Sanity check install | `flux check` |
| Get all Flux resources | `flux get all -A` |
| Force reconcile source | `flux reconcile source git <name> -n <ns>` |
| Force reconcile kustomization | `flux reconcile kustomization <name> -n <ns>` |
| Force reconcile helmrelease | `flux reconcile helmrelease <name> -n <ns>` |
| Suspend/resume | `flux suspend kustomization <name> -n <ns>` / `flux resume kustomization <name> -n <ns>` |
| Controller errors | `flux logs --level=error --all-namespaces` |

## Quick start (minimal)

```bash
flux get all -A
```

## Interfaces

### CLI commands

#### `flux check`

```bash
flux check
```

#### `flux get`

```bash
flux get sources git -A
flux get kustomizations -A
flux get helmreleases -A
```

#### `flux reconcile`

```bash
flux reconcile source git <name> -n <ns>
flux reconcile kustomization <name> -n <ns>
flux reconcile helmrelease <name> -n <ns>
```

#### `flux suspend` / `flux resume`

```bash
flux suspend kustomization <name> -n <ns>
flux resume kustomization <name> -n <ns>
```

### Configuration

#### Concepts (common CRDs)

| Object | Purpose |
|---|---|
| `GitRepository` | defines a Git source and revision polling |
| `Kustomization` | applies manifests from a source path |
| `HelmRepository` | defines a Helm chart source |
| `HelmRelease` | declares desired chart + values and reconciles it |

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `<none>` | no | n/a | (none required for basic usage) |

## Best Practices

- Keep Reference safe and scannable; link procedures to How-to docs.
- Standardize namespaces and naming for Flux objects.
- Prefer Git-driven rollback; limit `suspend/resume` to operational control.

## Security

### Authentication and authorization

- Git access is typically via deploy keys/tokens; treat them as secrets.
- RBAC should restrict who can change Flux objects in production clusters.

### Secrets handling

- Avoid committing secrets in Git; use an approved secret management pattern.

## Observability

```bash
flux logs --level=error --all-namespaces
kubectl -n flux-system get pods
```

## Compatibility

- Flux behavior depends on version; keep controller versions consistent across clusters.

## Limits and known behaviors

- Flux reconciles on intervals; use `reconcile` to force convergence.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

