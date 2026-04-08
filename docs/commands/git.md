# Git Cheat Sheet

## Identity & config

```bash
# Set global author name
git config --global user.name "Your Name"

# Set global author email
git config --global user.email "you@example.com"

# List effective global config
git config --global -l
```

## Daily workflow

```bash
# Show current working tree status
git status

# Stage all changes (tracked + untracked)
git add -A

# Commit staged changes
git commit -m "message"

# Push commits to the remote
git push
```

## Clone / fetch / pull

```bash
# Clone a repository
git clone <url>

# Fetch all remotes and prune deleted branches
git fetch --all --prune

# Pull and rebase local commits on top
git pull --rebase
```

## Branches

```bash
# List branches
git branch

# Create and switch to a new branch
git switch -c feature/foo

# Switch branches
git switch main

# Delete a local branch (only if fully merged)
git branch -d feature/foo

# Force-delete a local branch
git branch -D feature/foo
```

## Logs & diffs

```bash
# Log graph with one-line commits
git log --oneline --decorate --graph --all

# Show a commit (diff + metadata)
git show <commit>

# Diff working tree vs index
git diff

# Diff staged changes vs HEAD
git diff --staged
```

## Undo (common)

Unstage:

```bash
# Unstage a path (keep working tree changes)
git restore --staged <path>
```

Discard local changes:

```bash
# Discard local changes in a path (destructive)
git restore <path>
```

Amend last commit:

```bash
# Amend the last commit (edit message and/or include staged changes)
git commit --amend
```

Revert a commit (safe for shared branches):

```bash
# Create a new commit that reverses another commit
git revert <commit>
```

Reset (rewrites history; be careful if pushed):

```bash
# Reset HEAD back 1 commit but keep staged changes
git reset --soft HEAD~1

# Reset HEAD back 1 commit and unstage changes
git reset --mixed HEAD~1

# Reset HEAD back 1 commit and discard changes (destructive)
git reset --hard HEAD~1
```

Find lost commits:

```bash
# Show HEAD history (useful for recovery)
git reflog
```

## Stash

```bash
# Stash changes with a message
git stash push -m "wip"

# List stashes
git stash list

# Pop latest stash (apply + drop)
git stash pop

# Apply a specific stash (without dropping)
git stash apply stash@{0}
```

## Merge / rebase

```bash
# Merge a branch into current branch
git merge feature/foo

# Rebase current branch onto main
git rebase main

# Continue a rebase after resolving conflicts
git rebase --continue

# Abort an in-progress rebase
git rebase --abort
```

Resolve conflicts then:

```bash
# Stage resolved files
git add -A

# Create the merge commit (if needed)
git commit
```

## Tags

```bash
# List tags
git tag

# Create an annotated tag
git tag -a v1.2.3 -m "v1.2.3"

# Push tags to the remote
git push --tags
```
