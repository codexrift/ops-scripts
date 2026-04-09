# nohup Cheat Sheet

Run a command immune to hangups (useful over SSH).

Run in background:

```bash
# Run a long job detached from the terminal, redirecting output, in background
nohup long_job --arg 1 >job.out 2>job.err &
```

Default output goes to `nohup.out` if you don't redirect.

Get PID:

```bash
# Print the PID of the backgrounded nohup command
nohup long_job & echo $!
```

Check background jobs in your shell:

```bash
# List background jobs in the current shell
jobs -l
```

Detach from shell job control (bash/zsh):

```bash
# Remove job from shell job control (so it survives logout)
disown
```
