# rsync Cheat Sheet

Fast, reliable file sync (local or over SSH).

```bash
# Sync directories (archive mode, verbose, human-readable sizes)
rsync -avh src/ dest/

# Show progress; keep partially transferred files
rsync -avh --info=progress2 --partial src/ dest/

# Preview deletions without making changes
rsync -avh --delete --dry-run src/ dest/

# Exclude paths by pattern
rsync -avh --exclude ".git/" --exclude "node_modules/" src/ dest/

# Use SSH transport with a custom port
rsync -avh -e "ssh -p 2222" ./dir/ user@host:/srv/dir/
```

