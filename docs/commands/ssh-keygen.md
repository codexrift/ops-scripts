# ssh-keygen Cheat Sheet

Create and manage SSH keys.

Notes:

- Prefer `ed25519` for new keys.
- Use a strong passphrase and load keys into an agent (`ssh-agent` / `ssh-add`).

## Create keys

```bash
# Create a new ed25519 key (slow KDF with -a)
ssh-keygen -t ed25519 -a 64 -C "you@example.com"

# Create a named key file
ssh-keygen -t ed25519 -a 64 -f ~/.ssh/id_ed25519_work -C "work"

# Create a hardware-backed key (requires compatible token)
ssh-keygen -t ed25519-sk -a 64 -C "you@example.com"
```

## Fingerprints / public key

```bash
# Show fingerprint of a public key
ssh-keygen -lf ~/.ssh/id_ed25519.pub

# Derive public key from a private key
ssh-keygen -y -f ~/.ssh/id_ed25519
```

## Known hosts cleanup

```bash
# Remove a host key entry from known_hosts
ssh-keygen -R host

# Remove a host key entry for a specific host:port
ssh-keygen -R "[host]:2222"
```

## Change passphrase

```bash
# Change passphrase on an existing private key
ssh-keygen -p -f ~/.ssh/id_ed25519
```

