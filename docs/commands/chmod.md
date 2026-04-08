# chmod Cheat Sheet

Change file permissions.

## Common numeric modes

```bash
# Set rw-r--r-- (owner read/write; group+others read)
chmod 644 file.txt

# Set rwxr-xr-x (typical executable/script perms)
chmod 755 script.sh

# Recursively set permissions on a directory tree
chmod -R 755 dir/
```

## Symbolic modes

```bash
# Add execute bit for the user (owner)
chmod u+x script.sh

# Remove write bit for group and others
chmod go-w file.txt

# Set exact perms (user rw, group r, others r)
chmod u=rw,go=r file.txt
```

## Special bits

```bash
# Set SUID bit (run as file owner; security-sensitive)
chmod u+s /path/to/bin

# Set SGID bit (inherit group on new files; or run as group for executables)
chmod g+s /path/to/dir

# Set sticky bit (only file owner can delete in shared dir)
chmod +t /path/to/dir
```

