# Patching Concepts Cheat Sheet

Patching keeps systems secure and stable, but carries change risk.

## Strategy

- Define cadence (weekly/monthly) and emergency process
- Use canaries/rings (patch a small subset first)
- Automate where possible (but monitor)

## Rollback planning

- OS patches: snapshots/images help
- App patches: versioned deploys + rollback button

## Common pitfalls

- No inventory (unknown systems never patched)
- Patching without maintenance windows/communication
- Patching breaks dependencies (kernel modules, drivers)

