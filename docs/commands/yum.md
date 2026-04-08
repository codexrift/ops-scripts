# yum Cheat Sheet

Legacy RHEL/CentOS package manager (often replaced by dnf).

```bash
# Update packages
sudo yum update

# Search packages
yum search nginx

# Show package info
yum info nginx

# List installed packages and filter
yum list installed | grep nginx

# Install a package
sudo yum install nginx

# Remove a package
sudo yum remove nginx

# Clean metadata/cache
sudo yum clean all

# List configured repos
yum repolist

# Show available versions
yum --showduplicates list nginx

# Show transaction history
yum history

# Undo a transaction by ID
sudo yum history undo <ID>
```

