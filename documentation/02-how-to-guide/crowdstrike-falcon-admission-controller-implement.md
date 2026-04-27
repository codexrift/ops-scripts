---
title: "How-to: Implement CrowdStrike Falcon Admission Controller in a Kubernetes cluster"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# How-to: Implement CrowdStrike Falcon Admission Controller in a Kubernetes cluster

## Summary

- **Outcome:** Deploy the Falcon Admission Controller and enable it safely (staged rollout + clear rollback).
- **Use when:** You need admission-time policy enforcement and/or sensor injection behavior provided by Falcon.
- **Do not use when:** Your org forbids third-party admission webhooks, or you lack a tested rollback/break-glass path.
- **Time / effort:** 60-180 minutes (plus validation time)
- **Risk level:** high (a misconfigured admission webhook can block workload creates cluster-wide)

## Cheat sheet

### Pre-flight (do not skip)

```bash
kubectl config current-context
kubectl config view --minify
kubectl get nodes
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | rg -n "falcon|crowdstrike" || true
```

### Verify webhook impact quickly (after install)

```bash
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | rg -n "falcon|crowdstrike" || true
kubectl get events -A --sort-by=.lastTimestamp | tail -n 50
```

### Rollback (high-level)

1) Disable enforcement (values/config) or suspend GitOps release.  
2) Remove/rollback webhook configuration(s) (via uninstall/rollback).  
3) Validate workload creation works again in a test namespace.

## Preconditions

### Required access

- Cluster-admin (typical): admission webhooks and CRDs are cluster-scoped.
- Approval/change window for `prod`.
- Break-glass access path if admission blocks everything.

### Required inputs

- Ticket/change: `<ID>`
- Cluster: `<cluster_name>`
- Deployment method: `<helm|gitops>`
- Target namespace: `<falcon_ns>` (example: `falcon-system`)
- Policy intent:
  - mode: `<observe|enforce>`
  - scope: `<all_namespaces|selected_namespaces>`
  - exclusions: `<kube-system, monitoring, ...>`

### Required tools

- `kubectl`
- `helm` (if using Helm)
- GitOps tooling if applicable (Flux/Argo)

## Safety

### Impact and blast radius

- **Impact:** Admission decisions happen on create/update; failures can block new Pods, Deployments, Jobs, etc.
- **Blast radius:** potentially the entire cluster.

### Preconditions for running in `prod`

- [ ] Validated in a non-prod cluster with similar admission and network policies
- [ ] Staged rollout plan (namespace-scoped first)
- [ ] Failure mode chosen intentionally (`failurePolicy: Ignore` initially is common)
- [ ] Explicit exclusions for critical namespaces (`kube-system`, platform namespaces)
- [ ] Rollback is tested and documented
- [ ] On-call / stakeholders notified

### Rollback plan (required)

**Rollback triggers**

- Workloads cannot be created/updated (admission errors)
- Unexpected denials in critical namespaces
- Cluster instability

**Rollback steps (high-level)**

1. Stop enforcement (switch to observe/monitor-only) or disable the webhook.
2. Roll back the release to the previous revision.
3. If you cannot recover, remove the webhook configurations as break-glass.

**Rollback validation**

- Creating a test Pod in a test namespace succeeds again.

> **DANGER:** A broken admission webhook can "brick" cluster operations. Treat this change as high risk.

## Procedure

> **NOTE:** Exact install steps (repo URL, chart name, values keys) vary by CrowdStrike product/version and your subscription. Use the official CrowdStrike docs as the source of truth and map them into the staged rollout described here.

### 1) Baseline the cluster admission landscape

```bash
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
```

Record:

- existing webhooks with broad selectors
- any "deny by default" policies
- network policies that could block API -> webhook traffic

### 2) Choose rollout strategy (recommended: staged + fail-open first)

Recommended safety pattern:

1. Install controller in a dedicated namespace.
2. Apply webhook scope only to a test namespace (via `namespaceSelector`).
3. Start with observe/monitor-only mode if supported.
4. Start with `failurePolicy: Ignore` (fail-open) until stable.
5. Expand scope gradually, then optionally move to enforce and/or fail-closed.

Define:

- test namespace: `<falcon_test_ns>` (example: `falcon-test`)
- namespaces to include: `<ns1,ns2,...>`
- namespaces to exclude: `kube-system`, `<platform_ns>`, `<monitoring_ns>`

### 3) Install the Admission Controller

#### Helm pattern

```bash
# Pattern only; adapt per official docs
kubectl get ns <falcon_ns> || kubectl create ns <falcon_ns>
helm upgrade --install <release> <chart> -n <falcon_ns> -f values.yaml
```

#### GitOps pattern (Flux/Argo)

- Declare the release in Git (HelmRelease/Kustomization).
- Start with a test namespace selector and observe mode.
- Reconcile and verify.

### 4) Verify the controller is healthy

```bash
kubectl -n <falcon_ns> get pods
kubectl -n <falcon_ns> get deploy,svc
kubectl -n <falcon_ns> get events --sort-by=.lastTimestamp | tail -n 50
```

Checkpoint:

- Pods are running and ready.

### 5) Verify webhook configuration exists and is scoped correctly

```bash
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | rg -n "falcon|crowdstrike" || true
```

Inspect the webhook(s) (look for):

- `namespaceSelector` limits scope initially
- `failurePolicy` is intentional
- `timeoutSeconds` is reasonable
- `clientConfig.service` points to the controller service

### 6) Functional test in the test namespace

```bash
kubectl get ns <falcon_test_ns> || kubectl create ns <falcon_test_ns>
kubectl -n <falcon_test_ns> run hello --image=nginx --restart=Never
kubectl -n <falcon_test_ns> get pod hello -o wide
kubectl -n <falcon_test_ns> describe pod hello
```

Checkpoint:

- Allowed resources succeed in the test namespace.
- Deny/enforce behavior (if enabled) matches policy and scope.

### 7) Expand scope gradually

Expand one dimension at a time:

- namespaces
- observe -> enforce
- fail-open -> fail-closed

After each expansion:

- verify workload creation
- check events for denials/timeouts
- monitor API and controller health

### 8) Closeout

- [ ] Update ticket with chart version, values path, webhook scope, failurePolicy, exclusions.
- [ ] Capture evidence: admission test outputs + events.
- [ ] Define ongoing monitoring/alerts for webhook health and denial spikes.

## Troubleshooting

### If workloads fail with admission errors

```bash
kubectl get events -A --sort-by=.lastTimestamp | tail -n 100
kubectl -n <falcon_ns> logs deploy/<controller> --tail=300
```

Reduce blast radius immediately:

- shrink namespaceSelector
- switch to observe mode
- set failurePolicy to fail-open (if appropriate)
- suspend the GitOps release if needed

### If the webhook is timing out

Likely causes:

- controller under-resourced
- network policies block webhook traffic
- TLS/cert issues in webhook config

Fix:

- ensure service endpoints exist and are reachable
- increase controller resources
- review network policies and DNS

## Best Practices

- Start with least scope + fail-open, then expand deliberately.
- Exclude critical namespaces first; add them later only with explicit approval.
- Keep configuration in Git; treat policy changes as code changes with review.
- Monitor denial rate and webhook latency; spikes are an incident signal.

## Notes / exceptions

- Admission changes interact with other admission controls (OPA/Gatekeeper, Kyverno, cloud policies). Test interactions explicitly.

## References

- `ops-scripts/documentation/02-how-to-guide/crowdstrike-falcon-sensor-daemonset-deploy.md`
- `ops-scripts/documentation/03-reference/crowdstrike-falcon-k8s-reference.md`
- `ops-scripts/documentation/04-explanation/crowdstrike-falcon-k8s-how-it-works.md`

