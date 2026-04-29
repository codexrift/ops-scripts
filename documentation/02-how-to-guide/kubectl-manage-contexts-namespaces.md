---
title: "kubectl how-to: manage contexts and namespaces safely (kubeconfig)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-28"
---

# kubectl how-to: manage contexts and namespaces safely (kubeconfig)

## Summary

- **Outcome:** List/switch contexts, pin commands to the right cluster, and avoid "oops wrong cluster" writes.
- **Use when:** You work with multiple clusters/environments from one workstation.
- **Do not use when:** Your org requires all changes via GitOps/CI and direct kubectl writes are prohibited.
- **Time / effort:** 2-15 minutes
- **Risk level:** medium (wrong context can cause unintended changes)

## Cheat sheet

### Pre-flight (run before any write)

```bash
kubectl config current-context
kubectl config view --minify
kubectl get ns
```

### List + switch context

```bash
kubectl config get-contexts
kubectl config use-context <context>
kubectl config current-context
```

### Pin a single command (safer for scripts)

```bash
kubectl --context <context> -n <ns> get pods
```

### Set default namespace for the current context

```bash
kubectl config set-context --current --namespace=<ns>
```

## Preconditions

### Required access

- A working kubeconfig entry for each cluster you intend to use
- RBAC permissions for the namespaces/actions you need

### Required inputs

- Context name: `<context>`
- Namespace: `<ns>`

## Safety

### Guard rails (recommended habits)

- Use `--context <context>` for any write in scripts.
- Always include `-n <ns>` (or set a default namespace) to avoid accidentally writing to `default`.
- Keep contexts clearly named (include env + region + cluster).

> **DANGER:** If you are on-call or working with prod, treat context checks like `sudo`: slow down and verify first.

## Procedures

### 0) Create contexts in the first place (common sources)

Kubeconfig contexts usually come from one of these:

- **Local clusters**: tools create kubeconfig entries automatically (kind, minikube, k3d).
- **Managed Kubernetes (cloud)**: provider CLI writes/merges kubeconfig (EKS/AKS/GKE, etc.).
- **Copied kubeconfig**: someone/something provides a kubeconfig file you place under `~/.kube/` and merge/use via `--kubeconfig`.
- **Bare-metal / kubeadm**: cluster admin provides an admin/user kubeconfig (or you generate one via certs + RBAC).

This section shows the safe patterns that apply regardless of provider.

#### A) Inspect an existing context definition

Show the full context list with cluster/user mapping:

```bash
kubectl config get-contexts
```

Show the underlying entries for one context (cluster + user + namespace):

```bash
kubectl config view -o jsonpath='{range .contexts[?(@.name=="<context>")]}{.name}{"\n  cluster="}{.context.cluster}{"\n  user="}{.context.user}{"\n  namespace="}{.context.namespace}{"\n"}{end}' || true
```

> **NOTE:** JSONPath support is built into kubectl; this avoids needing `jq`.

#### B) Create a context (advanced / manual)

Use when: you have a kubeconfig file that already contains a `cluster` entry and a `user` entry, and you want to combine them into a new context name.

```bash
kubectl config set-context <new-context> --cluster=<cluster-name> --user=<user-name> --namespace=<ns>
kubectl config use-context <new-context>
kubectl config current-context
```

> **WARNING:** Manual context creation does not create credentials by itself; it only links existing entries.

#### C) Add a new kubeconfig file (safe, non-destructive)

Use when: you received a kubeconfig file, for example `~/Downloads/cluster-kubeconfig.yaml`.

Option 1: use it directly (no merge):

```bash
kubectl --kubeconfig ~/Downloads/cluster-kubeconfig.yaml config get-contexts
kubectl --kubeconfig ~/Downloads/cluster-kubeconfig.yaml config current-context
```

Option 2: merge it into your main kubeconfig (flattened view):

```bash
export KUBECONFIG=~/.kube/config:~/Downloads/cluster-kubeconfig.yaml
kubectl config view --flatten > ~/.kube/config.merged
kubectl --kubeconfig ~/.kube/config.merged config get-contexts
```

Then, if it looks correct, you can replace your default `~/.kube/config` with the merged file (do this only if you understand the impact).

> **DANGER:** Merging can overwrite entries if names collide. Prefer unique context names.

### A) Identify the current target (cluster + user + namespace)

```bash
kubectl config current-context
kubectl config view --minify
```

Optional: show what cluster the current context points at:

```bash
kubectl config view --minify -o jsonpath='{.contexts[0].context.cluster}{"\n"}{.contexts[0].context.user}{"\n"}{.contexts[0].context.namespace}{"\n"}' || true
```

### B) List all contexts (and what they point to)

```bash
kubectl config get-contexts
```

Tip: highlight the current context:

```bash
kubectl config get-contexts --no-headers | sed -n '1,200p' || true
```

> **NOTE:** If `sed` is not available (Windows), just use `kubectl config get-contexts`.

### C) Switch contexts

```bash
kubectl config use-context <context>
kubectl config current-context
kubectl cluster-info
```

### D) Set a default namespace per context

Use when: you frequently work in a non-default namespace.

```bash
kubectl config set-context --current --namespace=<ns>
kubectl config view --minify
```

### E) Use multiple kubeconfig files (merge behavior)

`kubectl` reads kubeconfig from:

1. `--kubeconfig <path>` (highest priority)
2. `KUBECONFIG` (can be a list of files)
3. default: `~/.kube/config`

Example: temporarily point to a specific kubeconfig:

```bash
kubectl --kubeconfig ~/.kube/config config get-contexts
```

Example: merge two kubeconfigs for one session:

```bash
export KUBECONFIG=~/.kube/config:~/.kube/other-config
kubectl config get-contexts
kubectl config view --flatten
```

> **NOTE:** On Windows PowerShell, set env var like: `$env:KUBECONFIG="$HOME\\.kube\\config;$HOME\\.kube\\other-config"`. Separator can differ by platform; validate with `kubectl config get-contexts`.

### F) Create a “safe alias” pattern

Use when: you want to reduce mistakes in a shared terminal.

```bash
alias k='kubectl'
alias kprod='kubectl --context <prod-context>'
alias kdev='kubectl --context <dev-context>'
```

## Verification

```bash
kubectl config current-context
kubectl config view --minify
kubectl get ns
```

## Related docs

- `documentation/04-explanation/kubeconfig-contexts-mental-model.md`
- `documentation/03-reference/kubectl-reference.md`
- `documentation/02-how-to-guide/kubectl-operate-workloads-safely.md`
