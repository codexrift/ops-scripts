# Helm Cheat Sheet

## Repos

```bash
# List configured chart repos
helm repo list

# Add a chart repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repo indexes
helm repo update

# Search charts in repos
helm search repo nginx
```

## Release lifecycle

```bash
# Install a release into a namespace (create namespace if missing)
helm install myapp ./chart -n <ns> --create-namespace

# Upgrade an existing release
helm upgrade myapp ./chart -n <ns>

# Upgrade if present, otherwise install
helm upgrade --install myapp ./chart -n <ns>

# Uninstall a release
helm uninstall myapp -n <ns>
```

## Releases

```bash
# List releases across all namespaces
helm list -A

# Show current status
helm status myapp -n <ns>

# Show revision history
helm history myapp -n <ns>

# Roll back to a revision number
helm rollback myapp 2 -n <ns>
```

## Values & manifests

```bash
# Show default chart values
helm show values ./chart

# Show user-supplied values for a release
helm get values myapp -n <ns>

# Fetch the rendered manifests for a release
helm get manifest myapp -n <ns>

# Render templates locally with an override values file
helm template myapp ./chart -n <ns> -f values.yaml
```

## Dependencies

```bash
# List chart dependencies
helm dependency list ./chart

# Fetch/update chart dependencies
helm dependency update ./chart
```

## Lint

```bash
# Lint a chart (basic best-practices checks)
helm lint ./chart
```
