# Package Manager Cheat Sheet (apt + dnf + yum)

## Update package lists / update packages

```bash
sudo apt update
sudo dnf update
sudo yum update
```

## Upgrade packages

```bash
sudo apt upgrade
sudo dnf upgrade
sudo yum update
```

## Search packages

```bash
apt search nginx
dnf search nginx
yum search nginx
```

## Package info

```bash
apt show nginx
dnf info nginx
yum info nginx
```

## List installed (filter example)

```bash
apt list --installed | grep nginx
dnf list installed | grep nginx
yum list installed | grep nginx
```

## Install / remove

```bash
sudo apt install nginx
sudo dnf install nginx
sudo yum install nginx

sudo apt remove nginx
sudo dnf remove nginx
sudo yum remove nginx
```

## Cleanup

```bash
sudo apt autoremove
sudo apt clean

sudo dnf clean all
sudo yum clean all
```

## Repos

```bash
grep -R "^deb" /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null
dnf repolist
yum repolist
```

## Troubleshooting

```bash
sudo apt -f install
sudo dpkg --configure -a

dnf --showduplicates list nginx
yum --showduplicates list nginx
```

## History (dnf/yum)

```bash
dnf history
sudo dnf history undo <ID>

yum history
sudo yum history undo <ID>
```

