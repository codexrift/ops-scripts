# awk Cheat Sheet

`awk` is a pattern/action language: for each input line, it splits fields and runs actions.
By default it splits on whitespace; `$1` is the first field, `$2` the second, etc.

```bash
# Print selected fields (here: first and third)
awk '{print $1, $3}' file.txt

# Use a custom field separator (comma for CSV)
awk -F, '{print $1, $2}' file.csv

# Filter: print lines where the 3rd field is > 100 (numeric compare)
awk '$3 > 100' file.txt

# Regex match: print lines containing ERROR
awk '/ERROR/ {print}' app.log

# Aggregate: sum the 2nd field, then print once at the end
awk '{sum += $2} END {print sum}' numbers.txt

# "Unique by first field": only print the first time each $1 appears
awk '!seen[$1]++' file.txt
```

Note:

- For robust CSV parsing (quotes/escapes), `awk -F,` is often not enough; prefer a real CSV parser when correctness matters.

