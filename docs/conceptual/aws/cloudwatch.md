# AWS CloudWatch (Cheat Sheet)

Metrics, logs, alarms, dashboards, and event-driven automation primitives.

## Core concepts

- **Metrics**: time-series numbers (namespaces, dimensions)
- **Alarms**: thresholds/conditions triggering actions (SNS, auto scaling, etc.)
- **Logs**: log groups/streams; retention policy is critical

## Practical notes

- Set log retention explicitly (default “never expire” is a cost trap)
- Use structured logging (JSON) where possible for filtering

## Common operational gotchas

- High-cardinality metrics and logs can explode cost
- Missing alarms create “silent failures”; define SLO/SLA-driven alerts

