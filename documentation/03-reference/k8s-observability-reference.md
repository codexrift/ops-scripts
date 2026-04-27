---
title: "Kubernetes observability reference (PromQL, LogQL, traces, Grafana)"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# Kubernetes observability reference (PromQL, LogQL, traces, Grafana)

## Scope

- **In scope:** common queries and operational checks for Prometheus, Loki, Tempo, Grafana.
- **Out of scope:** full query language specifications, vendor-specific dashboards and alert catalogs.

## Cheat sheet

| Task | Example |
|---|---|
| Prometheus targets | Prometheus UI -> Targets (or operator status) |
| Quick CPU (cluster) | `sum(rate(container_cpu_usage_seconds_total[5m]))` |
| Quick memory (cluster) | `sum(container_memory_working_set_bytes)` |
| Logs by namespace | `{namespace="<ns>"}` |
| Error logs | `{namespace="<ns>"} |= "error"` |
| Recent Kubernetes events | `kubectl get events -A --sort-by=.lastTimestamp | tail -n 50` |
| Trace search | Tempo -> search by `service.name` |

## Quick start (minimal)

```bash
kubectl -n <monitoring_ns> get pods
```

## Interfaces

### Metrics (Prometheus)

#### PromQL patterns

| Goal | Example |
|---|---|
| rate over time | `rate(<counter>[5m])` |
| sum by label | `sum by (namespace) (rate(http_requests_total[5m]))` |
| error ratio | `sum(rate(http_requests_total{code=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))` |
| p95 latency (histogram) | `histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))` |

> **NOTE:** Exact metric names depend on your instrumentation and exporters.

### Logs (Loki)

#### LogQL patterns

| Goal | Example |
|---|---|
| basic selector | `{namespace="<ns>"}` |
| filter contains | `{namespace="<ns>"} |= "error"` |
| regexp filter | `{namespace="<ns>"} |~ "timeout|failed"` |
| label narrowing | `{namespace="<ns>", app="<app>"}` |

### Traces (Tempo)

#### Common trace attributes

| Attribute | Meaning |
|---|---|
| `service.name` | service identity (OTel) |
| `deployment.environment` | environment (dev/stage/prod) |
| `k8s.namespace.name` | namespace |
| `k8s.pod.name` | pod |

### Grafana

#### Useful UI locations

- Explore: ad-hoc query and correlation across datasources
- Dashboards: predefined views
- Alerting: rules + contact points (if configured)
- Datasources: verify connectivity and permissions

### Configuration

#### Label/cardinality conventions (recommended)

| Key | Purpose |
|---|---|
| `cluster` | cluster identity |
| `env` | environment |
| `namespace` | namespace |
| `service` / `service.name` | service identity |

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `<none>` | no | n/a | depends on deployment |

## Best Practices

- Keep Reference scannable; put multi-step work in the How-to guide.
- Control cardinality and define label conventions early.
- Treat observability data as sensitive; avoid querying/exporting more than needed.

## Security

### Authentication and authorization

- Use least-privilege: teams should see only the namespaces/signals they own if required.

### Secrets handling

- Avoid logging secrets; redact at source.

## Observability

### Cluster quick checks

```bash
kubectl -n <monitoring_ns> get pods
kubectl -n <monitoring_ns> get svc
```

## Compatibility

- Query availability depends on what exporters/instrumentation are deployed.

## Limits and known behaviors

- Cardinality explosions can make metrics expensive and slow; logs can become cost sinks without filters/retention.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

