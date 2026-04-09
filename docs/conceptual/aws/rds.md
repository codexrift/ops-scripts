# AWS RDS (Cheat Sheet)

Managed relational databases (MySQL, PostgreSQL, MariaDB, SQL Server, Oracle) in your VPC.

## Core concepts

- **DB instance**: the managed database compute
- **Storage**: gp3/io1; separate from compute sizing
- **Multi-AZ**: synchronous standby for HA (failover)
- **Read replica**: async replication for read scaling / DR patterns
- **Parameter group**: engine configuration

## Backups & recovery

- Automated backups + point-in-time restore (PITR)
- Manual snapshots for change control and long-term retention

## Security & networking

- Keep RDS in **private subnets** (no public access)
- SG rules should be “app → db” only (no 0.0.0.0/0)
- Use **KMS** encryption at rest; enforce TLS in transit
- Prefer IAM auth where supported; otherwise rotate secrets

## Common operational gotchas

- Minor/major version upgrades can be disruptive; test first
- Storage autoscaling helps, but capacity planning still matters
- Multi-AZ ≠ read scaling (it’s HA), use replicas for reads

