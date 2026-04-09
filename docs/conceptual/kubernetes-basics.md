# Kubernetes Basics (Concepts) Cheat Sheet

Kubernetes orchestrates containers: scheduling, scaling, service discovery, and rolling updates.

## Core objects

- **Pod**: smallest deployable unit (one or more containers sharing network/storage)
- **Deployment**: manages replica sets and rolling updates for stateless apps
- **StatefulSet**: stable identities/storage for stateful workloads
- **Service**: stable virtual IP/DNS for pods
- **Ingress**: HTTP routing into the cluster (implementation via ingress controller)
- **ConfigMap/Secret**: configuration data
- **Namespace**: logical partitioning

## Control plane vs nodes

- Control plane: API server, scheduler, controller managers, etcd
- Nodes: kubelet + container runtime; run pods

## Common operational themes

- RBAC and least privilege
- Resource requests/limits
- Readiness/liveness probes
- Observability (logs/metrics/traces)

