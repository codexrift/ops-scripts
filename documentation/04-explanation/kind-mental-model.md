---
title: "kind explanation: mental model (Kubernetes-in-Docker, kubeconfig, networking)"
type: "explanation"
owner: "u115478"
last_updated: "2026-04-28"
---

# kind explanation: mental model (Kubernetes-in-Docker, kubeconfig, networking)

## Summary (1-2 paragraphs)

kind runs Kubernetes nodes as Docker containers on your machine. When you create a cluster, kind creates one or more "node" containers, boots Kubernetes components inside them, and writes a kubeconfig entry so `kubectl` can talk to the API server. For learning and local testing, this is a fast way to get a real Kubernetes control plane without provisioning VMs.

Most kind confusion comes from two places: (1) kubeconfig context selection ("am I on the local cluster or a real one?"), and (2) networking ("why can't I reach a Service from my laptop without port-forward/ingress?"). This doc explains both at a practical level.

## Context

### Problem statement

- You want a disposable local Kubernetes cluster you can recreate quickly.
- You need predictable ways to reach workloads from your workstation.

### Constraints

- kind depends on Docker; if Docker is down, the cluster is down.
- Services are cluster-internal by default; workstation access needs port-forward or ingress/port mappings.

## Concepts and mental model

### What gets created

When you run `kind create cluster --name local`:

- Docker containers are created (e.g., `kindest/node` images)
- Kubernetes API server is started inside the control-plane container
- kubeconfig is updated with a context like `kind-local`

```mermaid
flowchart LR
  U[You] --> K[kubectl]
  K -->|kubeconfig context kind-local| A[K8s API server]
  A --> N[Node container(s)]
  N --> P[Pods/containers]
```

### Kubeconfig and context safety

- A **context** selects: cluster + user + namespace.
- `kubectl` sends requests to whatever context is current unless you override it.

Practical safety habit:

- Read: `kubectl config current-context`
- Write: use `--context kind-local` when scripting

### Why Services are not directly reachable

In Kubernetes:

- A **ClusterIP** service is reachable only inside the cluster network.
- A **NodePort** service is reachable via a node IP + port, but kind's node IP is inside Docker networking.

That is why local access commonly uses:

- `kubectl port-forward` (quick, per-terminal)
- Ingress (more realistic, more setup)

## Tradeoffs and decisions

- kind is fast and reproducible, but it is not a perfect replica of your production environment.
- For local learning/testing, deleting and recreating the cluster is often the best "reset button".

## Related docs

- Build a cluster: `documentation/01-tutorial/kind-local-k8s-getting-started.md`
- Operate it safely: `documentation/02-how-to-guide/kind-operate-local-cluster.md`
- Command lookup: `documentation/03-reference/kind-reference.md`

