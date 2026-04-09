# scp Cheat Sheet

Copy files over SSH (legacy; consider `rsync` for large trees).

## To remote

```bash
# Copy a file to a remote path
scp file.txt user@host:/tmp/

# Copy to a host on a custom SSH port
scp -P 2222 file.txt user@host:/tmp/

# Use a specific identity key
scp -i ~/.ssh/id_ed25519 file.txt user@host:/tmp/

# Copy a directory recursively
scp -r ./dir user@host:/tmp/
```

## From remote

```bash
# Copy a remote file to the current directory
scp user@host:/var/log/syslog .

# Copy a remote directory to a local directory
scp -r user@host:/etc/nginx ./nginx-conf
```

## Preserve times & modes

```bash
# Preserve modification times and modes
scp -p file.txt user@host:/tmp/
```

## Troubleshooting

```bash
# Verbose scp output (useful for debugging)
scp -v file.txt user@host:/tmp/
```

