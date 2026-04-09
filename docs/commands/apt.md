# apt Cheat Sheet

Debian/Ubuntu package manager front-end.

## Update / upgrade

```bash
# Update package lists
sudo apt update

# Upgrade installed packages
sudo apt upgrade
```

## Search / inspect

```bash
# Search packages
apt search nginx

# Show package info
apt show nginx

# List installed packages and filter
apt list --installed | grep nginx
```

## Install / remove / cleanup

```bash
# Install a package
sudo apt install nginx

# Remove a package
sudo apt remove nginx

# Remove unused packages
sudo apt autoremove

# Clean apt cache
sudo apt clean
```

## Repos and troubleshooting

```bash
# Show configured apt repositories (common locations)
grep -R "^deb" /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null

# Fix broken dependencies
sudo apt -f install
```

