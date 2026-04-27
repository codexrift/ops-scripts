---
title: "<Title: Set up X from scratch>"
type: "tutorial"
owner: "<name or team>"
last_updated: "YYYY-MM-DD"
---

# <Title: Set up X from scratch>

<!--
Tutorial = learning-oriented. The reader should be able to follow along and understand what they are doing.
Keep an encouraging tone, explain "why" briefly, and include checkpoints and common mistakes.

Conventions (keep consistent across all docs):
- Placeholders use <angle brackets>.
- Commands are copy/paste-ready.
- Never include real secrets, tokens, private keys, or internal hostnames in examples.
- Use explicit OS headings when instructions differ (Windows / Linux / macOS).
- Use blockquote callouts:
  > **NOTE:** ...
  > **WARNING:** ...
  > **DANGER:** ...
-->

## Summary

- **Goal:** <What the learner will accomplish>
- **What you'll learn:** <2-5 bullets of concepts/skills>
- **Estimated time:** <e.g., 30-60 minutes>
- **Difficulty:** <beginner|intermediate|advanced>
- **Who this is for:** <you / role>

## Prerequisites

### Access and permissions

- <Accounts required (IdP, VPN, cloud, etc.)>
- <RBAC/roles required>
- <Approvals required (change request, security, etc.)>

### Required tools

List exact versions when it matters.

- Windows: <PowerShell version>, <OpenSSH>, <Git>, <package manager>
- Linux: <bash>, <openssh-client>, <curl>, <package manager>
- macOS: <zsh>, <brew>, <openssh>

### Inputs you must have

- <Hostname/IP (or how to obtain it)>
- <Usernames>
- <Paths>
- <Reference IDs>

## Safety and scope

### What this tutorial changes

- <Files modified>
- <Services restarted>
- <Firewall rules>
- <Cloud resources created>

### Risks

- <What can break and how>

### Rollback (high-level)

- <How to revert changes if you stop mid-way>

> **DANGER:** If you are working in `prod`, confirm you have an approved change window before proceeding.

## Before you start (sanity checks)

### Confirm your environment

Fill this in so you can copy/paste it into tickets later.

- Machine: `<hostname>`
- OS: `<version>`
- Network: `<VPN yes/no>`
- Target environment: `<dev|stage|prod>`

### Confirm connectivity (example)

#### Windows (PowerShell)

```powershell
ping <host>
Test-NetConnection -ComputerName <host> -Port <port>
```

#### Linux/macOS (bash/zsh)

```bash
ping -c 1 <host>
nc -vz <host> <port>
```

## Tutorial steps

### Step 1 - <Do the first thing>

**What you're doing:** <one sentence>

**Why it matters:** <one sentence>

#### Instructions

1. <Instruction>
2. <Instruction>

#### Example commands

```powershell
# Windows example
<command>
```

```bash
# Linux/macOS example
<command>
```

#### Checkpoint

You should see:

- <Expected output / state>

If you don't, go to: [Troubleshooting](#troubleshooting)

#### Common mistakes

- <Mistake> -> <How to fix>

---

### Step 2 - <Do the next thing>

**What you're doing:** <one sentence>

**Why it matters:** <one sentence>

#### Instructions

1. <Instruction>
2. <Instruction>

#### Checkpoint

- <Expected output / state>

---

### Step 3 - <Verify and finish>

#### Verification checklist

- [ ] <Check 1>
- [ ] <Check 2>
- [ ] <Check 3>

#### Evidence to capture

Include minimal proof that the tutorial worked.

- Command output: `<paste minimal snippet>`
- Screenshot (optional): `<path or link>`
- Links to created resources: `<URLs or IDs>`

## Cleanup (if this tutorial uses a lab)

- <Remove temp users/keys/files>
- <Delete test resources>
- <Revert config toggles>

## Troubleshooting

### Symptom: <what you see>

**Likely causes**

- <Cause>

**Fix**

```powershell
<command>
```

**Validation**

- <Expected result>

---

### Error catalog (quick)

| Error / Message | Meaning | Fix |
|---|---|---|
| `<error>` | <meaning> | <fix> |

## Best Practices

### Security best practices

- Use separate keys per purpose/device/environment (reduce blast radius).
- Use passphrases and an agent; store passphrases in a password manager.
- Avoid `ForwardAgent` unless you understand and accept the risk.
- Prefer least privilege: restrict which accounts can SSH and where they can log in.

### Operational best practices

- Validate changes with a **new session** (don't rely on an already-open session).
- Keep one known-good admin path (console/break-glass) before changing security policy.
- Capture minimal evidence (commands + outputs) for future troubleshooting.

## FAQ

**Q:** <question>  
**A:** <answer>

## Glossary

- **<Term>:** <definition>

## Next steps

- <Link to how-to guide for doing this in production>
- <Link to reference for commands/config options>
- <Link to explanation for architecture/tradeoffs>

