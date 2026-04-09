# sed Cheat Sheet

`sed` is a stream editor: it reads input line-by-line, applies edits, and prints the result.

```bash
# Substitute (default: only the first match on each line)
sed 's/old/new/' file.txt

# Substitute all matches on each line
sed 's/old/new/g' file.txt

# Print only a line range (lines 5 through 10)
sed -n '5,10p' file.txt

# Edit the file in place (GNU sed). Use with care.
sed -i 's/old/new/g' file.txt

# Delete blank lines
sed '/^$/d' file.txt
```

Note:

- `sed -i` differs between GNU and BSD/macOS `sed` (macOS typically needs `sed -i '' ...`).

