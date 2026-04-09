# find Cheat Sheet

Search for files and run actions on matches.

```bash
# Find by name (case-sensitive)
find . -name "*.log"

# Find by name (case-insensitive)
find /var -iname "*.log"

# Find files larger than 100MB
find . -type f -size +100M

# Find files modified in the last 24h
find . -type f -mtime -1

# Run a command for each match (example: count lines)
find . -type f -name "*.log" -exec wc -l {} \;

# Skip a directory (prune) while searching (example: ignore .git)
find . -path ./.git -prune -o -type f -name "*.md" -print
```

