# Ansible Cheat Sheet

## Quick identity / versions

```bash
# Show Ansible version and config paths
ansible --version

# Show only config values that differ from defaults
ansible-config dump --only-changed

# List available modules (short list)
ansible-doc -l | head

# Show docs for a specific module
ansible-doc ansible.builtin.package
```

## Inventory basics

List inventory / hosts (great for debugging):

```bash
# Dump inventory as JSON
ansible-inventory -i inventory/hosts.ini --list

# Visualize groups and hosts
ansible-inventory -i inventory/hosts.ini --graph

# Show which hosts "all" resolves to
ansible all -i inventory/hosts.ini --list-hosts

# Show which hosts a specific group resolves to
ansible web -i inventory/hosts.ini --list-hosts
```

## Connectivity (ping) + facts

```bash
# Test connectivity
ansible all -i inventory/hosts.ini -m ping

# Gather and print all facts (can be noisy)
ansible all -i inventory/hosts.ini -m setup | less

# Gather only a subset of facts (filtered)
ansible all -i inventory/hosts.ini -m setup -a 'filter=ansible_distribution*'
```

## Ad-hoc commands (one-liners)

Run a shell command:

```bash
# Run via a shell (supports pipes, redirects, variables, etc.)
ansible all -i inventory/hosts.ini -m shell -a 'uptime'

# Run a command without a shell (safer, no shell features)
ansible all -i inventory/hosts.ini -m command -a 'uname -a'
```

Become (sudo):

```bash
# Run as root using privilege escalation (sudo)
ansible all -i inventory/hosts.ini -b -m shell -a 'id'

# Same, but prompt for the sudo password
ansible all -i inventory/hosts.ini -b -K -m shell -a 'id'
```

Copy a file (controller -> managed host):

```bash
# Copy a local file to the managed host with owner/mode
ansible web -i inventory/hosts.ini -b -m copy -a 'src=./files/app.conf dest=/etc/myapp/app.conf mode=0644'
```

## Playbooks (day-to-day)

Syntax check:

```bash
# Validate playbook YAML/Jinja structure
ansible-playbook -i inventory/hosts.ini --syntax-check site.yml
```

Run a playbook (with become):

```bash
# Run playbook, escalating privileges where tasks require it
ansible-playbook -i inventory/hosts.ini -b site.yml
```

Limit scope (hosts) + tags:

```bash
# Limit execution to a host/group pattern
ansible-playbook -i inventory/hosts.ini -b site.yml --limit web

# Combine patterns (example: hosts in "web" AND in "prod")
ansible-playbook -i inventory/hosts.ini -b site.yml --limit 'web:&prod'

# Run only tasks with a given tag
ansible-playbook -i inventory/hosts.ini -b site.yml --tags nginx

# Skip tasks with a given tag
ansible-playbook -i inventory/hosts.ini -b site.yml --skip-tags packages
```

Dry-run with diffs (best effort):

```bash
# Dry-run (check mode) and show diffs where possible
ansible-playbook -i inventory/hosts.ini -b site.yml --check --diff
```

Start at a task (when iterating):

```bash
# Resume from a named task (useful while iterating)
ansible-playbook -i inventory/hosts.ini -b site.yml --start-at-task "Install packages"
```

## Variables and extra vars

```bash
# Set a variable inline
ansible-playbook -i inventory/hosts.ini -b site.yml -e 'env=dev'

# Load variables from a YAML file
ansible-playbook -i inventory/hosts.ini -b site.yml -e @vars/dev.yml
```

## Vault

Edit / view an encrypted vars file:

```bash
# Edit an encrypted vars file in-place
ansible-vault edit group_vars/prod/vault.yml

# View an encrypted vars file (read-only)
ansible-vault view group_vars/prod/vault.yml
```

Run with vault password prompt or file:

```bash
# Prompt for vault password
ansible-playbook -i inventory/hosts.ini -b site.yml --ask-vault-pass

# Read vault password from a local file
ansible-playbook -i inventory/hosts.ini -b site.yml --vault-password-file ./.vault_pass
```

## Common debugging flags

More verbosity (SSH, module args, failures):

```bash
# Verbose output (more detail on what Ansible is doing)
ansible-playbook -i inventory/hosts.ini -b site.yml -v

# Very verbose (useful for SSH/debugging)
ansible-playbook -i inventory/hosts.ini -b site.yml -vvv
```

Step through tasks:

```bash
# Ask for confirmation before each task
ansible-playbook -i inventory/hosts.ini -b site.yml --step
```

List-only modes:

```bash
# Show the resolved host list without running
ansible-playbook -i inventory/hosts.ini site.yml --list-hosts

# Show which tasks would run
ansible-playbook -i inventory/hosts.ini site.yml --list-tasks

# Show available tags
ansible-playbook -i inventory/hosts.ini site.yml --list-tags
```

Notes:

- Prefer `command` over `shell` when you do not need shell features (pipes, redirects, variables).
- Use `--check --diff` to preview changes, but not all modules fully support check mode.
