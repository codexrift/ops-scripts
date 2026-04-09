# mount Cheat Sheet

Mount/unmount filesystems.

## Inspect mounts

```bash
# Show mounted filesystems
mount
```

## Mount / unmount

```bash
# Mount a block device at a mountpoint
sudo mount /dev/sdb1 /mnt/data

# Unmount a mountpoint
sudo umount /mnt/data

# Bind-mount a directory to another location
sudo mount --bind /src /dst
```

## fstab example

```text
UUID=xxxx-xxxx  /mnt/data  ext4  defaults,noatime  0  2
```

