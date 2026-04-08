# dnf Cheat Sheet

Fedora/RHEL package manager.

```bash
# Update packages
sudo dnf update

# Upgrade installed packages
sudo dnf upgrade

# Search packages
dnf search nginx

# Show package info
dnf info nginx

# List installed packages and filter
dnf list installed | grep nginx

# Install a package
sudo dnf install nginx

# Remove a package
sudo dnf remove nginx

# Clean metadata/cache
sudo dnf clean all

# List configured repos
dnf repolist

# Show available versions
dnf --showduplicates list nginx

# Show transaction history
dnf history

# Undo a transaction by ID
sudo dnf history undo <ID>
```

