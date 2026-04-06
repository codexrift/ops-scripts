# ps Cheat Sheet

Process listing.

## Common listings

All processes:

```bash
ps aux
```

Tree view:

```bash
ps -ef --forest
```

## Filter

```bash
ps aux | grep nginx
ps -ef | grep sshd
```

## By PID

```bash
ps -p 1234 -o pid,ppid,user,etime,cmd
```

## Sort by CPU / MEM (common)

```bash
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

