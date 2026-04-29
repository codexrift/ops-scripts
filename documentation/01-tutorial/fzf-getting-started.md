---
title: "fzf tutorial: fuzzy-find files, history, and grep results"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-29"
---

# fzf tutorial: fuzzy-find files, history, and grep results

<!--
Learning-oriented: practice the core fzf workflows in a terminal.
Assumes bash on Linux/WSL.
-->

## Summary

- **Goal:** Use `fzf` to quickly select files, commands, and search results from interactive lists.
- **What you'll learn:**
  - How fzf filtering works (query, multi-select, preview)
  - Using fzf with `find`, `ls`, and shell history
  - Picking a line from `grep` results and jumping to the file
- **Estimated time:** 15-30 minutes
- **Difficulty:** beginner
- **Who this is for:** you

## Prerequisites

### Required tools

- `fzf` installed: `fzf --version`
- Common CLI tools: `find`, `grep`, `sed`, `awk`
- Optional but nice: `bat` (pretty preview), `less`

### Inputs you must have

- Any directory tree with a few files (a Git repo is perfect)

## Safety and scope

### What this tutorial changes

- Nothing; read-only selection workflows.

## Before you start (sanity checks)

```bash
fzf --version
echo -e "alpha\nbravo\ncharlie" | fzf
```

Checkpoint:

- You can see the interactive selector and choose a line.

## Tutorial steps

### Step 1 - Learn the essential keys

Open an fzf session:

```bash
printf "%s\n" one two three four five | fzf
```

Try:

- Type a query to filter (e.g., `th`)
- `Ctrl-j` / `Ctrl-k` (or arrow keys) to move
- `Enter` to accept the selection
- `Esc` (or `Ctrl-c`) to cancel

Checkpoint:

- You understand: “fzf shows a list, your query filters it”.

### Step 2 - Select a file from the current directory tree

Run:

```bash
find . -type f 2>/dev/null | fzf
```

Now open the selected file in your editor (example with `vim`):

```bash
vim "$(find . -type f 2>/dev/null | fzf)"
```

Checkpoint:

- You can pick a file quickly without typing its full path.

### Step 3 - Multi-select (pick several files)

```bash
find . -type f 2>/dev/null | fzf -m
```

Try selecting multiple items with `Tab`, then press `Enter`.

Checkpoint:

- Output contains multiple lines (selected paths).

### Step 4 - Add a preview pane (what am I selecting?)

If you have `bat`:

```bash
find . -type f 2>/dev/null | fzf --preview 'bat --style=numbers --color=always --line-range :200 {}'
```

Fallback without `bat`:

```bash
find . -type f 2>/dev/null | fzf --preview 'sed -n "1,200p" {}'
```

Checkpoint:

- The right pane shows the beginning of the highlighted file.

### Step 5 - Pick from your shell history

In bash:

```bash
history | fzf
```

If you want only the command part (strip the history number):

```bash
history | sed 's/^[ ]*[0-9]*[ ]*//' | fzf
```

Checkpoint:

- You can search for a past command and print it.

### Step 6 - Pick a match from grep results (file + line)

Search for a term in the repo, then pick one result:

```bash
grep -RIn -- "TODO" . 2>/dev/null | fzf
```

Output looks like:

```text
./path/file.txt:123:matched line...
```

Optional: open the selected match in `vim` at the right line:

```bash
sel="$(grep -RIn -- "TODO" . 2>/dev/null | fzf)"
file="${sel%%:*}"
line="$(printf '%s' "$sel" | cut -d: -f2)"
vim "+${line}" "${file}"
```

## Next steps

- Recipes: `documentation/02-how-to-guide/fzf-recipes.md`
- Command/options lookup: `documentation/03-reference/fzf-reference.md`
- Concepts: `documentation/04-explanation/fzf-mental-model.md`

