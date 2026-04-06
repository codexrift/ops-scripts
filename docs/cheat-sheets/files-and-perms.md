# Files + Permissions Cheat Sheet

## Permissions (`chmod`)

```bash
chmod 644 file.txt
chmod 755 script.sh
chmod -R 755 dir/
```

```bash
chmod u+x script.sh
chmod go-w file.txt
chmod u=rw,go=r file.txt
```

```bash
chmod u+s /path/to/bin
chmod g+s /path/to/dir
chmod +t /path/to/dir
```

## Ownership (`chown`)

```bash
sudo chown user file.txt
sudo chown user:group file.txt
sudo chown -R user:group dir/
sudo chown -h user:group link
```

## Find files (`find`)

```bash
find . -name "*.log"
find /var -iname "*.log"
find . -type f -size +100M
find . -type f -mtime -1
find . -type f -name "*.log" -exec wc -l {} \;
find . -path ./.git -prune -o -type f -name "*.md" -print
```

## Archives (`tar`)

```bash
tar -cf archive.tar dir/
tar -czf archive.tar.gz dir/
tar -cJf archive.tar.xz dir/

tar -xf archive.tar
tar -xzf archive.tar.gz
tar -xJf archive.tar.xz
tar -tf archive.tar.gz
```

## Sync (`rsync`)

```bash
rsync -avh src/ dest/
rsync -avh --info=progress2 --partial src/ dest/
rsync -avh --delete --dry-run src/ dest/
rsync -avh --exclude ".git/" --exclude "node_modules/" src/ dest/
rsync -avh -e "ssh -p 2222" ./dir/ user@host:/srv/dir/
```

## Mounts (`mount`)

```bash
mount
findmnt
df -h
```

```bash
sudo mount /dev/sdb1 /mnt/data
sudo umount /mnt/data
sudo mount --bind /src /dst
```

```text
UUID=xxxx-xxxx  /mnt/data  ext4  defaults,noatime  0  2
```

