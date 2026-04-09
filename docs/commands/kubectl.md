# kubectl Cheat Sheet

## Contexts & namespaces

```bash
# List contexts
kubectl config get-contexts

# Show current context
kubectl config current-context

# Switch context
kubectl config use-context <context>

# List namespaces
kubectl get ns

# Set default namespace for current context
kubectl config set-context --current --namespace=<ns>
```

## Get / describe

```bash
# List nodes
kubectl get nodes

# List pods in all namespaces
kubectl get pods -A

# List common resources in a namespace
kubectl get svc,ep,ing -n <ns>

# Describe a pod (events, volumes, containers)
kubectl describe pod <pod> -n <ns>
```

Wide output / watch:

```bash
# List pods with node/IP and other columns
kubectl get pods -n <ns> -o wide

# Watch pod changes
kubectl get pods -n <ns> -w
```

## Apply / delete

```bash
# Apply a manifest file
kubectl apply -f manifest.yaml

# Apply a kustomization directory
kubectl apply -k ./kustomize-dir

# Delete resources defined in a manifest file
kubectl delete -f manifest.yaml
```

## Logs & exec

```bash
# Show logs for a pod (default container)
kubectl logs -n <ns> <pod>

# Follow logs for a specific container
kubectl logs -n <ns> <pod> -c <container> -f --tail=200

# Exec into a pod
kubectl exec -n <ns> -it <pod> -- sh
```

## Deployments / rollouts

```bash
# List deployments
kubectl get deploy -n <ns>

# Wait for a rollout to complete
kubectl rollout status deploy/<name> -n <ns>

# Trigger a restart (rollout)
kubectl rollout restart deploy/<name> -n <ns>

# Roll back to previous revision
kubectl rollout undo deploy/<name> -n <ns>
```

## Port-forward

```bash
# Forward local port 8080 to service port 80
kubectl port-forward -n <ns> svc/<svc> 8080:80

# Forward local port 9000 to pod port 9000
kubectl port-forward -n <ns> pod/<pod> 9000:9000
```

## Events & troubleshooting

```bash
# List events sorted by timestamp
kubectl get events -A --sort-by=.metadata.creationTimestamp

# Describe a node
kubectl describe node <node>
```

Common quick checks:

```bash
# Show endpoints in a namespace
kubectl get endpoints -n <ns>

# Dump a pod spec/status as YAML
kubectl get pod -n <ns> <pod> -o yaml

# Extract container state with jsonpath
kubectl get pod -n <ns> <pod> -o jsonpath='{.status.containerStatuses[*].state}'
```

## Resource usage (if metrics available)

```bash
# Show node metrics (requires metrics-server)
kubectl top nodes

# Show pod metrics across all namespaces
kubectl top pods -A
```
