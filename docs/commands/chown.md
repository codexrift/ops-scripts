# chown Cheat Sheet

Change file owner and group.

```bash
# Change file owner
sudo chown user file.txt

# Change owner and group
sudo chown user:group file.txt

# Recursively change owner and group
sudo chown -R user:group dir/

# Change ownership of a symlink itself (not its target)
sudo chown -h user:group link
```

