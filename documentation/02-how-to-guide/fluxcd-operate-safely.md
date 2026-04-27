---
title: "FluxCD how-to: operate GitOps safely (reconcile, suspend, rollback, debug)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# FluxCD how-to: operate GitOps safely (reconcile, suspend, rollback, debug)

## Summary

- **Outcome:** Perform common FluxCD operations safely: reconcile, suspend/resume, rollback via Git, and debug failed syncs.
- **Use when:** You are responsible for a Flux-managed cluster or environment.
- **Do not use when:** Your org prohibits direct controller operations (e.g., only CI triggers) or uses another GitOps tool.
- **Time / effort:** 5-60 minutes
- **Risk level:** medium (GitOps changes can affect many resources)

## Cheat sheet

### Pre-flight

```bash
kubectl config current-context
kubectl config view --minify
flux check
flux get all -A
```

### Reconcile now

```bash
flux reconcile source git <name> -n <ns>
flux reconcile kustomization <name> -n <ns>
flux reconcile helmrelease <name> -n <ns>
```

### Pause/resume

```bash
flux suspend kustomization <name> -n <ns>
flux resume kustomization <name> -n <ns>
```

### Debug

```bash
flux logs --level=error --all-namespaces
kubectl -n flux-system get pods
```

## Preconditions

### Required access

- kubeconfig access to the cluster
- RBAC to read Flux resources and logs; write permissions if you will suspend/resume

### Required inputs

- Ticket/incident: `<ID>`
- Target context/cluster: `<context>`
- Affected Flux objects: `<gitrepository>`, `<kustomization>`, `<helmrelease>`

### Required tools

- `kubectl`
- `flux` CLI

## Safety

### Impact and blast radius

- **Impact:** GitOps controllers may apply/roll back changes across namespaces.
- **Blast radius:** depends on how your Kustomizations/HelmReleases are scoped.

### Preconditions for running in `prod`

- [ ] Confirm context + cluster identity
- [ ] Confirm which Kustomization/HelmRelease controls the affected resources
- [ ] Confirm rollback path (Git revert / prior release revision)
- [ ] Monitoring/alerting open

### Rollback plan (required)

**Rollback triggers**

- Health checks fail after a change
- Error rate/latency spikes
- Rollout stalls

**Rollback steps (high-level)**

1. Revert the Git commit(s) that introduced the change.
2. Reconcile the affected Kustomization/HelmRelease.
3. Verify recovery.

**Rollback validation**

- Flux reports healthy and workloads are stable.

## Procedure

### 1) Identify what Flux thinks is happening

```bash
flux get all -A
flux get kustomizations -A
flux get sources git -A
flux get helmreleases -A
```

Capture:

- name/namespace of the failing object
- last applied revision (commit SHA/chart version)
- current status/error message

### 2) Reconcile safely

Prefer reconciling the smallest object that should converge the system.

```bash
flux reconcile source git <name> -n <ns>
flux reconcile kustomization <name> -n <ns>
```

If Helm-managed:

```bash
flux reconcile helmrelease <name> -n <ns>
```

### 3) Pause if you need to stop churn

If the controller is repeatedly applying a bad change, suspend it while you fix Git.

```bash
flux suspend kustomization <name> -n <ns>
```

Fix the repo (revert or correct manifests), push, and resume:

```bash
flux resume kustomization <name> -n <ns>
flux reconcile kustomization <name> -n <ns>
```

### 4) Debug failures

Start from the status message, then look at logs:

```bash
flux logs --level=error --all-namespaces
kubectl -n flux-system get pods
kubectl -n flux-system logs deploy/<controller> --tail=200
```

## Troubleshooting

### Git source fails

```bash
flux get sources git -A
kubectl -n flux-system describe gitrepository <name>
```

Common causes:

- auth/deploy key revoked
- repo moved/renamed
- branch/path mismatch

### Kustomization apply fails

Common causes:

- invalid YAML/schema
- missing CRDs
- RBAC denies writes

```bash
kubectl -n flux-system describe kustomization <name>
flux logs --all-namespaces --level=error
```

## Best Practices

- Roll forward/rollback via Git whenever possible; keep manual overrides to break-glass only.
- Keep Kustomizations scoped to a clear owner/team and a clear path in Git.
- Use health checks; require them to be green before promotion.
- Standardize naming so you can quickly map "what controls what".

## Notes / exceptions

- If your org uses GitOps promotion across environments, reconcile should follow the promotion gate (merge/tag) not be used to bypass it.

## References

- `ops-scripts/documentation/03-reference/fluxcd-reference.md`
- `ops-scripts/documentation/04-explanation/fluxcd-how-it-works.md`

