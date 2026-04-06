# kubectl Cheat Sheet

## Contexts & namespaces

```bash
kubectl config get-contexts
kubectl config current-context
kubectl config use-context <context>

kubectl get ns
kubectl config set-context --current --namespace=<ns>
```

## Get / describe

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc,ep,ing -n <ns>
kubectl describe pod <pod> -n <ns>
```

Wide output / watch:

```bash
kubectl get pods -n <ns> -o wide
kubectl get pods -n <ns> -w
```

## Apply / delete

```bash
kubectl apply -f manifest.yaml
kubectl apply -k ./kustomize-dir
kubectl delete -f manifest.yaml
```

## Logs & exec

```bash
kubectl logs -n <ns> <pod>
kubectl logs -n <ns> <pod> -c <container> -f --tail=200
kubectl exec -n <ns> -it <pod> -- sh
```

## Deployments / rollouts

```bash
kubectl get deploy -n <ns>
kubectl rollout status deploy/<name> -n <ns>
kubectl rollout restart deploy/<name> -n <ns>
kubectl rollout undo deploy/<name> -n <ns>
```

## Port-forward

```bash
kubectl port-forward -n <ns> svc/<svc> 8080:80
kubectl port-forward -n <ns> pod/<pod> 9000:9000
```

## Events & troubleshooting

```bash
kubectl get events -A --sort-by=.metadata.creationTimestamp
kubectl describe node <node>
```

Common quick checks:

```bash
kubectl get endpoints -n <ns>
kubectl get pod -n <ns> <pod> -o yaml
kubectl get pod -n <ns> <pod> -o jsonpath='{.status.containerStatuses[*].state}'
```

## Resource usage (if metrics available)

```bash
kubectl top nodes
kubectl top pods -A
```

