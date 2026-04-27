---
title: "SSH tunneling reference (OpenSSH port forwarding)"
type: "reference"
owner: "u115478"
last_updated: "2026-04-27"
---

# SSH tunneling reference (OpenSSH port forwarding)

## Scope

- **In scope:** OpenSSH forwarding flags and patterns: `-L`, `-R`, `-D`, `-J`, safe bind defaults, verification commands.
- **Out of scope:** VPN/Zero Trust products, application proxies, long-lived production access architectures.

## Cheat sheet

| Task | Command |
|---|---|
| Local forward | `ssh -N -L 127.0.0.1:<lport>:<host>:<rport> <user>@<jump>` |
| Remote forward | `ssh -N -R 127.0.0.1:<rport>:<host>:<lport> <user>@<jump>` |
| Dynamic (SOCKS) | `ssh -N -D 127.0.0.1:1080 <user>@<jump>` |
| Multi-hop via jump | `ssh -N -J <user>@bastion -L 127.0.0.1:<lport>:<host>:<rport> <user>@internal` |
| Fail fast | `-o ExitOnForwardFailure=yes` |
| Keepalive | `-o ServerAliveInterval=30 -o ServerAliveCountMax=3` |
| Debug | `-v` / `-vvv` |
| Verify local listener | `nc -vz 127.0.0.1 <lport>` |

## Quick start (minimal)

```bash
ssh -N -o ExitOnForwardFailure=yes -L 127.0.0.1:15432:db.internal:5432 <user>@bastion
```

## Interfaces

### CLI commands

#### Port forwarding flags

**Synopsis**

```text
ssh [options] -L [bind_address:]port:host:hostport [user@]hostname
ssh [options] -R [bind_address:]port:host:hostport [user@]hostname
ssh [options] -D [bind_address:]port [user@]hostname
```

**Key options**

| Option | Type | Default | Description |
|---|---|---|---|
| `-N` | bool | off | Do not execute remote command (tunnel-only) |
| `-f` | bool | off | Background after auth (use with care) |
| `-J <jump>` | string | (none) | ProxyJump (bastion) |
| `-L ...` | spec | (none) | Local forward |
| `-R ...` | spec | (none) | Remote forward |
| `-D ...` | spec | (none) | Dynamic forward (SOCKS) |
| `-o ExitOnForwardFailure=yes` | bool | no | Exit if forward cannot be established |
| `-o ServerAliveInterval=<n>` | int | 0 | Keepalive interval |
| `-o ServerAliveCountMax=<n>` | int | 3 | Keepalive retries |
| `-o IdentitiesOnly=yes` | bool | no | Offer only configured identities |

**Bind address guidance**

| Bind | Meaning | Risk |
|---|---|---|
| `127.0.0.1:<port>` | only local machine can connect | lowest |
| `<LAN_IP>:<port>` | reachable from your LAN | medium/high |
| `0.0.0.0:<port>` | reachable from any interface | highest |

---

#### Local forward (`-L`)

```bash
ssh -N -o ExitOnForwardFailure=yes \
  -L 127.0.0.1:15432:db.internal:5432 \
  <user>@bastion
```

Destination host resolution:

- `db.internal` is resolved from the SSH server side (the host you SSH into).

---

#### Remote forward (`-R`)

```bash
ssh -N -o ExitOnForwardFailure=yes \
  -R 127.0.0.1:18080:127.0.0.1:3000 \
  <user>@bastion
```

Notes:

- Server policy can restrict remote forwarding (`AllowTcpForwarding`, `GatewayPorts`).

---

#### Dynamic forward (`-D`) (SOCKS)

```bash
ssh -N -D 127.0.0.1:1080 <user>@bastion
```

### Configuration

#### Canonical `~/.ssh/config` patterns

```sshconfig
Host bastion
  HostName <jump_host>
  User <user>
  IdentityFile ~/.ssh/id_ed25519_<purpose>
  IdentitiesOnly yes
  ServerAliveInterval 30
  ServerAliveCountMax 3
```

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `<none>` | no | n/a | (none required for basic forwarding) |

## Best Practices

- Default to loopback binds; never use `0.0.0.0` casually.
- Prefer `ProxyJump` for multi-hop rather than manual nesting.
- Keep examples safe; do not suggest disabling host key checking.

## Security

### Authentication and authorization

- Forwarding is controlled by server policy and account permissions.
- Treat a tunnel as granting network reachability to the destination.

### Secrets handling

- Do not embed credentials in forwarded URLs or shell history.
- Avoid copying secrets through tunnels into logs/terminals.

## Observability

```bash
ssh -vvv -N -L 127.0.0.1:<lport>:<host>:<rport> <user>@<jump>
```

## Compatibility

- Works with OpenSSH clients on Windows, Linux, and macOS.
- Remote forwarding may be restricted by server configuration.

## Limits and known behaviors

- Forwards are TCP by default.
- A successful SSH connection does not guarantee the destination is reachable; verify from the consumer side.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |

