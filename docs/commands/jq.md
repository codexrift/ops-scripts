# jq Cheat Sheet

Command-line JSON processor.

## Basics

Pretty print:

```bash
# Pretty-print JSON
cat data.json | jq .
```

Extract a field:

```bash
# Extract the .name field as raw text (no quotes)
jq -r '.name' data.json
```

## Navigate & filter

```bash
# Get the first element in .items
jq '.items[0]' data.json

# Filter items where enabled is true
jq '.items[] | select(.enabled==true)' data.json

# Project only a subset of fields
jq '.items[] | {id, name}' data.json
```

## Arrays

Map:

```bash
# Build an array of item IDs
jq '[.items[].id]' data.json
```

Count:

```bash
# Count items
jq '.items | length' data.json
```

Sort:

```bash
# Sort items by a field
jq '.items | sort_by(.name)' data.json
```

## Update JSON

Set a field:

```bash
# Set/overwrite a field (outputs new JSON; does not edit file)
jq '.enabled = true' data.json
```

Delete a field:

```bash
# Delete a field (outputs new JSON; does not edit file)
jq 'del(.debug)' data.json
```

## JSON lines

One JSON object per line:

```bash
# Print compact JSON (one object per line)
cat events.jsonl | jq -c '.'

# Format each line as "ts msg"
cat events.jsonl | jq -r '.ts + \" \" + .msg'
```

## Slurp

Read multiple JSON values into an array:

```bash
# Slurp multiple JSON documents into an array
jq -s '.' *.json
```
