---
title: "Helm how-to: operate releases safely (diff, upgrade, rollback, uninstall)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# Helm how-to: operate releases safely (diff, upgrade, rollback, uninstall)

## Summary

- **Outcome:** Perform common Helm operations with evidence, safe previews, and rollback readiness.
- **Use when:** You manage a chart-based workload (install/upgrade/rollback).
- **Do not use when:** Your org forbids direct Helm operations (GitOps-only) except break-glass.
- **Time / effort:** 5-60 minutes
- **Risk level:** medium (upgrades can change many resources)

## Cheat sheet

### Pre-flight

```bash
kubectl config current-context
kubectl config view --minify
helm ls -A
```

### Render + preview

```bash
helm show values <chart> > values-default.yaml
helm template <release> <chart> -n <ns> -f values.yaml > rendered.yaml
```

If you have `helm diff` plugin:

```bash
helm diff upgrade <release> <chart> -n <ns> -f values.yaml
```

### Upgrade (idempotent)

```bash
helm upgrade --install <release> <chart> -n <ns> -f values.yaml
helm history <release> -n <ns>
```

### Rollback

```bash
helm rollback <release> <revision> -n <ns>
helm history <release> -n <ns>
```

## Preconditions

### Required access

- kubeconfig access
- RBAC to create/update/delete resources in the target namespace

### Required inputs

- Ticket/change: `<ID>`
- Target context: `<context>`
- Namespace: `<ns>`
- Release name: `<release>`
- Chart reference + version: `<repo>/<chart>@<version>` (recommended)
- Values file(s): `<values.yaml>`

### Required tools

- `helm`
- `kubectl`
- Optional: `helm diff` plugin

## Safety

### Impact and blast radius

- **Impact:** Helm can update many resources per upgrade (Deployments, Services, RBAC, CRDs depending on chart).
- **Blast radius:** namespace-scoped releases are safer; cluster-scoped resources increase blast radius.

### Preconditions for running in `prod`

- [ ] Confirm context + namespace + release name
- [ ] Confirm chart version is pinned
- [ ] Preview rendered output / diff
- [ ] Rollback revision identified and documented
- [ ] Monitoring open; verification checklist ready

### Rollback plan (required)

**Rollback triggers**

- Rollout fails or stalls
- Key metrics regress
- Functional checks fail

**Rollback steps (high-level)**

1. Roll back to last known good revision with `helm rollback`.
2. Verify workloads and metrics.
3. Capture evidence and follow up with root cause analysis.

**Rollback validation**

- `helm history` shows rollback and workloads are healthy.

## Procedure

### 1) Identify the current state

```bash
helm ls -n <ns>
helm status <release> -n <ns>
helm history <release> -n <ns>
```

### 2) Preview changes

```bash
helm template <release> <chart> -n <ns> -f values.yaml > rendered.yaml
```

If you have `helm diff`:

```bash
helm diff upgrade <release> <chart> -n <ns> -f values.yaml
```

### 3) Upgrade safely

```bash
helm upgrade --install <release> <chart> -n <ns> -f values.yaml
helm history <release> -n <ns>
```

### 4) Verify

```bash
kubectl -n <ns> get pods
kubectl -n <ns> get events --sort-by=.lastTimestamp | tail -n 50
```

Add workload-specific checks (health endpoints, synthetic requests, dashboards).

### 5) Closeout

- [ ] Record chart version, values diff, and final revision.
- [ ] Record verification evidence and timestamps.

## Troubleshooting

### If an upgrade changes immutable fields

- Some objects must be re-created; charts vary in behavior.
- Avoid `--force` unless you understand the impact and have rollback.

## Best Practices

- Pin chart versions and promote them across environments deliberately.
- Keep `values.yaml` minimal and reviewed; avoid ad-hoc CLI `--set` in prod.
- Treat CRDs carefully; prefer dedicated CRD install steps if required by your org.
- Prefer GitOps for long-lived management; use Helm CLI as a tool, not a source of truth.

## Notes / exceptions

- Some charts install cluster-scoped resources (CRDs, ClusterRoles). Review them explicitly.

## References

- `ops-scripts/documentation/03-reference/helm-reference.md`
- `ops-scripts/documentation/04-explanation/helm-how-it-works.md`

