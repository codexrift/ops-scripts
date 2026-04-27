---
title: "Set up SSH access from scratch (client + server)"
type: "tutorial"
last_updated: "2026-04-27"
---

# Set up SSH access from scratch (client + server)

## Summary

- **Goal:** Set up key-based SSH login from your workstation to a target host, safely and repeatably.
- **What you’ll learn:**
  - How SSH keys and host verification work at a practical level
  - How to generate and load a key into an agent
  - How to install a public key on a server and verify login
  - How to avoid common permission and trust mistakes
- **Estimated time:** 30–90 minutes (depends on OS + server access)
- **Difficulty:** beginner → intermediate
- **Who this is for:** you, setting up SSH from scratch end-to-end

## Prerequisites

### Access and permissions

- Admin rights on your workstation (or ability to install packages)
- A target host you are allowed to administer (or a sandbox VM)
- A way to reach the host (network route, VPN, security group rules, etc.)

> **NOTE:** If you do not control the server, stop after client setup and ask the server owner how to register your public key.

### Required tools

- **Client:** OpenSSH client (`ssh`, `ssh-keygen`, `ssh-agent`, `ssh-add`)
- **Server:** OpenSSH server (Linux: `sshd`; Windows: `sshd` service)

### Inputs you must have

- Target host: `<host>` (DNS name or IP)
- Target user: `<user>`
- Target port (if non-standard): `<port>` (default 22)

## Safety and scope

### What this tutorial changes

- On your workstation: creates a private/public key under your user profile and (optionally) SSH config entries.
- On the server: adds your public key to `authorized_keys` (or equivalent) and may adjust SSH server settings.

### Risks

- You can lock yourself out if you change server authentication settings before validating key login.
- You can expose access if you mishandle private keys or enable unsafe features (like uncontrolled agent forwarding).

### Rollback (high-level)

- Client: remove the key from your agent and delete the key files if needed.
- Server: remove the added line from `~<user>/.ssh/authorized_keys` (Linux) or the configured `authorized_keys` location (Windows OpenSSH).
- If you changed `sshd_config`, revert that change and restart the SSH service.

> **DANGER:** Never paste real private keys into tickets, chat, or docs. Only share **public** keys.

## Before you start (sanity checks)

### Confirm your environment

- Machine: `<hostname>`
- OS: `<Windows|Linux|macOS + version>`
- Network: `<VPN yes/no>`
- Target environment: `<dev|stage|prod>`

### Confirm connectivity

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

### Step 1 — Ensure SSH client tooling is available

**What you’re doing:** Verify you can run `ssh` and `ssh-keygen`.

**Why it matters:** Your workstation must be able to create keys and connect.

#### Windows (PowerShell)

```powershell
ssh -V
ssh-keygen -V 2>$null; if ($LASTEXITCODE -ne 0) { "ssh-keygen missing or not in PATH" }
```

If missing on Windows, you can often install:

```powershell
# On many Windows versions, OpenSSH Client is an Optional Feature
Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Client*" | Select-Object Name,State
# Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

#### Linux (bash)

```bash
ssh -V
ssh-keygen -V 2>/dev/null || true
```

Install (pick your distro):

```bash
# Debian/Ubuntu
sudo apt-get update && sudo apt-get install -y openssh-client
# RHEL/CentOS/Fedora
sudo dnf install -y openssh-clients || sudo yum install -y openssh-clients
# Arch
sudo pacman -S --needed openssh
```

#### macOS (zsh)

```bash
ssh -V
ssh-keygen -V 2>/dev/null || true
```

macOS typically includes OpenSSH already.

#### Checkpoint

- You can run `ssh -V` successfully.

---

### Step 2 — Generate a new SSH key (ed25519)

**What you’re doing:** Create a modern key pair for authentication.

**Why it matters:** Key-based auth is stronger and more automatable than passwords.

> **NOTE:** Prefer `ed25519` unless you have a compatibility requirement for RSA.

#### Choose a key name (recommended)

- File base name: `id_ed25519_<purpose>` (example: `id_ed25519_lab`, `id_ed25519_work`)

#### Windows (PowerShell)

```powershell
$keyName = "id_ed25519_<purpose>"
ssh-keygen -t ed25519 -a 64 -f "$env:USERPROFILE\.ssh\$keyName" -C "<comment: you@host purpose>"
```

#### Linux/macOS (bash/zsh)

```bash
key_name="id_ed25519_<purpose>"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/$key_name" -C "<comment: you@host purpose>"
```

#### Passphrase guidance

- Use a passphrase unless your environment explicitly requires unencrypted keys (rare, and higher risk).
- Store passphrases in your password manager.

#### Checkpoint

- Private key exists: `~/.ssh/<keyName>` (Windows: `%USERPROFILE%\.ssh\<keyName>`)
- Public key exists: `~/.ssh/<keyName>.pub`

---

### Step 3 — Start and load your key into an SSH agent

**What you’re doing:** Use an agent so you don’t retype the passphrase for each connection.

**Why it matters:** It reduces friction and keeps the private key protected with a passphrase.

#### Windows (PowerShell)

```powershell
# Start the built-in ssh-agent service (if available)
Get-Service ssh-agent -ErrorAction SilentlyContinue | Select-Object Name,Status,StartType
# Set-Service ssh-agent -StartupType Automatic
# Start-Service ssh-agent

# Load the key (enter passphrase when prompted)
ssh-add $env:USERPROFILE\.ssh\id_ed25519_<purpose>

# List loaded keys
ssh-add -l
```

#### Linux/macOS (bash/zsh)

```bash
# Start an agent in your current shell session
eval "$(ssh-agent -s)"

# Load the key (enter passphrase when prompted)
ssh-add "$HOME/.ssh/id_ed25519_<purpose>"

# List loaded keys
ssh-add -l
```

#### Checkpoint

- `ssh-add -l` shows your key.

---

### Step 4 — Install OpenSSH server on the target host (if needed)

**What you’re doing:** Ensure the target host is running an SSH server (`sshd`).

**Why it matters:** Without a server, no SSH login is possible.

> **NOTE:** If the host already supports SSH, skip to Step 5.

#### Linux (bash) — install + enable

```bash
# Debian/Ubuntu
sudo apt-get update && sudo apt-get install -y openssh-server
sudo systemctl enable --now ssh

# RHEL/Fedora
sudo dnf install -y openssh-server
sudo systemctl enable --now sshd
```

#### Windows (PowerShell) — install + enable (if you are using Windows OpenSSH)

```powershell
# Optional feature names vary by Windows version; verify before installing.
Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*" | Select-Object Name,State
# Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start and enable the service
Get-Service sshd -ErrorAction SilentlyContinue | Select-Object Name,Status,StartType
# Set-Service sshd -StartupType Automatic
# Start-Service sshd
```

#### Checkpoint

- Port `<port>` is listening on the target host (typically 22).

---

### Step 5 — Add your public key to the server (authorized_keys)

**What you’re doing:** Register your public key so the server trusts it for login.

**Why it matters:** SSH uses the public key to verify you own the private key.

#### Copy your public key (client side)

##### Windows (PowerShell)

```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519_<purpose>.pub
```

##### Linux/macOS (bash/zsh)

```bash
cat "$HOME/.ssh/id_ed25519_<purpose>.pub"
```

#### Linux server method A (recommended): `ssh-copy-id`

Run this from a Linux/macOS client (or from WSL if you use it):

```bash
ssh-copy-id -i "$HOME/.ssh/id_ed25519_<purpose>.pub" -p <port> <user>@<host>
```

#### Linux server method B (manual): append to `authorized_keys`

On the server:

```bash
umask 077
mkdir -p "~/.ssh"
touch "~/.ssh/authorized_keys"
chmod 700 "~/.ssh"
chmod 600 "~/.ssh/authorized_keys"

# Append the public key as a single line:
printf '%s\n' '<paste your .pub line here>' >> "~/.ssh/authorized_keys"
```

#### Windows OpenSSH server (manual concept)

Windows OpenSSH can use per-user `authorized_keys`, but file locations and ACL requirements differ from Linux.

- Config file: `C:\ProgramData\ssh\sshd_config`
- Keys are typically stored under the user profile or a configured `AuthorizedKeysFile` path.

> **WARNING:** On Windows, incorrect ACLs can cause key auth to fail. Follow your environment’s Windows OpenSSH baseline if you have one.

#### Checkpoint

- The server has your public key line added in the right place.

---

### Step 6 — First SSH login (and host key verification)

**What you’re doing:** Connect using your key and trust the server’s host key.

**Why it matters:** The host key prevents man-in-the-middle attacks by pinning server identity.

#### Connect (all OS)

```bash
ssh -p <port> <user>@<host>
```

If you have multiple keys, specify the one you want:

```bash
ssh -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

#### Checkpoint

- You log in without being asked for the server account password.
- If prompted to “accept host key”, you accepted it intentionally and it was saved to `known_hosts`.

> **WARNING:** If you unexpectedly see a host key mismatch warning (e.g., “REMOTE HOST IDENTIFICATION HAS CHANGED”), stop and investigate before proceeding.

---

### Step 7 — Make it convenient with `~/.ssh/config`

**What you’re doing:** Create a per-host alias so future connections are short and consistent.

**Why it matters:** It reduces mistakes (wrong user/host/port/key) and speeds up use.

#### Create or edit SSH config

- Linux/macOS: `~/.ssh/config`
- Windows: `%USERPROFILE%\.ssh\config`

Example:

```sshconfig
Host lab-ssh
  HostName <host>
  User <user>
  Port <port>
  IdentityFile ~/.ssh/id_ed25519_<purpose>
  IdentitiesOnly yes
  ServerAliveInterval 30
  ServerAliveCountMax 3
```

Now connect with:

```bash
ssh lab-ssh
```

#### Checkpoint

- `ssh lab-ssh` connects as expected.

---

### Step 8 — (Optional) Server hardening basics

**What you’re doing:** Reduce attack surface without locking yourself out.

**Why it matters:** SSH is a common target; small hardening steps help a lot.

> **DANGER:** Only do this after you have confirmed key-based login works.

#### Linux: review `sshd_config` safely

File: `/etc/ssh/sshd_config` (path may vary)

Common settings to consider (adapt to your environment):

- Disable password auth: `PasswordAuthentication no`
- Disable root login: `PermitRootLogin no` (or `prohibit-password`)
- Limit users/groups: `AllowUsers <user1> <user2>` or `AllowGroups <group>`
- Keep protocol modern: OpenSSH defaults are usually fine

Validate config then restart:

```bash
sudo sshd -t
sudo systemctl restart sshd || sudo systemctl restart ssh
```

#### Checkpoint

- A fresh session using your key still works after restart.

## Cleanup (if this tutorial uses a lab)

- Remove temporary user accounts created for learning.
- Remove the tutorial public key line from `authorized_keys` if it was only for a sandbox.
- Remove any temporary firewall exceptions.

## Troubleshooting

### Symptom: it still asks for a password

**Likely causes**

- The server never got the correct public key line (wrong user, wrong file).
- Permissions are too open on `~/.ssh` or `authorized_keys` (Linux).
- Server config disables pubkey auth or points `AuthorizedKeysFile` elsewhere.
- You’re offering the wrong key (multiple keys present).

**Fix**

Client-side, force a specific key and show verbose logs:

```bash
ssh -vvv -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

Server-side (Linux), verify permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**Validation**

- In `ssh -vvv` output, you see `Offering public key:` then `Authentication succeeded`.

---

### Symptom: “Permission denied (publickey)”

**Likely causes**

- Public key line is malformed (wrapped across lines) or not present.
- Wrong account (`<user>`) or wrong host (`<host>`).
- Server’s `sshd_config` has `PubkeyAuthentication no`.

**Fix**

- Re-copy the `.pub` line exactly (single line).
- Verify you’re connecting to the expected host and user.

---

### Symptom: “REMOTE HOST IDENTIFICATION HAS CHANGED”

**Likely causes**

- The host was rebuilt and has a new host key.
- DNS now points to a different machine.
- A real man-in-the-middle risk (treat seriously).

**Fix**

1. Confirm with the server owner out-of-band.
2. Remove the old host key entry only after confirmation.

```bash
ssh-keygen -R <host>
```

**Validation**

- Next connection prompts to trust the new host key (after you confirmed it’s legitimate).

## Best Practices

### Key management

- Use separate keys per purpose/device/environment to reduce blast radius.
- Use passphrases and an agent; store passphrases in a password manager.
- Rotate keys periodically and whenever a device is lost/compromised.

### Safer SSH usage

- Prefer `ProxyJump` to reach internal hosts; avoid broad inbound SSH exposure.
- Avoid agent forwarding unless you understand and accept the risk.
- Use `IdentitiesOnly yes` and explicit `IdentityFile` to prevent offering unintended keys.

### Change safety (server)

- Keep one known-good session open while making server-side changes.
- Validate with a **new** session before closing the old one.
- Don’t disable password auth or tighten allowlists until key auth is confirmed working.

## FAQ

**Q:** Should I reuse the same key everywhere?  
**A:** Prefer separate keys per purpose (workstations, automation, environments) to reduce blast radius and make revocation clean.

**Q:** Should I use RSA keys?  
**A:** Use `ed25519` by default. Use RSA only when required by an older environment.

## Glossary

- **Host key:** The server’s identity key stored in your `known_hosts`.
- **Authorized key:** Your public key stored server-side to allow login.
- **Agent:** A local process that holds decrypted keys in memory for convenience.

## Next steps

- How-to for access lifecycle: `ops-scripts/documentation/02-how-to-guide/ssh-grant-revoke-access.md`
- Reference for commands/config: `ops-scripts/documentation/03-reference/ssh-openssh-reference.md`
- Deeper understanding: `ops-scripts/documentation/04-explanation/ssh-how-ssh-auth-works.md`
