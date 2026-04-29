---
title: "fzf explanation: mental model (lists in, selection out)"
type: "explanation"
owner: "u115478"
last_updated: "2026-04-29"
---

# fzf explanation: mental model (lists in, selection out)

## Summary (1-2 paragraphs)

`fzf` is an interactive filter: it reads a list of lines from stdin, lets you narrow that list with a fuzzy query, and prints the selected line(s) to stdout. The power comes from composing it with other commands: you generate a list (`find`, `git`, `kubectl`, `grep`), select interactively (`fzf`), then feed the selection into the next step (`xargs`, a variable, a function).

Thinking in “pipes” is the key: **lists in** → **interactive selection** → **selection out**. Once you have that mental model, you can build small tools that feel like a UI without leaving the terminal.

## Context

### Problem statement

- You want fast navigation and recall (files, branches, contexts, commands) without memorizing exact names.
- You want a consistent interface across many tools.

## Concepts and mental model

### The standard pattern

```bash
list_command | fzf | consume_selection
```

Examples:

- Files: `find . -type f | fzf`
- Git branches: `git branch --format='%(refname:short)' | fzf`
- K8s contexts: `kubectl config get-contexts -o name | fzf`

### What fzf outputs (important)

- Default: prints the selected line and exits with `0`.
- Cancel: prints nothing and exits non-zero.
- Multi-select (`-m`): prints multiple selected lines.

This is why robust scripts typically handle “empty selection” safely:

```bash
sel="$(list | fzf)" || exit 1
[[ -n "${sel}" ]] || exit 1
```

### Preview is just another command

The preview pane runs a shell command where `{}` is replaced with the current line.

```bash
find . -type f | fzf --preview 'sed -n "1,200p" {}'
```

### Safety: don’t make selection equal execution

It’s tempting to do:

```bash
dangerous_list | fzf | xargs rm -rf
```

Safer pattern:

1. print selection
2. confirm
3. run the action

## Tradeoffs and decisions

- `fzf` is fast and composable, but pipelines can become opaque; keep one-liners readable.
- Previews increase confidence but can be slow on huge files; limit preview output.

## Related docs

- Learn by doing: `documentation/01-tutorial/fzf-getting-started.md`
- Recipes: `documentation/02-how-to-guide/fzf-recipes.md`
- Options/keys: `documentation/03-reference/fzf-reference.md`

