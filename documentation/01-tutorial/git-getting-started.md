---
title: "git tutorial: commit, branch, merge, push (with a local remote)"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-28"
---

# git tutorial: commit, branch, merge, push (with a local remote)

<!--
Learning-oriented: you will practice the Git basics by doing them.
This uses a local bare repository as a "remote" so you can learn push/pull without needing GitHub access.
-->

## Summary

- **Goal:** Create commits, use branches, merge changes, and push/pull to a remote.
- **What you'll learn:**
  - The basic Git loop: `status -> add -> commit`
  - How branches and merges work
  - How `fetch/push/pull` relate to remotes
  - How to inspect history with `log`, `diff`, and `show`
- **Estimated time:** 30-60 minutes
- **Difficulty:** beginner
- **Who this is for:** you

## Prerequisites

### Required tools

- `git` installed (`git --version` works)
- A terminal:
  - Windows: PowerShell
  - Linux/macOS: bash/zsh

### Inputs you must have

- A folder where you can create a few test directories

## Safety and scope

### What this tutorial changes

- Creates a few folders under a learning directory (no system changes)

### Risks

- Low. The only risk is running commands in the wrong directory.

### Rollback (high-level)

- Delete the tutorial folder when done.

## Before you start (sanity checks)

### Confirm Git works

#### Windows (PowerShell)

```powershell
git --version
git help -a | Select-Object -First 20
```

#### Linux/macOS (bash/zsh)

```bash
git --version
git help -a | head
```

### Configure identity (recommended for learning)

Use a real name/email if you want, or use a tutorial identity.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global -l | grep -E "user\\.name|user\\.email|init\\.defaultBranch" || true
```

> **NOTE:** On Windows PowerShell, `grep` may not exist. If so, run `git config --global -l` and visually check.

## Tutorial steps

### Step 1 - Create a sandbox workspace

Pick a location where you can create folders. Example:

#### Windows (PowerShell)

```powershell
$root = "$HOME\\git-learning"
New-Item -ItemType Directory -Force -Path $root | Out-Null
Set-Location $root
pwd
```

#### Linux/macOS (bash/zsh)

```bash
root="$HOME/git-learning"
mkdir -p "$root"
cd "$root"
pwd
```

Checkpoint:

- `pwd` shows your `git-learning` directory.

### Step 2 - Initialize a repository and make your first commit

Create a repo called `demo-repo`:

#### Windows (PowerShell)

```powershell
New-Item -ItemType Directory -Force -Path demo-repo | Out-Null
Set-Location demo-repo
git init
git status
```

#### Linux/macOS (bash/zsh)

```bash
mkdir -p demo-repo
cd demo-repo
git init
git status
```

Create a README, then add and commit it:

#### Windows (PowerShell)

```powershell
@"
# Demo repo

Learning git basics.
"@ | Set-Content -Encoding utf8 README.md

git status
git add README.md
git status
git commit -m "Add README"
```

#### Linux/macOS (bash/zsh)

```bash
cat > README.md <<'EOF'
# Demo repo

Learning git basics.
EOF

git status
git add README.md
git status
git commit -m "Add README"
```

Inspect what you just did:

```bash
git log --oneline --decorate --graph --max-count=5
git show --stat
```

Checkpoint:

- `git status` says "working tree clean".
- `git log --oneline` shows your commit.

### Step 3 - Make a change and view diffs

Edit the README, then inspect the diff before committing:

#### Windows (PowerShell)

```powershell
@"

## Notes

- First change
"@ | Add-Content -Encoding utf8 README.md

git status
git diff
git add README.md
git diff --staged
git commit -m "Add notes section"
```

#### Linux/macOS (bash/zsh)

```bash
cat >> README.md <<'EOF'

## Notes

- First change
EOF

git status
git diff
git add README.md
git diff --staged
git commit -m "Add notes section"
```

Checkpoint:

- You can explain the difference between `git diff` and `git diff --staged`.

### Step 4 - Create a branch and merge it

Create a feature branch:

```bash
git switch -c feature/add-file
```

Create a new file and commit it:

#### Windows (PowerShell)

```powershell
"Hello from a new file." | Set-Content -Encoding utf8 hello.txt
git add hello.txt
git commit -m "Add hello file"
git log --oneline --decorate --graph --max-count=10
```

#### Linux/macOS (bash/zsh)

```bash
printf "Hello from a new file.\n" > hello.txt
git add hello.txt
git commit -m "Add hello file"
git log --oneline --decorate --graph --max-count=10
```

Merge into `main`:

```bash
git switch main
git merge feature/add-file
git log --oneline --decorate --graph --max-count=10
```

Checkpoint:

- `hello.txt` exists on `main`.
- The graph shows the branch and the merge (or a fast-forward merge depending on history).

### Step 5 - Practice push/pull using a local "remote"

Create a *bare* repository to act as a remote:

```bash
cd ..
git init --bare demo-remote.git
```

Connect your repo to the remote and push:

```bash
cd demo-repo
git remote add origin ../demo-remote.git
git remote -v
git push -u origin main
```

Now clone the remote into a second working copy:

```bash
cd ..
git clone demo-remote.git demo-repo-clone
cd demo-repo-clone
git log --oneline --decorate --graph --max-count=5
```

Make a change in the clone and push it:

#### Windows (PowerShell)

```powershell
@"

- Change from clone
"@ | Add-Content -Encoding utf8 README.md

git add README.md
git commit -m "Update README from clone"
git push
```

#### Linux/macOS (bash/zsh)

```bash
printf "\n- Change from clone\n" >> README.md
git add README.md
git commit -m "Update README from clone"
git push
```

Pull the change into the original repo:

```bash
cd ../demo-repo
git pull
git log --oneline --decorate --graph --max-count=10
```

Checkpoint:

- You can explain what `origin` is.
- You can explain the difference between `fetch` and `pull`.

## Next steps

- Learn safe undo flows: see `documentation/02-how-to-guide/git-undo-changes-safely.md`.
- Learn core concepts: see `documentation/04-explanation/git-mental-model.md`.
- Keep a command lookup: see `documentation/03-reference/git-reference.md`.
