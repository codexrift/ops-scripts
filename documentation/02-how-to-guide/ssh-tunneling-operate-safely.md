---
title: "SSH tunneling how-to: create, verify, and shut down tunnels safely"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# SSH tunneling how-to: create, verify, and shut down tunnels safely

## Summary

- **Outcome:** Create SSH tunnels with safe binding defaults, verify connectivity, and leave clear evidence/rollback.
- **Use when:** You need temporary access to an internal service (DB, web admin, metrics) through an SSH-accessible host.
- **Do not use when:** A managed access solution exists (VPN/Zero Trust, private endpoints, SSO proxies) and tunnels are prohibited.
- **Time / effort:** 5-30 minutes
- **Risk level:** medium (easy to expose services if bound broadly)

## Cheat sheet

### Pre-flight

```bash
ssh <user>@<jump_host> "echo ok"
ssh <user>@<jump_host> "nc -vz <target_host> <target_port> || true"
```

### Local forward (-L) (recommended default)

```bash
ssh -N -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
  -L 127.0.0.1:<local_port>:<target_host>:<target_port> \
  <user>@<jump_host>
```

### Remote forward (-R) (use sparingly)

```bash
ssh -N -o ExitOnForwardFailure=yes \
  -R 127.0.0.1:<remote_port>:127.0.0.1:<local_port> \
  <user>@<jump_host>
```

### Dynamic forward (-D) (SOCKS proxy)

```bash
ssh -N -o ExitOnForwardFailure=yes -D 127.0.0.1:1080 <user>@<jump_host>
```

### Verify

```bash
nc -vz 127.0.0.1 <local_port>
curl -vk http://127.0.0.1:<local_port>/ || true
```

### Shutdown

- Foreground tunnel: Ctrl+C
- Background tunnel: find PID and terminate

## Preconditions

### Required access

- SSH access to `<jump_host>`
- Network path from `<jump_host>` to `<target_host>:<target_port>`
- Approval if tunneling to sensitive systems (DBs, admin consoles)

### Required inputs

- Ticket/incident: `<ID>`
- Jump host: `<jump_host>`
- Destination: `<target_host>:<target_port>`
- Local bind port: `<local_port>`
- Users who will consume the tunnel: `<who>`

### Required tools

- `ssh`
- Optional: `nc`, `curl`

## Safety

### Impact and blast radius

- **Impact:** Opens a path to a service that may bypass normal ingress controls.
- **Blast radius:** your machine (local forward) or remote host (remote forward) depending on bind addresses.

### Preconditions for running in `prod`

- [ ] Explicitly document path: `<jump_host> -> <target_host>:<target_port>`
- [ ] Use loopback binds (`127.0.0.1`) unless explicitly approved otherwise
- [ ] Confirm who can reach the bound port (local machine only vs network)
- [ ] Define shutdown condition (when you will close it)

### Rollback plan (required)

**Rollback triggers**

- The tunnel exposes sensitive access more broadly than intended.
- Verification suggests you reached an unexpected destination.

**Rollback steps (high-level)**

1. Stop the SSH process (Ctrl+C / kill PID).
2. Remove any proxy settings you changed (browser/tool).
3. If you changed server config (not recommended here), revert it.

**Rollback validation**

- The forwarded port no longer accepts connections.

## Procedure

### 1) Pre-flight checks

Record evidence; keep output short and relevant.

```bash
ssh <user>@<jump_host> "echo ok"
ssh <user>@<jump_host> "nc -vz <target_host> <target_port> || true"
```

Record:

- context: `<user>@<jump_host>`
- destination: `<target_host>:<target_port>`
- local bind: `127.0.0.1:<local_port>`

### 2) Create the tunnel

#### Local forward (default)

```bash
ssh -N -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
  -L 127.0.0.1:<local_port>:<target_host>:<target_port> \
  <user>@<jump_host>
```

#### Background it safely (optional)

```bash
ssh -fN -o ExitOnForwardFailure=yes \
  -L 127.0.0.1:<local_port>:<target_host>:<target_port> \
  <user>@<jump_host>
```

> **NOTE:** Keep a note of how you will stop it (PID lookup).

### 3) Verify

Verify using the same client/app that will consume the tunnel.

```bash
nc -vz 127.0.0.1 <local_port>
```

For web services:

```bash
curl -vk http://127.0.0.1:<local_port>/ || true
curl -vk https://127.0.0.1:<local_port>/ || true
```

### 4) Closeout

- [ ] Document the exact command used (including bind addresses).
- [ ] Document verification output (minimal).
- [ ] Close the tunnel when no longer needed.

## Troubleshooting

### If the tunnel connects but requests fail

- Confirm destination is reachable from the jump host.
- Confirm the service protocol (HTTP vs HTTPS vs raw TCP).
- Add SSH verbosity:

```bash
ssh -vvv -N -L 127.0.0.1:<local_port>:<target_host>:<target_port> <user>@<jump_host>
```

### If remote forwarding fails

Likely causes:

- `AllowTcpForwarding` disabled server-side
- `GatewayPorts` policy prevents non-loopback binds

Fix:

- Use loopback bind `127.0.0.1:<remote_port>` or use a local forward instead.

## Best Practices

- Prefer local forwards (`-L`) over remote forwards (`-R`) unless you need reverse connectivity.
- Always bind to loopback unless explicitly approved (`127.0.0.1`, not `0.0.0.0`).
- Use `ExitOnForwardFailure=yes` and keepalives for stability.
- Treat tunnels as temporary: set a shutdown time and close them.
- Avoid system-wide proxy changes for `-D`; use per-app SOCKS config.

## Notes / exceptions

- If you need multi-hop, prefer `ProxyJump` instead of nested manual forwarding.

## References

- `ops-scripts/documentation/03-reference/ssh-tunneling-reference.md`
- `ops-scripts/documentation/04-explanation/ssh-tunneling-mental-model.md`

