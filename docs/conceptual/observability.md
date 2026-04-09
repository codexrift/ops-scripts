# Observability Concepts Cheat Sheet

Observability helps you understand system behavior from the outside.

## The three pillars

- **Logs**: discrete events (errors, audit events)
- **Metrics**: numeric time series (CPU, latency, queue depth)
- **Traces**: request flows across services (spans)

## Practical recommendations

- Make logs structured (JSON if possible)
- Put IDs everywhere (request ID, trace ID, user/session ID)
- Prefer SLO-based alerting over "CPU > 80%" where possible

## Common anti-patterns

- Too many alerts (alert fatigue)
- No ownership for alerts
- Logs without context (no correlation IDs)
- No dashboards/runbooks for on-call

