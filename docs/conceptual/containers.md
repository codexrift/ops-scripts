# Containers Concepts Cheat Sheet

Containers package an application and its dependencies into an image that runs as an isolated process.

## Key terms

- **Image**: immutable template (layers)
- **Container**: running instance of an image
- **Registry**: stores images (Docker Hub, ECR, ACR, GCR, Artifactory)
- **Tag**: human-friendly label (mutable); use digests for immutability

## Isolation basics

- Namespaces: process/network/mount isolation
- cgroups: CPU/memory limits

## Common operational gotchas

- "Works on laptop" due to implicit env vars or bind mounts
- Secrets baked into images
- Running as root inside the container
- No resource limits -> noisy neighbor issues

