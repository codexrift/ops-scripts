---
type: procedural
standard: Diataxis (How-to Guide)
owner: <team-or-role>
last_updated: 2026-04-24
---

# Create an SSH tunnel (port forwarding)

## Goal
- Reach a remote service securely through SSH without exposing it publicly
- Use local, remote, or dynamic port forwarding depending on the use case

## When to Use
- You need access to an internal service (database, web UI) through a bastion/jump host
- You need a temporary encrypted tunnel for troubleshooting

## Prerequisites
- SSH access to a server that can reach the target service (often a bastion)
- An SSH client (`ssh`) available on your machine

## Inputs
- SSH host: `<user>@<ssh-host>`
- Target service host/port (as seen from the SSH host): `<target-host>:<target-port>`
- Local port to bind on your machine: `<local-port>`

## Steps
1. Decide which tunnel type you need:
   - Local forward (`-L`): access a remote service via `localhost:<local-port>` (most common)
   - Remote forward (`-R`): expose a local service to the remote side
   - Dynamic forward (`-D`): create a SOCKS proxy for browsing/tools
2. Create a local forward (example: local port 5432 to remote DB 5432):
   ```bash
   ssh -N -L 5432:<target-host>:5432 <user>@<ssh-host>
   ```
3. Keep the tunnel running:
   - Leave the terminal open (recommended simplest approach).
4. Verify connectivity through the tunnel:
   - For HTTP services:
     ```bash
     curl -v http://127.0.0.1:<local-port>/
     ```
   - For TCP services (if `nc` is available):
     ```bash
     nc -vz 127.0.0.1 <local-port>
     ```
5. Stop the tunnel when done:
   - Press `Ctrl+C` in the terminal running the tunnel.

## Verification
- `ssh` remains connected while the tunnel is active (no immediate disconnect)
- Connecting to `127.0.0.1:<local-port>` reaches the intended remote service

## Rollback / Undo
- Stop the `ssh` process running the tunnel (`Ctrl+C`)
- Remove any temporary SSH config entries you added

## Edge Cases / Variations
- Bind to localhost only (recommended default):
  - Local forwarding binds to `localhost` by default; avoid binding to `0.0.0.0` unless you understand the risk.
- Use a different local port if the default is already in use:
  - Example: `-L 15432:<target-host>:5432`
- Run through a bastion to reach an internal host:
  - Set `<ssh-host>` to the bastion and `<target-host>` to the internal host as seen from the bastion.
- Remote forward (expose local port 8080 as remote port 8080):
  ```bash
  ssh -N -R 8080:127.0.0.1:8080 <user>@<ssh-host>
  ```
- Dynamic forward (SOCKS proxy on 1080):
  ```bash
  ssh -N -D 1080 <user>@<ssh-host>
  ```

## Troubleshooting (Optional)
- "bind: Address already in use":
  - Pick a different `<local-port>`.
- Tunnel connects but the service is unreachable:
  - Confirm `<target-host>:<target-port>` is reachable from the SSH host.
  - Confirm host firewalls allow the target port.
- Connection drops frequently:
  - Add keepalives:
    ```bash
    ssh -N -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -L <local-port>:<target-host>:<target-port> <user>@<ssh-host>
    ```

## References
- Related docs:
  - `documentation/03-reference/ssh-best-practices.md` (if present)

