---
title: "SSH (OpenSSH) reference"
type: "reference"
last_updated: "2026-04-27"
---

# SSH (OpenSSH) reference

## Scope

- **In scope:** common OpenSSH client/server commands, config locations, key formats, and high-signal troubleshooting references.
- **Out of scope:** vendor-specific access platforms (PAM, SSO SSH CAs), full cryptography deep dive.

## Cheat sheet

| Task | Command |
|---|---|
| Connect | `ssh <user>@<host>` |
| Non-default port | `ssh -p <port> <user>@<host>` |
| Use a specific key | `ssh -i ~/.ssh/id_ed25519_<purpose> <user>@<host>` |
| Debug auth | `ssh -vvv -i ~/.ssh/id_ed25519_<purpose> <user>@<host>` |
| Add a key to agent | `ssh-add ~/.ssh/id_ed25519_<purpose>` |
| List keys in agent | `ssh-add -l` |
| Remove old host key | `ssh-keygen -R <host>` |
| Show pubkey fingerprint | `ssh-keygen -lf ~/.ssh/id_ed25519_<purpose>.pub` |

## Quick start (minimal)

```bash
ssh <user>@<host>
```

## Interfaces

### CLI commands

#### `ssh`

**Synopsis**

```text
ssh [options] [user@]host [command]
```

**Common options**

| Flag | Default | Description |
|---|---|---|
| `-p <port>` | `22` | Port |
| `-i <path>` | (auto) | Identity (private key) |
| `-J <jump>` | (none) | Jump host / bastion (ProxyJump) |
| `-L <lport>:<host>:<rport>` | (none) | Local port forward |
| `-R <rport>:<host>:<lport>` | (none) | Remote port forward |
| `-D <port>` | (none) | SOCKS proxy (dynamic forward) |
| `-o <k=v>` | (none) | Set any config key inline |
| `-v/-vv/-vvv` | (none) | Verbose debugging |

**Exit codes**

| Code | Meaning | Notes |
|---:|---|---|
| 0 | Success | |
| 255 | Connection/auth failure | Common when auth fails or host unreachable |

**Examples**

```bash
# Basic
ssh <user>@<host>

# Non-default port
ssh -p 2222 <user>@<host>

# Use a specific key
ssh -i ~/.ssh/id_ed25519_work <user>@<host>

# Jump host
ssh -J <user>@bastion.example <user>@internal-host

# Run a single command remotely
ssh <user>@<host> "uname -a"

# Debug auth
ssh -vvv -i ~/.ssh/id_ed25519_work <user>@<host>
```

**Common errors**

| Error | Meaning | Fix |
|---|---|---|
| `Permission denied (publickey)` | Key not accepted | Fix `authorized_keys`, perms, offered identity |
| `REMOTE HOST IDENTIFICATION HAS CHANGED` | Host key mismatch | Confirm rebuild/DNS change; then update known_hosts |
| `Connection timed out` | Network path blocked | VPN/SG/firewall/route; verify port |

---

#### `ssh-keygen`

**Synopsis**

```text
ssh-keygen [options]
```

**Common tasks**

| Task | Command |
|---|---|
| Generate `ed25519` key | `ssh-keygen -t ed25519 -a 64 -f ~/.ssh/id_ed25519_<purpose> -C "<comment>"` |
| Show fingerprint (pub) | `ssh-keygen -lf ~/.ssh/id_ed25519_<purpose>.pub` |
| Remove a host from known_hosts | `ssh-keygen -R <host>` |
| Convert private key format | `ssh-keygen -p -f ~/.ssh/id_ed25519_<purpose>` |

---

#### `ssh-agent` and `ssh-add`

**Common tasks**

| Task | Linux/macOS example |
|---|---|
| Start agent in current shell | `eval "$(ssh-agent -s)"` |
| Add key | `ssh-add ~/.ssh/id_ed25519_<purpose>` |
| List loaded keys | `ssh-add -l` |
| Remove a key | `ssh-add -d ~/.ssh/id_ed25519_<purpose>` |
| Remove all keys | `ssh-add -D` |

---

#### `scp` and `sftp` (file transfer)

**`scp` examples**

```bash
# Copy local -> remote
scp -P <port> <file> <user>@<host>:/path/

# Copy remote -> local
scp -P <port> <user>@<host>:/path/file .
```

> **NOTE:** Some environments prefer `sftp` or `rsync` and restrict `scp` depending on policy and server settings.

### Configuration

#### Config file locations

**Client config**

- Linux/macOS: `~/.ssh/config`
- Windows: `%USERPROFILE%\.ssh\config`

**Server config**

- Linux (common): `/etc/ssh/sshd_config`
- Windows OpenSSH (common): `C:\ProgramData\ssh\sshd_config`

#### Common `~/.ssh/config` keys

| Key | Type | Default | Description |
|---|---|---|---|
| `Host` | pattern | n/a | Host alias / matcher |
| `HostName` | string | n/a | Real hostname |
| `User` | string | (current user) | Remote username |
| `Port` | int | 22 | Remote port |
| `IdentityFile` | path | (auto) | Private key path |
| `IdentitiesOnly` | bool | no | Offer only specified identities |
| `ProxyJump` | string | (none) | Jump host definition |
| `ServerAliveInterval` | int | 0 | Keepalive interval |
| `ServerAliveCountMax` | int | 3 | Keepalive retries |
| `ForwardAgent` | bool | no | Agent forwarding (use sparingly) |
| `StrictHostKeyChecking` | yes/no/ask | ask | Host key policy |

#### Common `sshd_config` keys (Linux)

| Key | Type | Typical default | Description |
|---|---|---|---|
| `Port` | int | 22 | Listen port |
| `PermitRootLogin` | yes/no/prohibit-password | varies | Root login policy |
| `PasswordAuthentication` | yes/no | varies | Password auth |
| `PubkeyAuthentication` | yes/no | yes | Public key auth |
| `AuthorizedKeysFile` | path | `.ssh/authorized_keys` | Authorized keys location |
| `AllowUsers` / `AllowGroups` | list | (none) | Restrict logins |
| `MaxAuthTries` | int | 6 | Limit auth attempts |
| `ClientAliveInterval` | int | 0 | Server-side keepalive |

#### Canonical client config example

```sshconfig
Host prod-bastion
  HostName bastion.example
  User <user>
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes

Host prod-internal-*
  User <user>
  ProxyJump prod-bastion
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes
  ServerAliveInterval 30
  ServerAliveCountMax 3
```

### Keys and files

#### Common file locations (client)

- Private keys: `~/.ssh/id_ed25519*`, `~/.ssh/id_rsa*`
- Public keys: same path with `.pub`
- Known hosts: `~/.ssh/known_hosts`
- Config: `~/.ssh/config`

#### Linux server locations (typical)

- User authorized keys: `~<user>/.ssh/authorized_keys`
- Server host keys: `/etc/ssh/ssh_host_*_key`
- Server logs: `journalctl -u sshd` or `/var/log/auth.log` (varies)

#### Permission requirements (Linux)

| Path | Recommended perms | Notes |
|---|---|---|
| `~/.ssh` | `700` | owned by the user |
| `~/.ssh/authorized_keys` | `600` | owned by the user |
| private key (`id_*`) | `600` | never world-readable |

## Best Practices

- Keep Reference scannable: tables, canonical snippets, minimal prose.
- Prefer examples that work across environments; call out OS-specific differences explicitly.
- Don’t embed multi-step procedures here; link to the How-to guide instead.
- Avoid unsafe defaults in examples (e.g., don’t recommend disabling host key checking).

## Security

### Authentication and authorization

- Use key-based auth by default.
- Consider separate keys per device/purpose and rotate periodically.
- Restrict access with `AllowUsers`/`AllowGroups` or central policy where available.

### Secrets handling

- Never store private keys in Git.
- Never paste private keys into docs or tickets.
- Redact hostnames/usernames if needed for external sharing.

## Observability

### Logs

Linux:

```bash
sudo journalctl -u sshd --since "30 min ago" || sudo tail -n 200 /var/log/auth.log
```

### Debugging client-side

```bash
ssh -vvv -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

## Compatibility

- **Preferred key type:** `ed25519`
- **RSA fallback:** only if required by an older environment
- **Windows OpenSSH:** paths/ACL behavior differs; validate against your baseline

## Limits and known behaviors

- Host key pinning is per hostname/IP entry in `known_hosts`.
- SSH will try multiple identities unless `IdentitiesOnly yes` is set, which can cause confusing auth attempts.

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-27 | 0.1.0 | Initial | u115478 |
