---
title: "kubectl reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# kubectl reference

## Scope

- **In scope:** kubectl commands, output formats, common patterns for working with Kubernetes resources.
- **Out of scope:** cluster provisioning, Kubernetes API deep dive, vendor-specific tooling.

## Cheat sheet

| Task | Command |
|---|---|
| Current context | `kubectl config current-context` |
| Contexts list | `kubectl config get-contexts` |
| Set namespace (current context) | `kubectl config set-context --current --namespace=<ns>` |
| Cluster info | `kubectl cluster-info` |
| Nodes | `kubectl get nodes` |
| Pods (all namespaces) | `kubectl get pods -A` |
| Describe | `kubectl describe <type>/<name>` |
| Logs | `kubectl logs <pod> -c <container> --tail=200` |
| Exec | `kubectl exec -it <pod> -- sh` |
| Apply | `kubectl apply -f <file.yaml>` |
| Diff | `kubectl diff -f <file.yaml>` |
| Rollout status | `kubectl rollout status deploy/<name>` |
| Rollback | `kubectl rollout undo deploy/<name>` |

## Quick start (minimal)

```bash
kubectl get pods
```

## Interfaces

### CLI commands

#### `kubectl`

**Synopsis**

```text
kubectl [command] [TYPE] [NAME] [flags]
```

**High-value global flags**

| Flag | Default | Description |
|---|---|---|
| `-n, --namespace <ns>` | (context) | Namespace |
| `-A, --all-namespaces` | false | All namespaces |
| `--context <ctx>` | (current) | Override context |
| `--kubeconfig <path>` | (default) | Override kubeconfig |
| `-o <format>` | (none) | Output: `wide`, `yaml`, `json`, `name` |
| `--sort-by=<jsonpath>` | (none) | Sort results |
| `--field-selector=<expr>` | (none) | Server-side filtering |
| `-l, --selector=<label>` | (none) | Label selector |

**Common patterns**

```bash
# Use explicit context for safety
kubectl --context <ctx> -n <ns> get pods

# Output formats
kubectl get deploy -o wide
kubectl get deploy -o yaml
kubectl get deploy -o json

# Watch
kubectl get pods -w

# Server-side apply (when appropriate)
kubectl apply --server-side -f <file.yaml>
```

---

#### `kubectl get`

**Synopsis**

```text
kubectl get (TYPE [NAME] | TYPE/NAME | -f file) [flags]
```

**Options**

| Flag | Default | Description |
|---|---|---|
| `-o wide` | (none) | More columns |
| `-o yaml/json/name` | (none) | Serialization |
| `--show-labels` | false | Show labels |

**Examples**

```bash
kubectl get ns
kubectl get pods
kubectl get deploy,svc
kubectl get pods -A
kubectl get pod/<pod> -o yaml
```

---

#### `kubectl describe`

**Examples**

```bash
kubectl describe pod/<pod>
kubectl describe deploy/<deploy>
```

---

#### `kubectl logs`

**Examples**

```bash
kubectl logs <pod> --tail=200
kubectl logs <pod> -c <container> --tail=200
kubectl logs -f <pod>
```

---

#### `kubectl exec`

**Examples**

```bash
kubectl exec -it <pod> -- sh
kubectl exec -it <pod> -c <container> -- sh
```

---

#### `kubectl apply`

**Examples**

```bash
kubectl apply -f <file.yaml>
kubectl diff -f <file.yaml>
```

---

#### `kubectl rollout`

**Examples**

```bash
kubectl rollout status deploy/<deploy>
kubectl rollout history deploy/<deploy>
kubectl rollout undo deploy/<deploy>
kubectl rollout undo deploy/<deploy> --to-revision=<n>
```

### Configuration

#### Config file locations

- Linux/macOS: `~/.kube/config` (typical)
- Windows: `%USERPROFILE%\.kube\config` (common) or `~/.kube/config` depending on tooling

#### Key concepts

| Term | Meaning |
|---|---|
| cluster | API server endpoint + CA data |
| user | auth method (token/cert/plugin) |
| context | cluster + user + namespace |

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `KUBECONFIG` | no | (none) | Path(s) to kubeconfig; can be a list depending on OS/tooling |

## Best Practices

- Use explicit context + namespace for write operations.
- Prefer `kubectl diff` before `apply`.
- Keep Reference examples safe; do not suggest disabling TLS or skipping safety checks.
- Keep multi-step procedures in the How-to guide; link here for command syntax.

## Security

### Authentication and authorization

- Most access control is RBAC; `kubectl auth can-i` helps check permissions.
- Prefer least privilege: scope permissions to namespaces and needed verbs.

### Secrets handling

- Avoid printing Secrets to terminals, logs, or docs.
- Prefer `kubectl get secret <name> -o jsonpath=...` only when you must, and redact outputs.

## Observability

### Logs

```bash
kubectl logs <pod> --tail=200
kubectl logs <pod> -c <container> --tail=200
```

### Events

```bash
kubectl get events --sort-by=.lastTimestamp | tail -n 50
```

## Compatibility

- Kubernetes API versions and features vary; check cluster/server version when behavior is surprising:

```bash
kubectl version
```

## Limits and known behaviors

- Kubernetes is eventually consistent; after changes, watch rollout status and events.
- `kubectl` output can be truncated; prefer `-o yaml/json` for full fields.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

