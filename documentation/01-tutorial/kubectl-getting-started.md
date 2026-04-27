---
title: "kubectl tutorial: connect, inspect, and change safely"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-27"
---

# kubectl tutorial: connect, inspect, and change safely

<!--
This tutorial assumes you are learning kubectl basics. It includes checkpoints and safe defaults.
If you are operating production clusters, follow your change process and use the How-to guide.
-->

## Summary

- **Goal:** Use `kubectl` to connect to a cluster, inspect resources, and apply a small safe change.
- **What you'll learn:**
  - How kubeconfig + contexts work
  - How to safely read cluster state (get/describe/logs)
  - How to make a minimal change and verify it
  - How to avoid common kubectl footguns
- **Estimated time:** 30-60 minutes
- **Difficulty:** beginner -> intermediate
- **Who this is for:** you

## Prerequisites

### Access and permissions

- Access to a Kubernetes cluster (sandbox preferred)
- Credentials that produce a working kubeconfig entry
- RBAC permissions to read workloads in at least one namespace

### Required tools

- `kubectl` installed on your workstation
- Optional: `kubectx`/`kubens` (nice-to-have), `jq` (nice-to-have)

### Inputs you must have

- Kubeconfig path (usually `~/.kube/config`)
- A known cluster/context name (or instructions to obtain one)
- A namespace you are allowed to use (or `default`)

## Safety and scope

### What this tutorial changes

- It may create or modify a small resource in a namespace you choose (ideally a sandbox namespace).

### Risks

- Running commands against the wrong cluster/context can cause unintended changes.
- Deleting or applying the wrong manifest can break workloads.

### Rollback (high-level)

- Prefer making changes via manifests so rollback is `kubectl apply -f <previous>` or `kubectl rollout undo`.
- For this tutorial, you can delete the demo resource you create.

> **DANGER:** Always confirm your current context before running any write command (`apply`, `delete`, `scale`, `rollout`, `patch`).

## Before you start (sanity checks)

### Confirm kubectl is installed

```bash
kubectl version --client=true
```

### Confirm kubeconfig is reachable

```bash
kubectl config view
kubectl config get-contexts
kubectl config current-context
```

Checkpoint:

- You see at least one context.

### Confirm you can reach the cluster

```bash
kubectl cluster-info
kubectl get nodes
```

Checkpoint:

- `kubectl get nodes` returns a list of nodes (or at least does not error on auth/connectivity).

## Tutorial steps

### Step 1 - Pick the right context and namespace (safest habit)

**What you're doing:** Verify where your commands will run.

**Why it matters:** Most kubectl incidents are "ran the right command in the wrong cluster".

```bash
kubectl config current-context
kubectl config get-contexts
```

Set a namespace for your current context (optional, but helpful):

```bash
kubectl config set-context --current --namespace=<namespace>
```

Checkpoint:

- `kubectl config view --minify` shows the expected context and namespace.

Common mistakes:

- Forgetting the namespace -> you look at the wrong resources.
- Using multiple terminals with different contexts -> you change the wrong cluster.

---

### Step 2 - Read state: list and describe resources

**What you're doing:** Learn the standard "get then describe" workflow.

**Why it matters:** `get` is fast and scannable; `describe` explains why something is failing.

```bash
kubectl get ns
kubectl get pods
kubectl get deploy
kubectl get svc
```

Pick one pod and describe it:

```bash
kubectl describe pod <pod-name>
```

Checkpoint:

- You can explain (from `describe`) the pod's status, image, and recent events.

---

### Step 3 - Inspect logs and execute inside a container

**What you're doing:** Collect evidence from a running workload.

**Why it matters:** Logs and `exec` are the fastest path to understanding app behavior.

```bash
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>
kubectl logs -f <pod-name>
```

Exec into a container:

```bash
kubectl exec -it <pod-name> -- sh
```

Checkpoint:

- You can stream logs and run a simple command inside the container (like `env`).

> **WARNING:** Avoid using `exec` as a "fix". Prefer changing config/manifests so the state is reproducible.

---

### Step 4 - Make a minimal safe change (scale) and verify

**What you're doing:** Change a Deployment replica count and watch it converge.

**Why it matters:** Scaling is a simple way to learn "desired state" and verification patterns.

Pick a Deployment you are allowed to touch. Then:

```bash
kubectl get deploy
kubectl scale deploy/<deploy-name> --replicas=2
kubectl rollout status deploy/<deploy-name>
kubectl get pods -w
```

Checkpoint:

- `rollout status` reports success and the desired replica count is reached.

Common mistakes:

- Scaling the wrong Deployment because of the wrong namespace/context.
- Assuming success without checking `rollout status`.

---

### Step 5 - Apply a manifest (recommended workflow) and clean up

**What you're doing:** Create a resource from a file, then remove it.

**Why it matters:** Git + manifests are auditable and repeatable.

Create a small ConfigMap from literals (safe demo):

```bash
kubectl create configmap kubectl-tutorial-demo --from-literal=hello=world -o yaml --dry-run=client > kubectl-tutorial-demo.yaml
kubectl apply -f kubectl-tutorial-demo.yaml
kubectl get configmap kubectl-tutorial-demo -o yaml
```

Cleanup:

```bash
kubectl delete -f kubectl-tutorial-demo.yaml
rm -f kubectl-tutorial-demo.yaml
```

Checkpoint:

- The ConfigMap exists after apply and is gone after delete.

## Cleanup (if this tutorial uses a lab)

- Delete the demo ConfigMap (above) and any test workloads you created.
- Revert any scaling changes if they were only for learning.

## Troubleshooting

### Symptom: "You must be logged in to the server" / auth errors

**Likely causes**

- Expired credentials in kubeconfig
- Wrong context
- Missing RBAC permissions

**Fix**

- Re-authenticate using your platform's login flow (SSO, cloud auth plugin, etc.).
- Confirm context and namespace:

```bash
kubectl config current-context
kubectl config view --minify
```

**Validation**

- `kubectl get ns` works.

---

### Symptom: resources not found

**Likely causes**

- Wrong namespace
- Wrong resource type/name

**Fix**

```bash
kubectl get ns
kubectl get pods -A | head
```

---

### Error catalog (quick)

| Error / Message | Meaning | Fix |
|---|---|---|
| `Forbidden` | RBAC denies action | request role/permission; use correct namespace |
| `NotFound` | resource or namespace missing | verify name/namespace; list resources first |
| `context was not found` | kubeconfig context mismatch | `kubectl config get-contexts` and choose a valid one |

## Best Practices

### Safety defaults

- Always confirm `kubectl config current-context` before write commands.
- Prefer `kubectl apply -f` from versioned manifests over imperative one-offs.
- Use `--dry-run=client -o yaml` to preview generated resources.

### Operational habits

- Use `kubectl rollout status` after any rollout-affecting change.
- Capture evidence: `get`, `describe`, events, logs.
- Avoid editing live objects with `kubectl edit` in prod unless your process explicitly allows it.

## FAQ

**Q:** Should I always use `-A` (all namespaces)?  
**A:** Use it for discovery. For routine work, set your namespace to avoid accidental changes.

**Q:** Is it OK to run `kubectl delete pod` to fix issues?  
**A:** Sometimes, but it treats symptoms. Prefer fixing the root cause in the controller spec or config.

## Glossary

- **kubeconfig:** file holding clusters, users, and contexts for kubectl.
- **context:** named selection of cluster + user + namespace.
- **desired state:** what controllers try to make true (e.g., a Deployment's replica count).

## Next steps

- How-to: `ops-scripts/documentation/02-how-to-guide/kubectl-operate-workloads-safely.md`
- Reference: `ops-scripts/documentation/03-reference/kubectl-reference.md`
- Explanation: `ops-scripts/documentation/04-explanation/kubectl-mental-model.md`

