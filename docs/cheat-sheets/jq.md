# jq Cheat Sheet

Command-line JSON processor.

## Basics

Pretty print:

```bash
cat data.json | jq .
```

Extract a field:

```bash
jq -r '.name' data.json
```

## Navigate & filter

```bash
jq '.items[0]' data.json
jq '.items[] | select(.enabled==true)' data.json
jq '.items[] | {id, name}' data.json
```

## Arrays

Map:

```bash
jq '[.items[].id]' data.json
```

Count:

```bash
jq '.items | length' data.json
```

Sort:

```bash
jq '.items | sort_by(.name)' data.json
```

## Update JSON

Set a field:

```bash
jq '.enabled = true' data.json
```

Delete a field:

```bash
jq 'del(.debug)' data.json
```

## JSON lines

One JSON object per line:

```bash
cat events.jsonl | jq -c '.'
cat events.jsonl | jq -r '.ts + \" \" + .msg'
```

## Slurp

Read multiple JSON values into an array:

```bash
jq -s '.' *.json
```

