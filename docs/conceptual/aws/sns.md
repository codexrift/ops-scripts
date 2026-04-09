# AWS SNS (Cheat Sheet)

Simple Notification Service: pub/sub fan-out and notifications.

## Core concepts

- **Topic**: publisher sends messages to a topic
- **Subscription**: endpoint receiving messages (SQS, Lambda, HTTP/S, email, etc.)
- **Message filtering**: route subsets of messages to different subscribers

## Common patterns

- SNS -> SQS (durable fan-out)
- SNS -> Lambda (event-driven processing)

## Common operational gotchas

- HTTP/S endpoints need retries/idempotency; failures can cause redeliveries
- Email/SMS are not reliable delivery for critical workflows; prefer queues

