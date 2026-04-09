# ssh Cheat Sheet

Secure Shell (connect, tunnels, config).

## Connect

```bash
# Connect to a host
ssh user@host

# Connect to a host on a custom port
ssh user@host -p 2222

# Use a specific identity key
ssh -i ~/.ssh/id_ed25519 user@host

# Very verbose output (useful for debugging)
ssh -vvv user@host

# Force a pseudo-TTY and run a remote command
ssh -t user@host "sudo systemctl status nginx"
```

## Tunneling / port forwarding

```bash
# Forward local port 8080 to remote 127.0.0.1:80
ssh -L 8080:127.0.0.1:80 user@host

# Do not execute a remote command (tunnel only)
ssh -N -L 8080:127.0.0.1:80 user@host

# Fail fast if the forward can't be established
ssh -o ExitOnForwardFailure=yes -N -L 8080:127.0.0.1:80 user@host

# Forward local port 5432 to a remote-reachable host:port
ssh -N -L 5432:db.internal:5432 user@host

# Listen on all local interfaces (exposes port to your LAN; use with care)
ssh -g -N -L 0.0.0.0:8080:127.0.0.1:80 user@host

# Expose your local port 9000 on the remote server
ssh -N -R 9000:127.0.0.1:9000 user@host

# Create a local SOCKS proxy (configure browser to use it)
ssh -N -D 1080 user@host

# Connect to an internal host via a bastion (jump host)
ssh -J user@bastion user@internal-host
```

## ~/.ssh/config (example)

```sshconfig
Host prod
  HostName 10.0.0.10
  User ubuntu
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 30
```

```bash
# Connect using a host alias from ~/.ssh/config
ssh prod
```

