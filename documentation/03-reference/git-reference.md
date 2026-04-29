---
title: "git reference"
type: "reference"
owner: "u115478"
last_updated: "2026-04-28"
---

# git reference

## Scope

- **In scope:** core Git commands and concepts used day-to-day on a workstation.
- **Out of scope:** Git server administration, advanced hooks, monorepo strategy, large binary management.

## Cheat sheet

| Task | Command |
|---|---|
| Initialize repo | `git init` |
| Clone repo | `git clone <url-or-path>` |
| Current status | `git status` |
| Show diff (unstaged) | `git diff` |
| Show diff (staged) | `git diff --staged` |
| Stage file | `git add <path>` |
| Stage interactively | `git add -p` |
| Commit staged | `git commit -m "<msg>"` |
| View history | `git log --oneline --decorate --graph --max-count=20` |
| Inspect a commit | `git show <sha>` |
| List branches | `git branch -vv` |
| Switch branch | `git switch <branch>` |
| Create branch | `git switch -c <new-branch>` |
| Merge branch | `git merge <branch>` |
| Fetch from remote | `git fetch --all --prune` |
| Pull (fetch + merge/rebase) | `git pull` |
| Push | `git push` |
| Add remote | `git remote add <name> <url-or-path>` |
| List remotes | `git remote -v` |
| Undo unstaged change | `git restore <path>` |
| Unstage file | `git restore --staged <path>` |
| Reset local history (local only) | `git reset --soft|--mixed|--hard <target>` |
| Undo a shared commit | `git revert <sha>` |
| Stash work | `git stash push -m "<msg>"` |
| Apply stash | `git stash pop` |

## Quick start (minimal)

```bash
git status
```

## Interfaces

### CLI commands

#### `git`

**Synopsis**

```text
git <command> [options] [args]
```

**High-value options (selected)**

| Option | Description |
|---|---|
| `-C <path>` | Run as if started in `<path>` |
| `-c <key>=<value>` | Set a config value for this invocation |
| `--version` | Print Git version |
| `--help` | Show help for a command |

## Concepts (key terms)

| Term | Meaning |
|---|---|
| working tree | your files on disk |
| index (staging area) | the next commit contents you are preparing |
| commit | a snapshot with parents (history) |
| branch | a movable name pointing at a commit |
| HEAD | "where you are" (usually the current branch) |
| remote | a named connection to another repository |
| upstream | the remote-tracking branch your branch is compared to |

## Common errors

| Error | Meaning | Fix |
|---|---|---|
| `nothing to commit, working tree clean` | no changes staged/unstaged | edit files or switch branch |
| `src refspec <branch> does not match any` | branch doesn't exist locally | `git branch` then `git push -u origin <branch>` |
| merge conflict | same lines changed differently | resolve files, then `git add` and `git commit` |
| detached HEAD | not on a branch | `git switch -c <new-branch>` |

## Best Practices

- Use `git status` constantly; it is your safety dashboard.
- Prefer small, focused commits with clear messages.
- Prefer `revert` over `reset --hard` on shared branches.

## Security

- Do not commit secrets. If you accidentally did, treat it as a security incident and rotate the secret.

