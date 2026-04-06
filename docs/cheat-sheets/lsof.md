# lsof Cheat Sheet

List open files (including network sockets).

## Processes holding a file

```bash
sudo lsof /path/to/file
```

## Ports

Who listens on TCP 80:

```bash
sudo lsof -iTCP:80 -sTCP:LISTEN -nP
```

Who uses port 443:

```bash
sudo lsof -i :443 -nP
```

## By process

```bash
sudo lsof -p <PID>
```

Find PIDs by command substring (shell pipeline):

```bash
ps aux | grep nginx
```

## Deleted but still open (disk space not freed)

```bash
sudo lsof +L1
```

