---
title: "Kubernetes observability how-to: deploy and operate Prometheus/Loki/Tempo/Grafana safely"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# Kubernetes observability how-to: deploy and operate Prometheus/Loki/Tempo/Grafana safely

## Summary

- **Outcome:** Deploy or operate a standard observability stack and verify metrics/logs/traces ingestion end-to-end.
- **Use when:** You are responsible for cluster observability or setting up a new cluster environment.
- **Do not use when:** Your org mandates a managed observability platform with a fixed deployment pattern.
- **Time / effort:** 30-180 minutes
- **Risk level:** medium (cluster-wide agents + storage can impact cluster resources)

## Cheat sheet

### Pre-flight

```bash
kubectl config current-context
kubectl config view --minify
kubectl get nodes
kubectl get ns
```

### Verify components are running

```bash
kubectl -n <monitoring_ns> get pods
kubectl -n <monitoring_ns> get svc
```

### Verify ingestion quickly (UI or API)

- Prometheus: targets up + sample queries
- Loki: query a known namespace
- Tempo: find traces for a known service

### Rollback

- If deployed via Helm: `helm rollback` / `helm uninstall` for the releases.

## Preconditions

### Required access

- cluster-admin (typical for CRDs + cluster-wide agents)
- storage class available (for TSDB/logs/traces) or a remote backend
- DNS + network policies allow required traffic

### Required inputs

- Ticket/change: `<ID>`
- Monitoring namespace: `<monitoring_ns>` (example: `monitoring`)
- Retention targets: `<metrics_retention>`, `<logs_retention>`, `<traces_retention>`
- Storage mode: `<in-cluster|remote>`
- Sizing expectations: `<nodes>`, `<pods>`, `<ingest_rate>`

### Required tools

- `kubectl`
- `helm` (if using charts)

## Safety

### Impact and blast radius

- **Impact:** Node agents run on all nodes; storage/ingest can consume CPU/memory/disk; misconfiguration can overload API and network.
- **Blast radius:** cluster-wide.

### Preconditions for running in `prod`

- [ ] Confirm sizing and storage plan (TSDB/logs/traces)
- [ ] Confirm retention and access policies
- [ ] Confirm network policies and TLS requirements
- [ ] Confirm dashboards/alerts ownership and on-call expectations

### Rollback plan (required)

**Rollback triggers**

- Cluster instability (API latency, node pressure, etc.)
- Storage exhaustion
- Ingestion storms or excessive cardinality

**Rollback steps (high-level)**

1. Disable or scale down ingest agents (fast stop-the-bleeding).
2. Roll back chart release(s) or revert manifests.
3. Verify cluster stability and then re-introduce with corrected settings.

**Rollback validation**

- Node and API health recover; stack components stabilize.

## Procedure

> **NOTE:** Exact charts and component names vary by org. Treat this as an operational checklist with placeholders.

### 1) Choose a deployment mode

Common choices:

- Helm charts (standardized)
- GitOps-managed releases (Flux/Argo)
- Managed service (vendor)

Record:

- chosen mode: `<mode>`
- source-of-truth repo/path: `<repo/path>`

### 2) Deploy core components (conceptual)

Minimum components for this stack:

- Prometheus (metrics scrape + storage) and alerting (Alertmanager optional)
- Loki (log storage) + log collector agent (DaemonSet)
- Tempo (trace storage) + trace collector (OTel Collector often)
- Grafana (UI + dashboards + datasources)

If using Helm, treat each component as a separate release or a bundled chart per org standard.

### 3) Configure ingestion

#### Metrics ingestion

- Ensure scrape discovery exists (e.g., ServiceMonitors/PodMonitors or static scrape configs).
- Ensure kube-state-metrics and node metrics (or equivalents) exist if you want cluster insights.

#### Logs ingestion

- Deploy a log agent as a DaemonSet.
- Ensure it attaches Kubernetes metadata labels (namespace, pod, container) in a consistent way.
- Ensure namespace include/exclude rules match your policy.

#### Traces ingestion

- Deploy an OpenTelemetry Collector (or equivalent) and configure apps to export traces.
- Ensure consistent resource attributes: `service.name`, `deployment.environment`, `k8s.namespace.name`.

### 4) Configure Grafana datasources and dashboards

- Add Prometheus, Loki, Tempo datasources.
- Import or define baseline dashboards:
  - cluster health
  - node/pod/resource usage
  - workload health
  - log error rate
  - trace latency by service

### 5) Verification checklist (required)

Metrics:

- [ ] Prometheus shows targets UP
- [ ] A basic query returns results (e.g., node CPU, pod count)

Logs:

- [ ] Loki query for a known namespace returns logs
- [ ] Labels exist (`namespace`, `pod`, `container` or your standard)

Traces:

- [ ] Tempo has traces for a known service
- [ ] Trace spans include `service.name` and namespace attributes

Grafana:

- [ ] Dashboards load without datasource errors

### 6) Operational guardrails

- Define retention and storage alarms (disk usage, ingestion rate, cardinality).
- Define access controls (who can query which namespaces).
- Define alert ownership (who receives what alerts, and where).

## Troubleshooting

### If Prometheus has no targets

- Check service discovery objects and RBAC.
- Check Prometheus operator/controller logs (if used).

### If Loki has no logs

- Confirm log agent DaemonSet is running on all nodes.
- Confirm filters aren't excluding your namespace.

### If Tempo has no traces

- Confirm apps are instrumented and exporting.
- Confirm OTel Collector pipeline and exporters are configured.

## Best Practices

- Start with a baseline set of signals; add more only when you have a consumer (dashboards/alerts).
- Control cardinality (labels/tags) and enforce conventions.
- Treat observability data as sensitive; define access + retention explicitly.
- Prefer GitOps to keep dashboards/datasources/config reproducible.

## Notes / exceptions

- If you run multiple clusters, standardize label keys (`cluster`, `env`) to make cross-cluster dashboards feasible.

## References

- `ops-scripts/documentation/03-reference/k8s-observability-reference.md`
- `ops-scripts/documentation/04-explanation/k8s-observability-how-it-works.md`

