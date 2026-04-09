# AWS DynamoDB (Cheat Sheet)

Managed NoSQL key-value and document database with predictable performance.

## Core concepts

- **Partition key / sort key**: primary key design drives scalability
- **GSI**: secondary indexes for alternate query patterns
- **Capacity**: on-demand or provisioned (with autoscaling)
- **Streams**: change data capture for event-driven processing

## Design notes

- Model access patterns first, then design keys/indexes
- Avoid hot partitions (skewed keys)

## Common operational gotchas

- Strong consistency vs eventual consistency tradeoffs
- Item size limits and query patterns can force redesigns later

