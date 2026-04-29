---
title: "kind reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-28"
---

# kind reference

## Scope

- **In scope:** common kind operations for local clusters and the kubectl commands most used with them.
- **Out of scope:** production Kubernetes operations, advanced CNI/network plugin work, cluster hardening.

## Cheat sheet

| Task | Command |
|---|---|
| Create cluster | `kind create cluster --name local` |
| List clusters | `kind get clusters` |
| Delete cluster | `kind delete cluster --name local` |
| Show kubeconfig | `kind get kubeconfig --name local` |
| Load local image | `kind load docker-image <image:tag> --name local` |
| Current kubectl context | `kubectl config current-context` |
| Context list | `kubectl config get-contexts` |
| Nodes | `kubectl get nodes -o wide` |
| System pods | `kubectl get pods -A` |
| Create namespace | `kubectl create namespace <ns>` |
| Deploy app | `kubectl -n <ns> create deployment <name> --image=<img>` |
| Rollout status | `kubectl -n <ns> rollout status deploy/<name>` |
| Expose service | `kubectl -n <ns> expose deploy/<name> --port=80` |
| Port-forward | `kubectl -n <ns> port-forward svc/<svc> 8080:80` |

## Interfaces

### CLI commands

#### `kind`

**Synopsis**

```text
kind <command> [flags]
```

**High-value commands**

| Command | Meaning |
|---|---|
| `create cluster` | create a local cluster |
| `get clusters` | list clusters |
| `delete cluster` | delete a cluster |
| `load docker-image` | make a local image available in the cluster |

#### `kubectl` (local cluster)

**Safety flags**

| Flag | Description |
|---|---|
| `--context <ctx>` | pin commands to the intended cluster |
| `-n, --namespace <ns>` | pin commands to intended namespace |

## Common errors

| Error | Meaning | Fix |
|---|---|---|
| `Cannot connect to the Docker daemon` | Docker not running/accessible | start Docker Desktop / daemon |
| `The connection to the server ... was refused` | API server not reachable | verify context, recreate cluster |
| Pods stuck `ImagePullBackOff` | node can't pull image | use reachable image or `kind load docker-image` |
| "wrong cluster" changes | wrong kubectl context | `kubectl config current-context` before writes |

## Best Practices

- Treat `kubectl config current-context` as a pre-flight check.
- Prefer `kind delete` + recreate over debugging deeply for local learning clusters.
- Use namespaces (`demo`, `dev`) to keep work separated.

## Security

- Local clusters can still expose services to your workstation; avoid running untrusted images.

