---
title: "git how-to: undo changes safely (restore, reset, revert)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-28"
---

# git how-to: undo changes safely (restore, reset, revert)

## Summary

- **Outcome:** Undo work with the right command for the situation, without losing important history.
- **Use when:** You made a mistake locally or in a shared branch and need a safe fix.
- **Do not use when:** You are not sure whether a branch is shared (ask first).
- **Time / effort:** 2-20 minutes
- **Risk level:** low -> high (rewriting shared history is high risk)

## Cheat sheet

### Decide first (fast)

- "I have uncommitted changes I want to throw away": `git restore` (low risk)
- "I committed locally but want to change/split it": `git reset` (medium risk; local only)
- "A bad commit is already shared and I need to undo it": `git revert` (low risk; shared-safe)

### Pre-flight (always)

```bash
git status
git branch --show-current
git log --oneline --decorate --graph --max-count=10
```

## Preconditions

### Required access

- Access to the repo working copy (and remote, if you will push)

### Required inputs

- Branch name: `<branch>`
- Commit id(s) from `git log --oneline`: `<sha>`

## Safety

### Golden rules

- Do not rewrite history on a shared branch unless your team explicitly allows it.
- When in doubt: create a backup branch before destructive operations.

```bash
git branch backup/<branch>-before-undo
```

> **DANGER:** Avoid `git push --force` unless you fully understand who else is using the branch.

## Procedures

### A) Discard uncommitted changes in one file

Use when: you edited a file but want to return it to the last committed state.

```bash
git restore <path>
git status
```

If you already staged it:

```bash
git restore --staged <path>
git restore <path>
```

### B) Discard *all* uncommitted changes (working tree + staged)

Use when: you want to throw away everything since the last commit.

```bash
git restore --staged .
git restore .
git status
```

### C) Keep changes but unstage them

Use when: you accidentally `git add`-ed too much.

```bash
git restore --staged .
git status
```

### D) Undo the last commit (local only) but keep changes

Use when: you committed too early and want to modify what will be in the commit.

```bash
git reset --soft HEAD~1
git status
```

Then re-stage and recommit:

```bash
git add -p
git commit -m "<new message>"
```

### E) Undo the last commit (local only) and discard changes

Use when: the last commit is wrong and you want to delete it and its changes.

```bash
git reset --hard HEAD~1
git status
```

### F) Undo a commit that is already shared (safe for shared branches)

Use when: the bad commit is already in `main` or a shared branch.

```bash
git revert <sha>
git push
```

If it was a merge commit, Git will ask for a mainline parent (commonly `-m 1`), but validate first:

```bash
git show <merge_sha>
git revert -m 1 <merge_sha>
```

### G) Move a commit to a new branch (save work before undo)

Use when: you committed to the wrong branch.

```bash
git branch rescue/wrong-branch <sha>
git reset --hard HEAD~1
git switch rescue/wrong-branch
```

## Verification

```bash
git status
git log --oneline --decorate --graph --max-count=15
```

## Related docs

- `documentation/04-explanation/git-mental-model.md`
- `documentation/03-reference/git-reference.md`
- `documentation/01-tutorial/git-getting-started.md`

