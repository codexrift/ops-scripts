# Git Cheat Sheet

## Identity & config

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global -l
```

## Daily workflow

```bash
git status
git add -A
git commit -m "message"
git push
```

## Clone / fetch / pull

```bash
git clone <url>
git fetch --all --prune
git pull --rebase
```

## Branches

```bash
git branch
git switch -c feature/foo
git switch main
git branch -d feature/foo
git branch -D feature/foo
```

## Logs & diffs

```bash
git log --oneline --decorate --graph --all
git show <commit>
git diff
git diff --staged
```

## Undo (common)

Unstage:

```bash
git restore --staged <path>
```

Discard local changes:

```bash
git restore <path>
```

Amend last commit:

```bash
git commit --amend
```

Revert a commit (safe for shared branches):

```bash
git revert <commit>
```

Reset (rewrites history; be careful if pushed):

```bash
git reset --soft HEAD~1
git reset --mixed HEAD~1
git reset --hard HEAD~1
```

Find lost commits:

```bash
git reflog
```

## Stash

```bash
git stash push -m "wip"
git stash list
git stash pop
git stash apply stash@{0}
```

## Merge / rebase

```bash
git merge feature/foo
git rebase main
git rebase --continue
git rebase --abort
```

Resolve conflicts then:

```bash
git add -A
git commit
```

## Tags

```bash
git tag
git tag -a v1.2.3 -m "v1.2.3"
git push --tags
```

