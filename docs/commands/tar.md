# tar Cheat Sheet

Create/extract tar archives.

```bash
# Create a .tar archive
tar -cf archive.tar dir/

# Create a gzip-compressed tarball
tar -czf archive.tar.gz dir/

# Create an xz-compressed tarball
tar -cJf archive.tar.xz dir/

# Extract a .tar archive
tar -xf archive.tar

# Extract a .tar.gz archive
tar -xzf archive.tar.gz

# Extract a .tar.xz archive
tar -xJf archive.tar.xz

# List contents of an archive
tar -tf archive.tar.gz
```

