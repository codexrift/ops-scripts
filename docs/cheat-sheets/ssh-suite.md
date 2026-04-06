# SSH Suite Cheat Sheet (ssh + scp + ssh-keygen)

## ssh (connect)

```bash
ssh user@host
ssh user@host -p 2222
ssh -i ~/.ssh/id_ed25519 user@host
ssh -vvv user@host
ssh -t user@host "sudo systemctl status nginx"
```

## SSH tunneling / port forwarding

Local forward (remote service available on your machine):

```bash
ssh -L 8080:127.0.0.1:80 user@host
ssh -N -L 8080:127.0.0.1:80 user@host
ssh -o ExitOnForwardFailure=yes -N -L 8080:127.0.0.1:80 user@host
```

Forward to a host reachable from the remote server:

```bash
ssh -N -L 5432:db.internal:5432 user@host
```

Bind tunnel on all local interfaces (use with care):

```bash
ssh -g -N -L 0.0.0.0:8080:127.0.0.1:80 user@host
```

Remote forward (expose local service on remote side):

```bash
ssh -N -R 9000:127.0.0.1:9000 user@host
```

SOCKS proxy:

```bash
ssh -N -D 1080 user@host
```

Jump host / bastion:

```bash
ssh -J user@bastion user@internal-host
```

## `~/.ssh/config` (example)

```sshconfig
Host prod
  HostName 10.0.0.10
  User ubuntu
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 30
```

```bash
ssh prod
```

## ssh-keygen (best practice)

- Prefer `ed25519` for new keys.
- Use a strong passphrase and load the key into an agent (`ssh-agent` / `ssh-add`).
- Use separate keys per context (personal/work, per-customer, per-environment) and select via `~/.ssh/config`.
- For high-value access, consider hardware-backed keys (FIDO2) where supported (`ed25519-sk`).

Create keys:

```bash
ssh-keygen -t ed25519 -a 64 -C "you@example.com"
ssh-keygen -t ed25519 -a 64 -f ~/.ssh/id_ed25519_work -C "work"
ssh-keygen -t ed25519-sk -a 64 -C "you@example.com"
```

Fingerprints / public key:

```bash
ssh-keygen -lf ~/.ssh/id_ed25519.pub
ssh-keygen -y -f ~/.ssh/id_ed25519
```

Known hosts cleanup:

```bash
ssh-keygen -R host
ssh-keygen -R "[host]:2222"
```

Change passphrase:

```bash
ssh-keygen -p -f ~/.ssh/id_ed25519
```

Agent:

```bash
ssh-add -l
ssh-add ~/.ssh/id_ed25519
```

## scp (copy files)

To remote:

```bash
scp file.txt user@host:/tmp/
scp -P 2222 file.txt user@host:/tmp/
scp -i ~/.ssh/id_ed25519 file.txt user@host:/tmp/
scp -r ./dir user@host:/tmp/
```

From remote:

```bash
scp user@host:/var/log/syslog .
scp -r user@host:/etc/nginx ./nginx-conf
```

Preserve times & modes:

```bash
scp -p file.txt user@host:/tmp/
```

Troubleshooting:

```bash
scp -v file.txt user@host:/tmp/
```

