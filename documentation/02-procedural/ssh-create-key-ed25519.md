---
type: procedural
standard: Diataxis (How-to Guide)
owner: <team-or-role>
last_updated: 2026-04-24
---

# Create an SSH key (Ed25519)

## Goal
- Generate a new SSH key pair (private + public key)
- Output the public key so it can be added to GitHub/GitLab/servers

## When to Use
- You need an SSH key for Git operations (clone/push) or server access
- You are rotating keys or creating a new key for a new purpose (work/personal/automation)

## Prerequisites
- OpenSSH client available:
  - Windows: `ssh-keygen` is available in recent Windows 10/11 (OpenSSH Client feature)
  - Linux/macOS/WSL: `ssh-keygen` is typically installed by default
- Decide where you want to create the key:
  - Windows native (`%USERPROFILE%\.ssh\...`) or
  - WSL/Linux (`~/.ssh/...`)

## Inputs
- Key type: `ed25519` (recommended default)
- Filename (recommended): one key per purpose, for example:
  - `id_ed25519_github`
  - `id_ed25519_servers`
- Comment (recommended): `<user>@<host> YYYY-MM-DD`
- Passphrase: recommended for human keys; optional for tightly controlled automation keys

## Steps
1. Choose the environment where the key should live (Windows or WSL/Linux). Do not mix paths between the two.
2. Generate the key:
   - Windows (PowerShell):
     ```powershell
     mkdir $env:USERPROFILE\.ssh -ErrorAction SilentlyContinue | Out-Null
     ssh-keygen -t ed25519 -a 100 -f $env:USERPROFILE\.ssh\id_ed25519_github -C "$env:USERNAME@$env:COMPUTERNAME 2026-04-24"
     ```
   - WSL/Linux/macOS (bash):
     ```bash
     mkdir -p ~/.ssh
     chmod 700 ~/.ssh
     umask 077
     ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_github -C "$USER@$(hostname -s) 2026-04-24"
     ```
3. When prompted, enter a passphrase (recommended) or press Enter for no passphrase (only if appropriate).
4. Display the public key and copy it to the target system:
   - Windows:
     ```powershell
     Get-Content $env:USERPROFILE\.ssh\id_ed25519_github.pub
     ```
   - WSL/Linux/macOS:
     ```bash
     cat ~/.ssh/id_ed25519_github.pub
     ```
5. (Optional) Add the key to your SSH agent so you do not retype the passphrase:
   - WSL/Linux/macOS:
     ```bash
     eval "$(ssh-agent -s)"
     ssh-add ~/.ssh/id_ed25519_github
     ```

## Verification
- Confirm the key files exist:
  - Private key: `id_ed25519_github` (keep secret)
  - Public key: `id_ed25519_github.pub` (safe to share)
- Show the fingerprint and verify it matches what you expect:
  - Windows:
    ```powershell
    ssh-keygen -lf $env:USERPROFILE\.ssh\id_ed25519_github.pub
    ```
  - WSL/Linux/macOS:
    ```bash
    ssh-keygen -lf ~/.ssh/id_ed25519_github.pub
    ```

## Rollback / Undo
- Remove the key pair (only if you are sure it is not used anywhere):
  - Delete both the private key and the `.pub` file for that key name.
- If you already uploaded the public key to GitHub/GitLab/a server:
  - Remove the public key entry there as well.

## Edge Cases / Variations
- Legacy systems that cannot use Ed25519:
  - Use RSA as a compatibility fallback: `ssh-keygen -t rsa -b 4096 -a 100 ...`
- WSL + Windows permission pitfalls:
  - Prefer storing keys in the Linux filesystem (`~/.ssh`), not under `/mnt/c/...`.

## Troubleshooting (Optional)
- "Permissions are too open":
  - On Linux/WSL, ensure `~/.ssh` is `700` and private keys are `600`.
- "Could not open a connection to your authentication agent":
  - Start an agent (`eval "$(ssh-agent -s)"`) and retry `ssh-add`.

## References
- Related docs:
  - `documentation/03-reference/` (if present)
