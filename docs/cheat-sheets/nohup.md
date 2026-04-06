# nohup Cheat Sheet

Run a command immune to hangups (useful over SSH).

Run in background:

```bash
nohup long_job --arg 1 >job.out 2>job.err &
```

Default output goes to `nohup.out` if you don't redirect.

Get PID:

```bash
nohup long_job & echo $!
```

Check background jobs in your shell:

```bash
jobs -l
```

Detach from shell job control (bash/zsh):

```bash
disown
```

