# Minikube Cheat Sheet

Local single-node (or multi-node) Kubernetes clusters for development/testing.

## Quick start

```bash
minikube start
minikube status
kubectl get nodes
```

Pick a driver explicitly (common choices: `docker`, `hyperv`, `virtualbox`, `qemu`, `kvm2`):

```bash
minikube start --driver=docker
```

Resources:

```bash
minikube start --cpus=4 --memory=8192 --disk-size=40g
```

## Profiles (multiple clusters)

```bash
minikube profile list
minikube start -p dev
minikube start -p demo --kubernetes-version=v1.29.6
minikube delete -p demo
```

## Common operations

```bash
minikube pause
minikube unpause
minikube stop
minikube start
minikube delete
```

Cluster info:

```bash
minikube ip
minikube ssh
minikube logs
minikube config view
```

## kubectl integration

Minikube can bundle `kubectl`:

```bash
minikube kubectl -- get pods -A
```

Or use your own `kubectl` and confirm context:

```bash
kubectl config get-contexts
kubectl config current-context
kubectl cluster-info
```

## Addons

```bash
minikube addons list
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons disable ingress
```

## Dashboard

```bash
minikube dashboard
```

## Accessing services

Get a URL (works well with `NodePort`):

```bash
minikube service <service-name> --url
```

Open the service in a browser:

```bash
minikube service <service-name>
```

Tunnel for `LoadBalancer` services:

```bash
minikube tunnel
```

## Container images (Docker driver)

If you use the `docker` driver, your host Docker daemon is typically the cluster’s runtime, so local images are available immediately.

If you are *not* using the docker driver, load images into Minikube:

```bash
minikube image load myapp:dev
minikube image ls
```

## Mounts (host ↔ node)

```bash
minikube mount .:/work
```

## Multi-node

```bash
minikube start --nodes=2
kubectl get nodes -o wide
```

## Troubleshooting

- Driver issues: confirm available drivers with `minikube start --help` and pick one explicitly via `--driver=...`.
- “Stuck” cluster: `minikube stop && minikube delete && minikube start`.
- Networking weirdness: restart the driver (Docker Desktop/Hyper-V/VirtualBox) and re-create the cluster.
- Ingress: ensure the addon is enabled (`minikube addons enable ingress`) and that your Service is reachable (often `NodePort` + `minikube service ...`).

## Useful flags

```bash
minikube start --driver=docker --container-runtime=containerd
minikube start --addons=ingress,metrics-server
minikube start --extra-config=apiserver.service-node-port-range=1-65535
```
