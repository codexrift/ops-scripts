---
title: "kind how-to: operate a local Kubernetes cluster safely (create, switch, reset)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-28"
---

# kind how-to: operate a local Kubernetes cluster safely (create, switch, reset)

## Summary

- **Outcome:** Manage local kind clusters with predictable context selection and clean resets.
- **Use when:** You need a disposable Kubernetes cluster for learning or local integration tests.
- **Do not use when:** You need multi-node performance testing or production-like networking (use a more realistic environment).
- **Time / effort:** 2-20 minutes
- **Risk level:** low (unless you run `kubectl` against the wrong context)

## Cheat sheet

### Create / list / delete clusters

```bash
kind create cluster --name local
kind get clusters
kind delete cluster --name local
```

### Confirm you are on the local cluster

```bash
kubectl config current-context
kubectl config view --minify
kubectl cluster-info
```

### Where the `kind-<name>` context comes from

Creating a cluster also creates the kubeconfig context:

```bash
kind create cluster --name local
kubectl config get-contexts
kubectl config use-context kind-local
```

## Preconditions

### Required tools

- `docker`
- `kind`
- `kubectl`

## Safety

### Guard rails

- Before any write command: `kubectl config current-context` must be `kind-<name>`.
- Prefer explicit context for scripts:

```bash
kubectl --context kind-local get nodes
```

## Procedures

### A) Create a named cluster (repeatable)

```bash
kind create cluster --name local
kubectl config current-context
kubectl get nodes
```

### B) Switch contexts safely

List contexts:

```bash
kubectl config get-contexts
```

Switch:

```bash
kubectl config use-context kind-local
kubectl config current-context
```

### C) Reset everything (fast clean slate)

Use when: the cluster is "weird" and you want a known-good state.

```bash
kind delete cluster --name local
kind create cluster --name local
kubectl get nodes
kubectl get pods -A
```

### D) Load a locally-built Docker image into kind

Use when: you built an image locally and want to run it in the cluster without pushing to a registry.

```bash
docker build -t demo/app:dev .
kind load docker-image demo/app:dev --name local
```

Then reference it in Kubernetes:

```bash
kubectl create namespace demo || true
kubectl -n demo create deployment app --image=demo/app:dev
kubectl -n demo patch deploy/app -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","image":"demo/app:dev","imagePullPolicy":"IfNotPresent"}]}}}}'
kubectl -n demo rollout status deploy/app
```

### E) Export kubeconfig (useful for tools)

```bash
kind get kubeconfig --name local
```

## Verification

```bash
kind get clusters
kubectl config current-context
kubectl get nodes
```

## Related docs

- `documentation/01-tutorial/kind-local-k8s-getting-started.md`
- `documentation/03-reference/kind-reference.md`
- `documentation/04-explanation/kind-mental-model.md`
