# lsof Cheat Sheet

List open files (including network sockets).

## Processes holding a file

```bash
# Show processes that have a file open
sudo lsof /path/to/file
```

## Ports

Who listens on TCP 80:

```bash
# Show who is listening on TCP port 80
sudo lsof -iTCP:80 -sTCP:LISTEN -nP
```

Who uses port 443:

```bash
# Show which processes have port 443 open (any protocol/state)
sudo lsof -i :443 -nP
```

## By process

```bash
# Show open files for a PID
sudo lsof -p <PID>
```

Find PIDs by command substring (shell pipeline):

```bash
# Find processes by substring (quick-and-dirty; may match grep itself)
ps aux | grep nginx
```

## Deleted but still open (disk space not freed)

```bash
# List deleted files still held open by processes
sudo lsof +L1
```
