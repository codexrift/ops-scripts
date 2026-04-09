# Secrets Concepts Cheat Sheet

Secrets are credentials or sensitive values that must be protected (API keys, DB passwords, cert private keys).

## Do not do this

- Store secrets in git
- Put secrets in plaintext config files
- Put secrets in build logs or chat

## Better patterns

- Use a secrets manager (vault/KMS-backed system)
- Rotate secrets regularly
- Use short-lived tokens where possible (OIDC, STS)
- Scope secrets narrowly (per app/env)

## Common gotchas

- Secrets in environment variables leak to process listings and crash dumps
- Backups contain secrets unless encrypted properly

