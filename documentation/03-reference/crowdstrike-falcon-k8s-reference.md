---
title: "CrowdStrike Falcon on Kubernetes reference (admission + sensor)"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# CrowdStrike Falcon on Kubernetes reference (admission + sensor)

## Scope

- **In scope:** operational checks, Kubernetes objects to inspect, and safe patterns for admission controllers and node sensors.
- **Out of scope:** exact CrowdStrike product install commands, chart names, image tags, and licensing-specific behavior (use official CrowdStrike docs for those).

## Cheat sheet

| Task | Command |
|---|---|
| Find Falcon namespaces | `kubectl get ns | rg -n "falcon|crowdstrike"` |
| List Falcon workloads | `kubectl -n <falcon_ns> get deploy,ds,svc,pods` |
| Check webhook configs | `kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | rg -n "falcon|crowdstrike"` |
| Describe a webhook | `kubectl describe validatingwebhookconfiguration <name>` |
| Admission errors | `kubectl get events -A --sort-by=.lastTimestamp | tail -n 100` |
| DaemonSet coverage | `kubectl -n <falcon_ns> get ds; kubectl -n <falcon_ns> describe ds <ds>` |
| Pod logs | `kubectl -n <falcon_ns> logs <pod> --tail=200` |

## Quick start (minimal)

```bash
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | rg -n "falcon|crowdstrike" || true
```

## Interfaces

### Kubernetes objects to know

| Object | Purpose |
|---|---|
| `ValidatingWebhookConfiguration` / `MutatingWebhookConfiguration` | admission webhooks and their scope |
| `Deployment` | admission controller workload |
| `DaemonSet` | node sensor agent workload |
| `Secret` | credentials/config (treat as sensitive) |
| `Service` | webhook endpoint and cluster access |

### Admission webhook fields (high value)

| Field | Why it matters |
|---|---|
| `namespaceSelector` | determines which namespaces are affected |
| `objectSelector` | targets specific objects/labels |
| `failurePolicy` | fail-open vs fail-closed behavior |
| `timeoutSeconds` | too low causes flakiness; too high increases API latency |
| `sideEffects` | impacts dry-run and behavior expectations |

### DaemonSet rollout fields (high value)

| Field | Why it matters |
|---|---|
| `nodeSelector` | canary or exclude unsupported pools |
| `tolerations` | schedule on tainted nodes |
| `resources` | prevent node pressure |
| `securityContext` | privileged requirements can conflict with policy |

### Configuration

#### Naming and ownership (recommended)

- Namespace: `<falcon_ns>` (example: `falcon-system`)
- Release names: `<falcon-admission>`, `<falcon-sensor>`
- Values/config stored in Git at: `<repo/path>`

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `<vendor-defined>` | varies | varies | prefer values files + secrets over env vars when possible |

## Best Practices

- Keep Reference scannable; keep exact install commands in your internal runbooks or official vendor docs.
- Stage admission rollouts: small scope -> observe -> expand -> enforce.
- Canary node sensor rollouts: one pool -> expand -> all supported nodes.
- Treat secrets and tenant IDs as sensitive; do not paste into tickets/docs unless approved and redacted.

## Security

### Authentication and authorization

- Admission controllers require cluster-scoped permissions; apply least privilege where possible.
- Node sensors often require elevated privileges; assess with security baseline and policy exceptions.

### Secrets handling

- Store credentials in Kubernetes Secrets or an approved secret manager integration.
- Avoid committing secrets in Git unless using an approved encrypted workflow.

## Observability

```bash
kubectl -n <falcon_ns> get pods
kubectl -n <falcon_ns> get events --sort-by=.lastTimestamp | tail -n 50
kubectl get events -A --sort-by=.lastTimestamp | tail -n 50
```

## Compatibility

- Validate support across Kubernetes versions, OS/arch, and container runtimes per official CrowdStrike docs.

## Limits and known behaviors

- Admission webhook misconfiguration can block workload changes cluster-wide.
- Sensors may not run on unsupported OS/arch pools; use selectors and tolerations deliberately.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

