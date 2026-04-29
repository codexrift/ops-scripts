---
title: "fzf how-to: useful recipes (files, git, kubectl, history)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-29"
---

# fzf how-to: useful recipes (files, git, kubectl, history)

## Summary

- **Outcome:** Copy/paste fzf one-liners for common daily workflows.
- **Use when:** You already know what fzf is and want fast, repeatable commands.
- **Do not use when:** You need an explanation of why something works (see the Explanation doc).
- **Time / effort:** 1-10 minutes
- **Risk level:** low (read-only unless you pipe into destructive commands)

## Cheat sheet

### Pick a file and open it

```bash
vim "$(find . -type f 2>/dev/null | fzf)"
```

### Pick multiple files

```bash
find . -type f 2>/dev/null | fzf -m
```

### Preview file contents

```bash
find . -type f 2>/dev/null | fzf --preview 'sed -n "1,200p" {}'
```

### Search history (command only)

```bash
history | sed 's/^[ ]*[0-9]*[ ]*//' | fzf
```

### Grep + choose a match

```bash
grep -RIn -- "PATTERN" . 2>/dev/null | fzf
```

### Grep + open match in vim

```bash
sel="$(grep -RIn -- "PATTERN" . 2>/dev/null | fzf)"
file="${sel%%:*}"
line="$(printf '%s' "$sel" | cut -d: -f2)"
vim "+${line}" "${file}"
```

### Git: pick a branch to switch to

```bash
git branch --all --format='%(refname:short)' | sed 's#^remotes/##' | sort -u | fzf | xargs -r git switch
```

### Git: pick a commit to inspect

```bash
git log --oneline --decorate --graph --max-count=200 | fzf | awk '{print $1}' | xargs -r git show
```

### kubectl: pick a context to switch to

```bash
kubectl config get-contexts -o name | fzf | xargs -r kubectl config use-context
```

### kubectl: pick a namespace (current context) and set it

```bash
kubectl get ns -o name | sed 's#^namespace/##' | fzf | xargs -r -I{} kubectl config set-context --current --namespace={}
```

## Safety notes

- Treat any pipeline that ends in `rm`, `kubectl delete`, `git reset --hard`, etc. as high risk.
- Prefer printing the selection first (or using `echo`) before executing destructive commands.

## Related docs

- `documentation/01-tutorial/fzf-getting-started.md`
- `documentation/03-reference/fzf-reference.md`
- `documentation/04-explanation/fzf-mental-model.md`

