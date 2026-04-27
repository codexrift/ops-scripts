---
title: "kubectl how-to: operate workloads safely (get, debug, rollout, rollback)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# kubectl how-to: operate workloads safely (get, debug, rollout, rollback)

## Summary

- **Outcome:** Perform common kubectl operational tasks with low risk and good evidence.
- **Use when:** You need to debug or change a workload in a known namespace/cluster.
- **Do not use when:** Changes must be done only via GitOps/CI and direct kubectl writes are prohibited.
- **Time / effort:** 5-60 minutes depending on issue/change
- **Risk level:** low -> high (depends on actions; rollouts can be high impact)

## Cheat sheet

Use this when you already know the procedure and need the fastest safe path.

### Pre-flight

```bash
kubectl config current-context
kubectl config view --minify
kubectl get ns
kubectl get deploy,pods,svc,ingress
```

### Debug a failing pod

```bash
kubectl describe pod <pod>
kubectl logs <pod> --tail=200
kubectl logs <pod> -c <container> --tail=200
kubectl get events --sort-by=.lastTimestamp | tail -n 50
```

### Rollout and verify

```bash
kubectl rollout status deploy/<deploy>
kubectl rollout history deploy/<deploy>
kubectl get rs
```

### Rollback

```bash
kubectl rollout undo deploy/<deploy>
kubectl rollout undo deploy/<deploy> --to-revision=<n>
kubectl rollout status deploy/<deploy>
```

## Preconditions

### Required access

- kubeconfig with a working context for the target cluster
- RBAC for the namespace and the actions you need (read, logs, exec, patch/apply as appropriate)
- Break-glass / on-call escalation path for production incidents

### Required inputs

- Ticket/incident ID: `<ID>`
- Target cluster/context: `<context>`
- Target namespace: `<namespace>`
- Target resource(s): `<deploy>`, `<pod>`, `<svc>`, etc.

### Required tools

- `kubectl`
- Optional: `jq`, `k9s`

## Safety

### Impact and blast radius

- **Impact:** depends on command; read-only commands are low risk, rollouts and deletes are higher risk.
- **Blast radius:** namespace -> cluster depending on resource type and scope.

### Preconditions for running in `prod`

- [ ] Approved change window (if required)
- [ ] Confirmed correct context + namespace
- [ ] Monitoring dashboards open (or equivalent)
- [ ] Rollback path understood for the target workload
- [ ] Evidence plan (what output you will capture)

### Rollback plan (required)

**Rollback triggers**

- Health checks fail
- Error rate/latency increases
- Rollout stalls

**Rollback steps (high-level)**

1. Stop further changes.
2. Roll back the workload (`kubectl rollout undo`) or re-apply last known good manifest.
3. Verify recovery.

**Rollback validation**

- `kubectl rollout status` is successful and metrics recover.

## Procedure

### 1) Pre-flight checks

Record evidence; keep output short and relevant.

```bash
kubectl config current-context
kubectl config view --minify
kubectl auth can-i get pods
kubectl get ns
kubectl get deploy,pods,svc
```

### 2) Debug workflow (recommended order)

1. **Get**: list resources to avoid typos.
2. **Describe**: inspect events and scheduling/image errors.
3. **Logs**: collect app and sidecar logs.
4. **Exec**: last resort for interactive inspection.

Commands:

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl logs <pod> --tail=200
kubectl logs <pod> -c <container> --tail=200
kubectl get events --sort-by=.lastTimestamp | tail -n 50
```

### 3) Make a change safely

Prefer changes via manifests:

```bash
kubectl apply -f <manifest.yaml>
```

If you must make a small targeted change, use `patch` (and capture the patch you used):

```bash
kubectl patch deploy/<deploy> --type='merge' -p '<json>'
```

### 4) Verify

```bash
kubectl rollout status deploy/<deploy>
kubectl get pods
kubectl describe deploy/<deploy>
```

### 5) Closeout

- [ ] Update ticket with context/namespace, commands run, and evidence.
- [ ] Note rollback readiness (what would be undone and how).

## Troubleshooting

### If you cannot read resources

- Symptom: `Forbidden`
- Fix: verify context/namespace, then request RBAC:

```bash
kubectl config view --minify
kubectl auth can-i get pods
kubectl auth can-i patch deploy
```

### If a rollout stalls

```bash
kubectl rollout status deploy/<deploy>
kubectl describe deploy/<deploy>
kubectl get rs
kubectl describe rs/<replicaset>
kubectl get events --sort-by=.lastTimestamp | tail -n 50
```

## Best Practices

- Always state the exact target in notes: context + namespace + resource name.
- Prefer `apply` from versioned manifests over `edit` in production.
- Use `--dry-run=client -o yaml` to preview generated objects.
- Verify rollouts with `kubectl rollout status` and metrics.
- Avoid broad deletes; if you must delete, delete the controller-managed resource only if you understand the controller behavior.

## Notes / exceptions

- If your org uses GitOps, treat direct `kubectl apply/patch` as a break-glass action and reconcile back to Git.

## References

- `ops-scripts/documentation/03-reference/kubectl-reference.md`
- `ops-scripts/documentation/04-explanation/kubectl-mental-model.md`

