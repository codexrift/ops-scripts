# AWS SQS (Cheat Sheet)

Simple Queue Service: message queue for decoupling and buffering.

## Core concepts

- **Standard**: at-least-once delivery, best-effort ordering
- **FIFO**: ordered within message group, exactly-once processing features
- **Visibility timeout**: time a message is hidden after being received
- **DLQ**: dead-letter queue for poison messages

## Design notes

- Assume duplicates; make consumers idempotent
- Use appropriate batch size and visibility timeout for processing time

## Common operational gotchas

- Too-short visibility timeout causes duplicate processing
- Large payloads need S3 offload pattern
- DLQs are useless without alarms and a replay process

