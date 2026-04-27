---
title: "Grant, rotate, and revoke SSH access safely"
type: "how-to"
last_updated: "2026-04-27"
---

# Grant, rotate, and revoke SSH access safely

## Summary

- **Outcome:** Add (or remove) SSH access in a way that is auditable, reversible, and minimizes lockout risk.
- **Use when:** You need to grant a person/service SSH access, rotate keys, or revoke access quickly.
- **Do not use when:** SSH access should be managed by a centralized system (SSO/CA, PAM, ephemeral certs) and local keys are prohibited.
- **Time / effort:** 10–60 minutes per host (faster if automated)
- **Risk level:** medium (can lock out access if done incorrectly)

## Cheat sheet

Use this when you already know the procedure and need the fastest safe path.

### Pre-flight

```bash
# Identify target + keep a session open
ssh <user>@<host>

# Validate server config (Linux)
sudo sshd -t
```

### Grant (Linux authorized_keys)

```bash
user="<user>"
pubkey='<paste one full .pub line here>'

sudo install -d -m 700 -o "$user" -g "$user" "/home/$user/.ssh"
sudo touch "/home/$user/.ssh/authorized_keys"
sudo chown "$user:$user" "/home/$user/.ssh/authorized_keys"
sudo chmod 600 "/home/$user/.ssh/authorized_keys"
printf '%s\n' "$pubkey" | sudo tee -a "/home/$user/.ssh/authorized_keys" >/dev/null
```

### Verify (from workstation)

```bash
ssh -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

### Rollback (restore authorized_keys backup)

```bash
sudo cp -a ~<user>/.ssh/authorized_keys.bak.<timestamp> ~<user>/.ssh/authorized_keys
```

## Preconditions

### Required access

- Privileged access on the target host(s) (root/admin via existing method)
- Approval/change window if in `prod`
- A way to verify you can still access the host after changes (console access / break-glass)

### Required inputs

- Ticket/change ID: `<ID>`
- Target environment: `<dev|stage|prod>`
- Target host(s): `<hosts>`
- Target account(s): `<user>` (human) and/or `<svc_user>` (service)
- New public key(s): `<.pub line(s)>`
- Expiration/justification (if policy requires): `<date/reason>`

### Required tools

- On server: OpenSSH server (`sshd`), ability to edit files under the user’s home and/or `/etc/ssh/`
- On your workstation (for validation): `ssh` client

## Safety

### Impact and blast radius

- **Impact:** Auth behavior changes for specified users; SSH failures can block access.
- **Blast radius:** Single user on a single host → potentially many hosts if you deploy broadly.

### Preconditions for running in `prod`

- [ ] Approved change window / CAB if required
- [ ] Break-glass method confirmed (console, out-of-band, or alternate admin)
- [ ] You have at least one working SSH session kept open during the change
- [ ] Monitoring/alerting acknowledged (auth failures, sshd restarts)
- [ ] Communication plan ready (who to notify if access breaks)

### Rollback plan (required)

**Rollback triggers**

- You cannot establish a new SSH session after change
- Auth errors spike or SSH becomes unavailable

**Rollback steps (high-level)**

1. Revert `authorized_keys` edits (restore from backup you made in-step).
2. If `sshd_config` was changed, revert and restart SSH service.
3. Use break-glass to recover if needed.

**Rollback validation**

- You can open a fresh SSH session using the last-known-good credential.

> **WARNING:** Do not restart `sshd` in the middle of access changes unless required; prefer to make key changes without daemon restarts.

## Procedure

### 1) Pre-flight checks

#### Check: identify target(s) and capture baseline

- Ticket/change: `<ID>`
- Target(s): `<hosts>`
- Account(s): `<user>`

On the server (Linux):

```bash
id <user>
getent passwd <user> || true
```

On the server (Windows OpenSSH, if applicable):

```powershell
whoami
Get-LocalUser -Name "<user>" -ErrorAction SilentlyContinue
```

#### Check: keep a working session open

- Open one SSH session and **do not close it** until verification passes.

#### Check: confirm SSH service health (Linux)

```bash
sudo systemctl status sshd || sudo systemctl status ssh
sudo sshd -t
```

**Expected**

- Service is active/running.
- `sshd -t` returns success (no output, exit 0).

### 2) Grant access (Linux, per-user `authorized_keys`)

> **NOTE:** This section assumes Linux-style home directories and `~/.ssh/authorized_keys`.

#### Step-by-step

1. Ensure the user exists (or create them per your account policy).
2. Ensure `~<user>/.ssh` exists with correct permissions.
3. Append the new public key line(s) to `authorized_keys`.
4. Verify a new SSH login works with the new key.
5. Record evidence and close out.

#### Commands (server side)

```bash
user="<user>"
pubkey='<paste exactly one full .pub line here>'

sudo install -d -m 700 -o "$user" -g "$user" "/home/$user/.ssh"
sudo touch "/home/$user/.ssh/authorized_keys"
sudo chown "$user:$user" "/home/$user/.ssh/authorized_keys"
sudo chmod 600 "/home/$user/.ssh/authorized_keys"

# Backup before changes (timestamped)
ts="$(date +%Y%m%d-%H%M%S)"
sudo cp -a "/home/$user/.ssh/authorized_keys" "/home/$user/.ssh/authorized_keys.bak.$ts"

# Append key (single line)
printf '%s\n' "$pubkey" | sudo tee -a "/home/$user/.ssh/authorized_keys" >/dev/null
```

#### Expected results

- `authorized_keys` contains the new key as a single line.
- No permission warnings in SSH logs due to `.ssh`/`authorized_keys`.

### 3) Validate access

From your workstation, validate without relying on an existing session:

```bash
ssh -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

If validation fails, collect verbose output:

```bash
ssh -vvv -i ~/.ssh/id_ed25519_<purpose> -p <port> <user>@<host>
```

### 4) Rotate keys (recommended approach)

Rotation means: add new key → validate → remove old key → validate again.

#### Step-by-step

1. Add the new key (do not remove the old one yet).
2. Validate login using the new key.
3. Remove the old key line(s) from `authorized_keys`.
4. Validate again.
5. Update ticket with evidence + timestamp.

#### Removing old keys safely (server side)

> **NOTE:** Prefer removing by key comment or full key material; avoid “delete everything and paste new” in `prod`.

```bash
user="<user>"
sudo cp -a "/home/$user/.ssh/authorized_keys" "/home/$user/.ssh/authorized_keys.pre-rotate.$(date +%Y%m%d-%H%M%S)"
sudoedit "/home/$user/.ssh/authorized_keys"
```

**Expected**

- Old key line removed.
- New key line remains.

### 5) Revoke access (remove keys)

Revoke means: remove all keys for a user, or remove a specific key.

#### Step-by-step

1. Identify which key(s) to remove (by fingerprint/comment).
2. Backup `authorized_keys`.
3. Remove the line(s).
4. Validate that access is revoked (attempt login with the removed key).

#### Identify fingerprints (workstation)

```bash
ssh-keygen -lf ~/.ssh/id_ed25519_<purpose>.pub
```

#### Validate revocation

Try login with the revoked key; it should fail:

```bash
ssh -i ~/.ssh/id_ed25519_<revoked> -p <port> <user>@<host>
```

### 6) Optional: enforce server-side policy controls

Use these only if you understand the blast radius and you have rollback.

#### Limit who can SSH (Linux `sshd_config`)

- `AllowUsers <user1> <user2>`
- `AllowGroups <group>`

#### Disable password authentication (only after key auth confirmed)

- `PasswordAuthentication no`

Validate then restart safely:

```bash
sudo sshd -t
sudo systemctl restart sshd || sudo systemctl restart ssh
```

## Troubleshooting

### If validation fails (“Permission denied (publickey)”)

1. Confirm you’re using the correct user and host.
2. Confirm the public key line is present and not wrapped.
3. Confirm permissions:

```bash
chmod 700 ~<user>/.ssh
chmod 600 ~<user>/.ssh/authorized_keys
```

4. Check server logs:

```bash
sudo journalctl -u sshd --since "10 min ago" || sudo tail -n 200 /var/log/auth.log
```

### If you locked yourself out

1. Use break-glass / console access.
2. Restore the last backup you created:

```bash
sudo cp -a ~<user>/.ssh/authorized_keys.bak.<timestamp> ~<user>/.ssh/authorized_keys
sudo systemctl restart sshd || sudo systemctl restart ssh
```

3. Re-validate from workstation.

## Best Practices

- Prefer separate keys per person/device/purpose; avoid shared keys.
- Add new key -> validate -> remove old key -> validate again (rotation pattern).
- Keep changes small and reversible; back up `authorized_keys` before edits.
- Validate with a new session (don’t rely on an existing SSH connection).
- For fleets, prefer automation/config management over manual edits.

## Notes / exceptions

- Prefer separate keys per user/device/purpose to reduce blast radius.
- For automation, consider SSH certificates, short-lived access, or a dedicated access management system instead of long-lived static keys.

## References

- `ops-scripts/documentation/03-reference/ssh-openssh-reference.md`
- `ops-scripts/documentation/04-explanation/ssh-how-ssh-auth-works.md`
