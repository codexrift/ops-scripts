---
title: "Helm tutorial: install, upgrade, and rollback a chart safely"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-27"
---

# Helm tutorial: install, upgrade, and rollback a chart safely

## Summary

- **Goal:** Learn Helm by installing a chart, changing values, upgrading, and rolling back.
- **What you'll learn:**
  - What a chart, release, and values are
  - How Helm renders templates into Kubernetes manifests
  - Safe workflows: render/diff -> upgrade -> verify -> rollback
  - Where Helm stores release state and why that matters
- **Estimated time:** 30-75 minutes
- **Difficulty:** beginner -> intermediate
- **Who this is for:** you

## Prerequisites

### Access and permissions

- A Kubernetes cluster you can modify (sandbox preferred)
- RBAC to create resources in a namespace

### Required tools

- `kubectl`
- `helm`
- Optional: `helm-diff` plugin (nice-to-have)

### Inputs you must have

- Cluster context: `<context>`
- Target namespace: `<namespace>`
- A chart source (repo or local path): `<chart>`

## Safety and scope

### What this tutorial changes

- Creates a Helm release in `<namespace>` and installs chart resources there.

### Risks

- Installing into the wrong namespace/context can affect unintended workloads.
- Bad values can create unsafe resources (exposed Services, privileged Pods).

### Rollback (high-level)

- Use `helm rollback <release> <revision>` to revert.
- Or `helm uninstall <release>` to remove the release (if safe to do so).

> **DANGER:** Confirm `kubectl config current-context` and `--namespace` before any `install/upgrade/uninstall`.

## Before you start (sanity checks)

```bash
kubectl config current-context
kubectl config view --minify
helm version
```

Checkpoint:

- You can talk to the cluster and `helm` runs.

## Tutorial steps

### Step 1 - Pick a namespace and create it if needed

**What you're doing:** Choose an explicit namespace for the release.

**Why it matters:** It limits blast radius and makes cleanup easier.

```bash
kubectl get ns <namespace> || kubectl create ns <namespace>
```

---

### Step 2 - Inspect the chart and default values

**What you're doing:** Understand what the chart will create before installing it.

**Why it matters:** Charts are code; you should read what you're about to run.

If using a repo chart:

```bash
helm repo add <repo_name> <repo_url>
helm repo update
helm show chart <repo_name>/<chart>
helm show values <repo_name>/<chart> > values-default.yaml
```

Checkpoint:

- You can see chart metadata and default values.

---

### Step 3 - Render manifests locally (no cluster changes)

**What you're doing:** Render templates to YAML so you can review the output.

**Why it matters:** It catches obvious issues before you apply anything.

```bash
helm template <release> <repo_name>/<chart> -n <namespace> -f values-default.yaml > rendered.yaml
```

Review:

- Service types and ports
- Ingress exposure
- Security contexts
- Resource requests/limits

---

### Step 4 - Install the release

**What you're doing:** Create a Helm release and apply its resources.

**Why it matters:** Helm tracks release state and supports upgrades/rollbacks.

```bash
helm upgrade --install <release> <repo_name>/<chart> -n <namespace> -f values-default.yaml
helm ls -n <namespace>
kubectl -n <namespace> get all
```

Checkpoint:

- Release appears in `helm ls` and pods start.

---

### Step 5 - Change values and upgrade

**What you're doing:** Make a small safe change via values and upgrade the release.

**Why it matters:** Values are the primary knob for configuration.

1. Create `values.yaml` (copy from defaults and edit only what you need).
2. Upgrade:

```bash
helm upgrade <release> <repo_name>/<chart> -n <namespace> -f values.yaml
helm history <release> -n <namespace>
```

Checkpoint:

- A new revision is recorded in `helm history`.

---

### Step 6 - Roll back

**What you're doing:** Revert to a prior known-good revision.

**Why it matters:** Rollback is a key safety feature of Helm.

```bash
helm history <release> -n <namespace>
helm rollback <release> <revision> -n <namespace>
```

Checkpoint:

- Workloads return to the previous behavior/state.

## Cleanup (if this tutorial uses a lab)

```bash
helm uninstall <release> -n <namespace>
kubectl delete ns <namespace>
rm -f values-default.yaml rendered.yaml values.yaml
```

## Troubleshooting

### Symptom: install succeeds but pods fail

```bash
kubectl -n <namespace> get pods
kubectl -n <namespace> describe pod <pod>
kubectl -n <namespace> logs <pod> --tail=200
```

### Error catalog (quick)

| Error / Message | Meaning | Fix |
|---|---|---|
| `timed out waiting for` | resources not ready | inspect events/pods; increase timeout if appropriate |
| `cannot re-use a name` | release exists | use `helm ls -A` and target the right namespace |

## Best Practices

- Render and review: `helm template` (and `helm diff` if available) before upgrades in prod.
- Keep values small and explicit; avoid ad-hoc CLI `--set` in prod.
- Pin chart versions for repeatability; promote versions across environments deliberately.
- Prefer GitOps for release definitions when operating at scale.

## FAQ

**Q:** Is Helm "just kubectl apply"?  
**A:** It renders templates then applies them, but it also stores release state and supports upgrades/rollbacks.

## Glossary

- **Chart:** package of templates + defaults.
- **Release:** an installed instance of a chart (with a name + revision history).
- **Values:** configuration input for templates.

## Next steps

- How-to: `ops-scripts/documentation/02-how-to-guide/helm-operate-releases-safely.md`
- Reference: `ops-scripts/documentation/03-reference/helm-reference.md`
- Explanation: `ops-scripts/documentation/04-explanation/helm-how-it-works.md`

