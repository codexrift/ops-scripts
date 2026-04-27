---
title: "Kubernetes observability tutorial: metrics + logs + traces (Prometheus, Loki, Tempo, Grafana)"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-27"
---

# Kubernetes observability tutorial: metrics + logs + traces (Prometheus, Loki, Tempo, Grafana)

## Summary

- **Goal:** Learn the "three pillars" workflow on Kubernetes: find an issue -> inspect metrics -> inspect logs -> inspect traces -> correlate.
- **What you'll learn:**
  - What each component does (Prometheus, Loki, Tempo, Grafana)
  - How to verify signal pipelines are working
  - Basic queries (PromQL, LogQL) and trace exploration
  - How to correlate signals with consistent labels/attributes
- **Estimated time:** 45-120 minutes
- **Difficulty:** beginner -> intermediate
- **Who this is for:** you

## Prerequisites

### Access and permissions

- Access to a Kubernetes cluster with an observability stack installed (sandbox preferred)
- Access to Grafana (or the UI your stack uses)
- RBAC to read Pods/Services in at least one namespace

### Required tools

- `kubectl`
- Browser access to Grafana (or port-forward access)

### Inputs you must have

- Namespace(s) used by the stack: `<monitoring_ns>`, `<logging_ns>` (often the same)
- Grafana URL: `<grafana_url>`
- A sample workload namespace: `<app_ns>`

## Safety and scope

### What this tutorial changes

- Mostly read-only. Optional: creates a temporary port-forward to Grafana.

### Risks

- None to low. Avoid sharing dashboards/URLs containing sensitive metadata publicly.

### Rollback (high-level)

- Stop any port-forward processes you start.

## Before you start (sanity checks)

### Confirm cluster targeting

```bash
kubectl config current-context
kubectl config view --minify
```

### Confirm the stack is running (example names)

```bash
kubectl -n <monitoring_ns> get pods
kubectl -n <monitoring_ns> get svc
```

Checkpoint:

- Grafana and the backends (Prometheus/Loki/Tempo) have running pods.

## Tutorial steps

### Step 1 - Get into Grafana (safely)

**What you're doing:** Access the UI to query metrics/logs/traces.

**Why it matters:** Grafana is the central point of correlation for this stack.

If Grafana isn't exposed, port-forward:

```bash
kubectl -n <monitoring_ns> port-forward svc/<grafana_service> 3000:80
```

Open: `http://127.0.0.1:3000`

Checkpoint:

- Grafana loads and you can see datasources (Prometheus/Loki/Tempo).

---

### Step 2 - Metrics (Prometheus): answer "what is happening?"

**What you're doing:** Run a simple PromQL query and interpret it.

**Why it matters:** Metrics are best for trend/threshold detection and fleet-level signals.

In Grafana Explore -> Prometheus datasource, try:

- Cluster capacity (example):
  - `sum(rate(container_cpu_usage_seconds_total[5m]))`

Or per-namespace traffic (if available in your metrics set):

- `sum by (namespace) (rate(http_requests_total[5m]))`

Checkpoint:

- You see a time series and can change the time range and refresh.

Common mistakes:

- High-cardinality labels make queries slow and expensive.

---

### Step 3 - Logs (Loki): answer "why is it happening?"

**What you're doing:** Query logs for a workload and filter to errors.

**Why it matters:** Logs provide detailed event context and error messages.

In Grafana Explore -> Loki datasource, try:

```logql
{namespace="<app_ns>"} |= "error"
```

Then narrow to a specific workload label if your log pipeline adds it:

```logql
{namespace="<app_ns>", app="<app_label>"} |= "error"
```

Checkpoint:

- You can find error bursts that align with a metric spike.

> **WARNING:** Avoid logging secrets. Logs often have broad access and long retention.

---

### Step 4 - Traces (Tempo): answer "where is it happening?"

**What you're doing:** Find traces for a service and identify slow/error spans.

**Why it matters:** Tracing shows latency breakdown across services and dependencies.

In Grafana Explore -> Tempo datasource:

- Search by service name: `<service_name>`
- Filter by latency or error (depending on UI capabilities)

Checkpoint:

- You can open a trace and see a span waterfall.

---

### Step 5 - Correlation: connect metrics -> logs -> traces

**What you're doing:** Use shared identifiers to pivot between signals.

**Why it matters:** Correlation turns observability from "three silos" into a workflow.

Common correlation keys (examples; depends on pipeline):

- `namespace`, `pod`, `container`
- `service.name` (OTel)
- `trace_id` embedded in logs
- `cluster`, `environment`

Checkpoint:

- You can start from a metric, identify a workload, and find matching logs/traces in the same time window.

## Cleanup (if this tutorial uses a lab)

- Stop port-forward: Ctrl+C.

## Troubleshooting

### Symptom: Grafana loads but no data

Likely causes:

- Datasources misconfigured
- Backends down
- No scrape/ingest pipeline for your namespace

Fix:

```bash
kubectl -n <monitoring_ns> get pods
kubectl -n <monitoring_ns> logs deploy/<prometheus_or_agent> --tail=200
kubectl -n <monitoring_ns> logs deploy/<loki_or_agent> --tail=200
kubectl -n <monitoring_ns> logs deploy/<tempo_or_agent> --tail=200
```

### Error catalog (quick)

| Symptom | Likely cause | Fix |
|---|---|---|
| Empty metrics | scrape config missing | verify ServiceMonitors/targets |
| Empty logs | log agent not collecting | verify DaemonSet and namespace filters |
| Empty traces | instrumentation missing | verify OTel collector and app config |

## Best Practices

- Keep label/cardinality under control (cost + performance).
- Standardize naming and tags across signals (`cluster`, `env`, `service`).
- Redact secrets and PII at source; don't rely on "we won't query it".
- Define retention and access policies explicitly (observability data is sensitive).

## FAQ

**Q:** Do I need all three (metrics/logs/traces)?  
**A:** You can start with metrics + logs, but tracing accelerates root cause for distributed systems.

## Glossary

- **PromQL:** query language for Prometheus metrics.
- **LogQL:** query language for Loki logs.
- **Span:** a unit of work in a trace.

## Next steps

- How-to: `ops-scripts/documentation/02-how-to-guide/k8s-observability-operate-stack.md`
- Reference: `ops-scripts/documentation/03-reference/k8s-observability-reference.md`
- Explanation: `ops-scripts/documentation/04-explanation/k8s-observability-how-it-works.md`

