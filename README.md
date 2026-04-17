# ops-scripts

Personal admin/ops scripts for Linux and Windows, with an Ansible-first workflow for Linux provisioning and cartography.

## Ansible

Location: `ansible/`

### Runner

Use the interactive runner:

```bash
cd ansible
./run-ansible-playbooks.sh
```

It shows a menu of playbooks in `ansible/playbooks/`, runs the selected one, then exits.

### Inventory

Default inventory file:

`ansible/inventory/hosts.ini`

### Playbooks

- `playbooks/ping.yml`: connectivity check (`ansible.builtin.ping`)
- `playbooks/setup_linux_baseline.yml`: base packages + unattended security updates
- `playbooks/setup_linux_shell.yml`: deploy shell profile (`linux_profile` role) + Starship setup
- `playbooks/install_docker.yml`: Docker installation via `geerlingguy.docker`
- `playbooks/gather_linux_facts.yml`: gather full host facts to JSON files
- `playbooks/dynamic_cartography.yml`: host-level cartography JSON + merged CSV snapshots
- `playbooks/dynamic_docker_cartography.yml`: Docker container cartography JSON + merged CSV snapshots

### Roles

- `roles/linux_profile`: deploys shell snippets and bash init line
- `roles/geerlingguy.docker`: Galaxy role dependency (installed via `requirements.yml`)

Install Galaxy dependencies:

```bash
cd ansible
ansible-galaxy role install -r requirements.yml -p roles
```

### Facts output

Generated outputs are written under:

- `ansible/facts/`
- `ansible/facts/dynamic_cartography/`
- `ansible/facts/dynamic_docker_cartography/`

These are generated artifacts and are ignored by git.

## Linux shell profile

Source files:

- `ansible/roles/linux_profile/files/shell/cmdhelp.sh`
- `ansible/roles/linux_profile/files/shell/cmdlist`
- `ansible/roles/linux_profile/files/shell/history.sh`

After running `setup_linux_shell.yml`, snippets are deployed to:

`~/.config/shell/`

and sourced from `~/.bashrc`.

## Windows profiles

PowerShell profile tooling:

- `windows/powershell/profile/cmdhelp.ps1`
- `windows/powershell/profile/.cmdlist`
- `windows/powershell/profile/install-profile.ps1`
- `windows/powershell/profile/install-profile.bat`

Command Prompt profile tooling:

- `windows/cmd/profile/cmdhelp.bat`
- `windows/cmd/profile/.cmdlist`
- `windows/cmd/profile/install-profile.bat`
- `windows/cmd/profile/profile.bat`

Additional Windows batch utilities:

- `windows/cmd/system_diagnostics.bat`
- `windows/cmd/list_files.bat`
- `windows/cmd/F15.bat`

## Safety

These scripts/playbooks can change system configuration.

- Review playbooks/scripts before running them.
- Validate inventory targets before execution.
- Be careful with destructive commands in `cmdlist` (for example `rm -rf`, `docker system prune -a --volumes -f`).
