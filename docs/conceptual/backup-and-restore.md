# Backup and Restore Concepts Cheat Sheet

Backups are only useful if restores work.

## Key terms

- **RPO**: recovery point objective (max acceptable data loss)
- **RTO**: recovery time objective (max acceptable downtime)
- **Immutable backups**: cannot be modified/deleted for a retention period

## What to back up

- Data stores (DBs, object storage)
- Config and secrets (carefully, with encryption)
- Infrastructure definitions (IaC state/backends)

## The "3-2-1" idea (common guideline)

- 3 copies
- 2 different media/storage types
- 1 offsite/off-account

## Restore testing

- Schedule regular restore tests
- Test both:
  - small object restore (file/table)
  - full environment restore (if needed)

## Common pitfalls

- Backups exist but are not monitored
- Restore procedure not documented
- Credentials/keys needed for restore are missing/expired

