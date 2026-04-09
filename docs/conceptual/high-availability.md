# High Availability (HA) Concepts Cheat Sheet

HA is about continuing service despite failures.

## Common architectures

- **Active/passive**: one node serves, standby takes over on failure
- **Active/active**: multiple nodes serve simultaneously

## Failure domains

Define what failures you can tolerate:

- single process crash
- single VM/node loss
- single rack/zone failure
- region failure

## Key terms

- **RTO**: how long you can be down
- **RPO**: how much data loss you can tolerate
- **Failover**: switching service to a standby
- **Quorum**: majority agreement to avoid split brain

## Common pitfalls

- Shared dependency is a single point of failure (DB, DNS, identity provider)
- Failover untested (works in theory only)
- Split brain due to bad quorum design

