---
title: "fzf reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-29"
---

# fzf reference

## Scope

- **In scope:** common fzf options and patterns for piping lists into fzf and consuming the selection.
- **Out of scope:** shell plugin installation details for every OS, advanced key-binding customization.

## Cheat sheet

| Task | Command |
|---|---|
| Run selector on stdin | `<cmd> \| fzf` |
| Multi-select | `<cmd> \| fzf -m` |
| Limit height | `<cmd> \| fzf --height 40%` |
| Reverse layout | `<cmd> \| fzf --layout=reverse` |
| Preview pane | `<cmd> \| fzf --preview 'sed -n \"1,200p\" {}'` |
| Exact match | `<cmd> \| fzf --exact` |
| Case: smart | `<cmd> \| fzf +i` |
| Output selection to a variable | `sel="$(<cmd> \| fzf)"` |

## Key bindings (built-in)

| Key | Meaning |
|---|---|
| `Enter` | accept selection |
| `Esc` / `Ctrl-c` | cancel |
| `Tab` | toggle selection (multi-select) |
| `Ctrl-j` / `Ctrl-k` | move down/up |
| `Ctrl-u` / `Ctrl-d` | half-page up/down |

## High-value options

| Option | Meaning |
|---|---|
| `-m, --multi` | enable multi-select |
| `--preview <cmd>` | run `<cmd>` with `{}` replaced by the current item |
| `--height <N%>` | size of UI |
| `--layout=reverse` | prompt at top, list below |
| `--exact` | exact match mode |
| `--delimiter <s>` | define field delimiter for `{n}` placeholders |
| `--with-nth <spec>` | show specific fields |

## Placeholders (in `--preview` and `--bind`)

| Placeholder | Meaning |
|---|---|
| `{}` | current line (full) |
| `{1}` | first field (requires `--delimiter`) |
| `{+}` | all selected lines (multi-select) |

## Common errors

| Symptom | Cause | Fix |
|---|---|---|
| fzf opens with empty list | upstream command returned nothing | run upstream command alone |
| preview errors on binary files | preview command assumes text | use `sed` with errors suppressed or detect via `file` |

## Security

- Be cautious when piping selections into destructive commands; print the selection first.

