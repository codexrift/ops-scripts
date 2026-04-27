---
title: "SSH tunneling tutorial: local (-L), remote (-R), and dynamic (-D)"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-27"
---

# SSH tunneling tutorial: local (-L), remote (-R), and dynamic (-D)

## Summary

- **Goal:** Learn how to create SSH tunnels safely and verify they work.
- **What you'll learn:**
  - The difference between local, remote, and dynamic tunnels
  - How to choose bind addresses safely (`127.0.0.1` vs `0.0.0.0`)
  - How to verify a tunnel (connectivity + process checks)
  - How to avoid common security mistakes (exposing ports, forwarding agents)
- **Estimated time:** 30-60 minutes
- **Difficulty:** beginner -> intermediate
- **Who this is for:** you

## Prerequisites

### Access and permissions

- You can SSH to a bastion/intermediate host: `<user>@<jump_host>`
- The bastion can reach the target service: `<target_host>:<target_port>`
- You are allowed by policy to tunnel to the target service

### Required tools

- OpenSSH client (`ssh`)
- Optional: `curl`, `nc` (or PowerShell `Test-NetConnection`)

### Inputs you must have

- Jump host: `<jump_host>`
- SSH user: `<user>`
- Target service host: `<target_host>`
- Target service port: `<target_port>`

## Safety and scope

### What this tutorial changes

- Starts one or more local SSH processes that forward TCP ports.
- Does not change server config by default.

### Risks

- Binding a tunnel to `0.0.0.0` can expose a sensitive service to your network.
- `-R` remote forwards can unintentionally expose services on the remote side.
- `-D` SOCKS proxies can route more traffic than intended if misconfigured.

### Rollback (high-level)

- Stop the SSH process (Ctrl+C) or kill it by PID.
- Remove any temporary proxy settings you changed.

> **DANGER:** Default to binding forwards to `127.0.0.1` unless you have a specific, approved reason to expose them more broadly.

## Before you start (sanity checks)

### Confirm SSH works

```bash
ssh -V
ssh <user>@<jump_host> "echo ok"
```

Checkpoint:

- You can SSH to `<jump_host>`.

### Confirm the jump host can reach the target service

```bash
ssh <user>@<jump_host> "nc -vz <target_host> <target_port> || true"
```

## Tutorial steps

### Step 1 - Local port forward (-L): access a remote service from your machine

**What you're doing:** Open a local port on your workstation that forwards through SSH to a target host/port.

**Why it matters:** This is the most common tunnel: "make remote service look local".

Run on your workstation:

```bash
ssh -N -L 127.0.0.1:<local_port>:<target_host>:<target_port> <user>@<jump_host>
```

Notes:

- `-N` means "no remote command" (tunnel only).
- Prefer `127.0.0.1:<local_port>` so only your machine can connect.

#### Verify (workstation)

In a second terminal:

```bash
nc -vz 127.0.0.1 <local_port>
```

Checkpoint:

- A connection to `127.0.0.1:<local_port>` succeeds.

Common mistakes:

- Using the wrong `<target_host>` (resolved from the jump host, not your workstation).
- Picking a `<local_port>` already in use.

Stop the tunnel with Ctrl+C.

---

### Step 2 - Add safety and debugging flags

**What you're doing:** Make failures obvious and gather good logs.

**Why it matters:** Silent failures waste time and can create false confidence.

```bash
ssh -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
  -L 127.0.0.1:<local_port>:<target_host>:<target_port> \
  <user>@<jump_host>
```

Checkpoint:

- If the forward cannot be established, SSH exits with a non-zero status.

---

### Step 3 - Remote port forward (-R): allow the remote side to reach something local

**What you're doing:** Open a port on the remote host that forwards back to your workstation (or another reachable destination).

**Why it matters:** Useful for temporary callbacks, demos, or reverse access.

> **WARNING:** Remote forwards can expose services on the remote side. Default to `127.0.0.1` binding on the remote host.

```bash
ssh -N -R 127.0.0.1:18080:127.0.0.1:3000 <user>@<jump_host>
```

Verify from the jump host:

```bash
ssh <user>@<jump_host> "nc -vz 127.0.0.1 18080"
```

Checkpoint:

- The remote listener accepts connections on `127.0.0.1:18080`.

---

### Step 4 - Dynamic forward (-D): create a SOCKS proxy

**What you're doing:** Create a local SOCKS proxy that sends traffic through the jump host.

**Why it matters:** Useful for tools/browsers without creating many individual `-L` forwards.

```bash
ssh -N -D 127.0.0.1:1080 <user>@<jump_host>
```

Checkpoint:

- A single application configured with SOCKS5 `127.0.0.1:1080` can reach internal addresses.

## Cleanup (if this tutorial uses a lab)

- Stop all SSH tunnel processes you started.
- Remove any temporary proxy settings from applications.

## Troubleshooting

### Symptom: tunnel is up but the service doesn't work

Likely causes:

- Destination not reachable from jump host.
- Protocol mismatch (HTTP vs HTTPS vs raw TCP).

Fix:

```bash
ssh -vvv -N -L 127.0.0.1:<local_port>:<target_host>:<target_port> <user>@<jump_host>
```

### Error catalog (quick)

| Error / Message | Meaning | Fix |
|---|---|---|
| `connect failed` | jump host can't reach destination | validate from jump host |
| `Address already in use` | local port taken | choose another port |
| `remote port forwarding failed` | remote bind denied | bind to `127.0.0.1` or use `-L` |

## Best Practices

- Bind forwards to loopback unless approved otherwise.
- Use `-o ExitOnForwardFailure=yes`.
- Keep tunnels short-lived; document why they exist and when to shut them down.
- Prefer `ProxyJump` for multi-hop SSH rather than manual chaining.

## FAQ

**Q:** What's the difference between `-L` and `-D`?  
**A:** `-L` forwards one specific host/port; `-D` creates a SOCKS proxy that can reach many destinations through the SSH host.

## Glossary

- **Local forward (`-L`):** local port -> remote destination through SSH.
- **Remote forward (`-R`):** remote port -> local destination through SSH.
- **Dynamic forward (`-D`):** local SOCKS proxy through SSH.

## Next steps

- How-to: `ops-scripts/documentation/02-how-to-guide/ssh-tunneling-operate-safely.md`
- Reference: `ops-scripts/documentation/03-reference/ssh-tunneling-reference.md`
- Explanation: `ops-scripts/documentation/04-explanation/ssh-tunneling-mental-model.md`

