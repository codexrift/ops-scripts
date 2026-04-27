---
title: "<Title: Do X safely in prod>"
type: "how-to"
owner: "<name or team>"
last_updated: "YYYY-MM-DD"
---

# <Title: Do X safely in prod>

<!--
How-to = goal-oriented. Assume the reader already knows the basics.
Prioritize correctness, safety, and a predictable outcome.
Avoid long teaching; link to Explanation/Tutorial for background.
-->

## Summary

- **Outcome:** <What "done" looks like>
- **Use when:** <When this guide applies>
- **Do not use when:** <Contraindications / wrong scenarios>
- **Time / effort:** <estimate>
- **Risk level:** <low|medium|high>

## Cheat sheet

Use this when you already know the procedure and need the fastest safe path.

### Pre-flight

```powershell
# Windows example
<identify targets>
<baseline checks>
```

```bash
# Linux/macOS example
<identify targets>
<baseline checks>
```

### Execute

```powershell
<commands>
```

```bash
<commands>
```

### Verify

```powershell
<verification commands>
```

```bash
<verification commands>
```

### Rollback

```powershell
<rollback commands>
```

```bash
<rollback commands>
```

## Preconditions

### Required access

- <Accounts required>
- <RBAC/roles>
- <Break-glass procedure if applicable>

### Required inputs

- <Hostnames / IDs / env>
- <Change request / ticket ID>
- <Approver / on-call contact>

### Required tools

- Windows: <PowerShell>, <tooling>
- Linux/macOS: <bash>, <tooling>

## Safety

### Impact and blast radius

- **Impact:** <what users/systems may notice>
- **Blast radius:** <single host / cluster / org-wide>

### Preconditions for running in `prod`

- [ ] Approved change window
- [ ] Backups/snapshots verified (or explicitly not applicable)
- [ ] Rollback tested (or rollback path documented)
- [ ] Monitoring/alerting acknowledged
- [ ] Communication plan ready (status page, #channel, email)

### Rollback plan (required)

**Rollback triggers**

- <e.g., error rate increases, latency, failed health checks>

**Rollback steps (high-level)**

1. <Step>
2. <Step>

**Rollback validation**

- <How to confirm rollback succeeded>

> **WARNING:** If rollback is not possible, explicitly state why and what the alternative mitigation is.

## Procedure

### 1) Pre-flight checks

Record evidence; keep output short and relevant.

#### Check: identify target

- Target environment: `<dev|stage|prod>`
- Target(s): `<hostnames/IDs>`

#### Check: health baseline

```powershell
# Windows example
<baseline check command>
```

```bash
# Linux/macOS example
<baseline check command>
```

**Expected**

- <Expected state>

### 2) Execute change

#### Step-by-step

1. <Do the thing>
2. <Do the thing>
3. <Do the thing>

#### Commands (copy/paste)

```powershell
<command>
```

```bash
<command>
```

#### Expected results

- <Expected output/state>

### 3) Post-change verification

#### Verification checklist

- [ ] Service healthy (`<health endpoint / command>`)
- [ ] Key metrics stable (`<metric names>`)
- [ ] Logs clean enough (`<error patterns to watch>`)
- [ ] Dependent systems OK (`<list>`)

#### Commands

```powershell
<verify command>
```

```bash
<verify command>
```

### 4) Closeout

- [ ] Update ticket with evidence and timestamps
- [ ] Notify stakeholders / on-call handoff
- [ ] Schedule follow-up (if needed)

## Troubleshooting

### If pre-flight fails

- <What to do>

### If execution fails

1. Stop and assess blast radius.
2. If a rollback trigger is met, follow: [Rollback plan](#rollback-plan-required)
3. Escalate to: `<team/channel/on-call>`

### Common errors

| Symptom | Likely cause | Fix | Evidence |
|---|---|---|---|
| `<symptom>` | <cause> | <fix> | <what to record> |

## Best Practices

- Prefer automation and idempotent steps when possible.
- Make changes in the smallest safe increments; verify between increments.
- Validate with a new session/connection, not a cached or already-open context.
- Always document rollback and the exact evidence you captured.

## Notes / exceptions

- <Edge cases, special environments, caveats>

## References

- <Link to Reference doc>
- <Link to Explanation doc>

