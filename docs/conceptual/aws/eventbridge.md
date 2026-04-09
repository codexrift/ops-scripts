# AWS EventBridge (Cheat Sheet)

Event bus for routing events between AWS services and your applications.

## Core concepts

- **Event bus**: default or custom bus
- **Rule**: pattern match + target(s)
- **Target**: Lambda, SQS, SNS, Step Functions, API destinations, etc.

## Design notes

- Prefer event-driven integration over tight coupling
- Treat events as immutable facts; include correlation IDs and timestamps

## Common operational gotchas

- Events can be duplicated; consumers should be idempotent
- Mis-specified patterns silently drop events; test with samples

