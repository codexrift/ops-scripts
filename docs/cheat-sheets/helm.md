# Helm Cheat Sheet

## Repos

```bash
helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo nginx
```

## Release lifecycle

```bash
helm install myapp ./chart -n <ns> --create-namespace
helm upgrade myapp ./chart -n <ns>
helm upgrade --install myapp ./chart -n <ns>
helm uninstall myapp -n <ns>
```

## Releases

```bash
helm list -A
helm status myapp -n <ns>
helm history myapp -n <ns>
helm rollback myapp 2 -n <ns>
```

## Values & manifests

```bash
helm show values ./chart
helm get values myapp -n <ns>
helm get manifest myapp -n <ns>
helm template myapp ./chart -n <ns> -f values.yaml
```

## Dependencies

```bash
helm dependency list ./chart
helm dependency update ./chart
```

## Lint

```bash
helm lint ./chart
```
