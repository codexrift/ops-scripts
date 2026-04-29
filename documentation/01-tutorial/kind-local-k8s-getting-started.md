---
title: "Kubernetes tutorial: create a local cluster with kind (from scratch)"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-28"
---

# Kubernetes tutorial: create a local cluster with kind (from scratch)

<!--
Learning-oriented: you will build a working local Kubernetes cluster and deploy a tiny app to it.
This tutorial uses kind (Kubernetes in Docker) to avoid VMs and keep cleanup easy.
-->

## Summary

- **Goal:** Create a local Kubernetes cluster and deploy a demo workload you can reach from your workstation.
- **What you'll learn:**
  - What kind is (Kubernetes-in-Docker) and how it relates to kubectl contexts
  - How to create/delete a local cluster safely
  - How to deploy a workload and verify it
  - How to access a service locally using port-forward
- **Estimated time:** 30-60 minutes
- **Difficulty:** beginner
- **Who this is for:** you

## Prerequisites

### Required tools

- Docker (Docker Desktop on Windows/macOS, Docker Engine on Linux)
- `kubectl`
- `kind`

### Inputs you must have

- Enough disk space for container images (a few GB)
- Ability to run Docker containers locally

## Safety and scope

### What this tutorial changes

- Creates a local kind cluster (containers + a kubeconfig context)
- Deploys a small demo workload in the cluster

### Risks

- Low. Primary risk is confusion between local and real clusters; always check your context.

### Rollback (high-level)

- Delete the kind cluster: `kind delete cluster --name local`

> **DANGER:** Before any write command, confirm your `kubectl` context is the local one (`kind-local`).

## Before you start (sanity checks)

### Confirm Docker works

```bash
docker version
docker ps
```

### Confirm kubectl works

```bash
kubectl version --client=true
```

### Confirm kind works

```bash
kind version
```

Checkpoint:

- All three commands run successfully.

## Tutorial steps

### Step 1 - Create a local cluster

Create a cluster named `local`:

```bash
kind create cluster --name local
```

#### How you get the local kind context

When you run `kind create cluster`, kind writes (or updates) your kubeconfig and adds a context named `kind-<clusterName>`.

For `--name local`, the context is `kind-local`.

Confirm your kubectl context:

```bash
kubectl config get-contexts
kubectl config current-context
```

You should see a context like `kind-local`.

Checkpoint:

- `kubectl config current-context` returns `kind-local`.

### Step 2 - Verify cluster health

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

Checkpoint:

- Node is `Ready`.
- Core system pods in `kube-system` are mostly `Running` (some may still be `ContainerCreating` briefly).

### Step 3 - Deploy a tiny demo app (nginx)

Create a namespace:

```bash
kubectl create namespace demo
```

Create a Deployment:

```bash
kubectl -n demo create deployment web --image=nginx:stable
kubectl -n demo rollout status deploy/web
kubectl -n demo get pods -o wide
```

Expose it as a ClusterIP Service:

```bash
kubectl -n demo expose deployment web --port=80
kubectl -n demo get svc
```

Checkpoint:

- Deployment is available.
- Service `web` exists.

### Step 4 - Access the app from your workstation (port-forward)

Port-forward local port `8080` to the Service port `80`:

```bash
kubectl -n demo port-forward svc/web 8080:80
```

In a second terminal, test it:

```bash
curl -sS http://127.0.0.1:8080 | head
```

Checkpoint:

- You see HTML output from nginx.

> **NOTE:** Keep the port-forward terminal running while you test.

### Step 5 - Clean up (recommended)

Delete the demo namespace:

```bash
kubectl delete namespace demo
```

Delete the cluster:

```bash
kind delete cluster --name local
```

Checkpoint:

- `kind get clusters` no longer lists `local`.

## Next steps

- Operate kind safely: `documentation/02-how-to-guide/kind-operate-local-cluster.md`
- Command lookup: `documentation/03-reference/kind-reference.md`
- Understand how kind works: `documentation/04-explanation/kind-mental-model.md`
