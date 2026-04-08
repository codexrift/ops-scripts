# Minikube Cheat Sheet

Local single-node (or multi-node) Kubernetes clusters for development/testing.

## Quick start

```bash
# Start a cluster
minikube start

# Show cluster status
minikube status

# Confirm node(s) are ready
kubectl get nodes
```

Pick a driver explicitly (common choices: `docker`, `hyperv`, `virtualbox`, `qemu`, `kvm2`):

```bash
# Start using a specific driver
minikube start --driver=docker
```

Resources:

```bash
# Start with custom CPU/RAM/disk resources
minikube start --cpus=4 --memory=8192 --disk-size=40g
```

## Profiles (multiple clusters)

```bash
# List profiles
minikube profile list

# Start a profile named dev
minikube start -p dev

# Start a profile with an explicit Kubernetes version
minikube start -p demo --kubernetes-version=v1.29.6

# Delete a specific profile
minikube delete -p demo
```

## Common operations

```bash
# Pause cluster
minikube pause

# Unpause cluster
minikube unpause

# Stop cluster
minikube stop

# Start cluster
minikube start

# Delete cluster
minikube delete
```

Cluster info:

```bash
# Show cluster IP (driver-dependent)
minikube ip

# SSH into the node VM/container (driver-dependent)
minikube ssh

# Show minikube logs
minikube logs

# Show minikube config
minikube config view
```

## kubectl integration

Minikube can bundle `kubectl`:

```bash
# Use the kubectl bundled with minikube
minikube kubectl -- get pods -A
```

Or use your own `kubectl` and confirm context:

```bash
# List kubeconfig contexts
kubectl config get-contexts

# Show current context
kubectl config current-context

# Show cluster endpoints and components
kubectl cluster-info
```

## Addons

```bash
# List addons
minikube addons list

# Enable metrics-server addon
minikube addons enable metrics-server

# Enable ingress addon
minikube addons enable ingress

# Disable ingress addon
minikube addons disable ingress
```

## Dashboard

```bash
# Launch the dashboard
minikube dashboard
```

## Accessing services

Get a URL (works well with `NodePort`):

```bash
# Print a URL for a Service (often NodePort)
minikube service <service-name> --url
```

Open the service in a browser:

```bash
# Open a Service in your browser
minikube service <service-name>
```

Tunnel for `LoadBalancer` services:

```bash
# Create a tunnel for LoadBalancer Services (requires privileges)
minikube tunnel
```

## Container images (Docker driver)

If you use the `docker` driver, your host Docker daemon is typically the cluster's runtime, so local images are available immediately.

If you are *not* using the docker driver, load images into Minikube:

```bash
# Load a local image into minikube
minikube image load myapp:dev

# List images in minikube
minikube image ls
```

## Mounts (host <-> node)

```bash
# Mount a host directory into the minikube node
minikube mount .:/work
```

## Multi-node

```bash
# Start a 2-node cluster
minikube start --nodes=2

# List nodes with details
kubectl get nodes -o wide
```

## Troubleshooting

- Driver issues: confirm available drivers with `minikube start --help` and pick one explicitly via `--driver=...`.
- "Stuck" cluster: `minikube stop && minikube delete && minikube start`.
- Networking weirdness: restart the driver (Docker Desktop/Hyper-V/VirtualBox) and re-create the cluster.
- Ingress: ensure the addon is enabled (`minikube addons enable ingress`) and that your Service is reachable (often `NodePort` + `minikube service ...`).

## Useful flags

```bash
# Start with docker driver and containerd runtime
minikube start --driver=docker --container-runtime=containerd

# Start with a set of addons enabled
minikube start --addons=ingress,metrics-server

# Start with extra component config
minikube start --extra-config=apiserver.service-node-port-range=1-65535
```
