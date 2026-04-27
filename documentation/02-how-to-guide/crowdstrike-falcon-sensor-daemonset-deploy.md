---
title: "How-to: Deploy CrowdStrike Falcon sensor as a DaemonSet across all Kubernetes nodes"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# How-to: Deploy CrowdStrike Falcon sensor as a DaemonSet across all Kubernetes nodes

## Summary

- **Outcome:** Deploy the Falcon sensor as a DaemonSet on all supported nodes and verify runtime detection coverage.
- **Use when:** You need node-level runtime detection across the cluster.
- **Do not use when:** Your org prohibits privileged DaemonSets or requires an alternative deployment model.
- **Time / effort:** 45-180 minutes
- **Risk level:** high (node-level agents may require elevated privileges and can impact stability if misconfigured)

## Cheat sheet

### Pre-flight

```bash
kubectl config current-context
kubectl config view --minify
kubectl get nodes -o wide
kubectl get ns
```

### Verify DaemonSet coverage

```bash
kubectl -n <falcon_ns> get ds
kubectl -n <falcon_ns> describe ds <ds_name>
kubectl -n <falcon_ns> get pods -o wide
```

### Rollback (high-level)

- Roll back/uninstall the release (Helm/GitOps).
- Confirm nodes recover (no residual crashloops or pressure issues).

## Preconditions

### Required access

- cluster-admin or equivalent privileges for cluster-wide agents
- approval/change window for `prod`
- ability to validate on representative node pools

### Required inputs

- Ticket/change: `<ID>`
- Falcon namespace: `<falcon_ns>` (example: `falcon-system`)
- Cluster name/ID (as required by your org): `<cluster_name>`
- Falcon customer/tenant identifier (as required): `<falcon_customer_id>`
- Image registry/mirror (if applicable): `<registry>`
- Node pool constraints:
  - OS: `<linux|windows|mixed>`
  - architectures: `<amd64|arm64>`
  - taints/tolerations required: `<tolerations>`

### Required tools

- `kubectl`
- `helm` (if using Helm)

## Safety

### Impact and blast radius

- **Impact:** Runs an agent on every node; consumes CPU/memory; may interact with kernel/container runtime.
- **Blast radius:** cluster-wide.

### Preconditions for running in `prod`

- [ ] Tested in non-prod on matching node types and Kubernetes version
- [ ] Confirmed sensor requirements and privileges per official docs
- [ ] Defined resource requests/limits and rollout strategy
- [ ] Defined exclusions (node selectors) for unsupported pools
- [ ] Monitoring open (node pressure, kubelet errors, DaemonSet readiness)

### Rollback plan (required)

**Rollback triggers**

- Node instability or pressure after deployment
- Widespread sensor crashloop
- Unexpected performance regressions

**Rollback steps (high-level)**

1. Stop the rollout (pause GitOps / rollback Helm release).
2. Remove the DaemonSet (uninstall/rollback) from the cluster.
3. Verify node health and kubelet stability.

**Rollback validation**

- All nodes return to stable state; no residual sensor pods remain.

## Procedure

> **NOTE:** Exact chart names, image names, and values keys vary by product/version. Use official CrowdStrike docs for the concrete install commands and map them into this safety-first procedure.

### 1) Baseline nodes and constraints

```bash
kubectl get nodes -o wide
kubectl describe node <node> | rg -n "Taints|Labels|OS Image|Kernel Version|Container Runtime" || true
```

Record:

- node OS/arch distribution
- taints that require tolerations
- restricted pools to exclude

### 2) Create/choose the Falcon namespace

```bash
kubectl get ns <falcon_ns> || kubectl create ns <falcon_ns>
```

### 3) Provide required credentials/config (secrets/configmaps)

Create secrets using your org policy (do not store secrets in Git unless encrypted/approved).

Pattern:

```bash
# Pattern only; adapt keys per official docs
kubectl -n <falcon_ns> create secret generic falcon-credentials \
  --from-literal=customer_id='<falcon_customer_id>'
```

### 4) Deploy the sensor DaemonSet

#### Helm pattern

```bash
# Pattern only; adapt per official docs
helm upgrade --install <release> <chart> -n <falcon_ns> -f values.yaml
```

#### GitOps pattern

- Define release manifests in Git.
- Roll out to a canary set of node pools first (nodeSelector).
- Expand to all nodes after verification.

### 5) Verify rollout

```bash
kubectl -n <falcon_ns> get ds
kubectl -n <falcon_ns> get pods -o wide
kubectl -n <falcon_ns> describe ds <ds_name>
kubectl -n <falcon_ns> get events --sort-by=.lastTimestamp | tail -n 50
```

Checkpoint:

- Desired number scheduled equals number ready on supported nodes.

### 6) Validate runtime visibility (conceptual)

Validation depends on your Falcon console/integration. Capture evidence such as:

- nodes show as covered/healthy
- sensor reports a healthy status

### 7) Closeout

- [ ] Record chart version, values path, namespace, nodeSelector/tolerations, and resource requests.
- [ ] Record coverage numbers (scheduled/ready).
- [ ] Define ongoing monitoring (DaemonSet readiness + node pressure).

## Troubleshooting

### If pods are not scheduled on some nodes

Common causes:

- missing tolerations for taints
- nodeSelector excludes a pool
- OS/arch mismatch

```bash
kubectl -n <falcon_ns> describe ds <ds_name>
kubectl describe node <node>
```

### If pods crashloop

```bash
kubectl -n <falcon_ns> get pods
kubectl -n <falcon_ns> describe pod <pod>
kubectl -n <falcon_ns> logs <pod> --tail=200
```

## Best Practices

- Start with a canary node pool and expand gradually.
- Keep resource requests/limits explicit; monitor node pressure during rollout.
- Keep secrets out of Git unless using an approved encrypted workflow.
- Document exclusions for unsupported nodes (OS/arch/runtime).

## Notes / exceptions

- Privileged/securityContext requirements can conflict with Pod Security Admission. Validate policy interactions early.

## References

- `ops-scripts/documentation/02-how-to-guide/crowdstrike-falcon-admission-controller-implement.md`
- `ops-scripts/documentation/03-reference/crowdstrike-falcon-k8s-reference.md`
- `ops-scripts/documentation/04-explanation/crowdstrike-falcon-k8s-how-it-works.md`

