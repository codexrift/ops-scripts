# Networking Cheat Sheet

Only scan/test systems you own or have explicit permission to test.

## Interfaces, addresses, routes (`ip`)

```bash
ip link
ip addr
ip addr show dev eth0
ip route
ip route get 8.8.8.8
```

## Ports / connections (`netstat`)

Listeners with PID/program:

```bash
sudo netstat -tulpn
```

All connections:

```bash
netstat -tunap
```

Routes (legacy view):

```bash
netstat -rn
```

## HTTP checks (`curl`)

```bash
curl https://example.com
curl -L https://example.com
curl -I https://example.com
curl -H "Authorization: Bearer $TOKEN" https://api.example.com/items
```

POST JSON:

```bash
curl -X POST https://api.example.com/items \
  -H "Content-Type: application/json" \
  -d '{"name":"a"}'
```

## TCP/UDP connectivity (`nc`, `telnet`)

```bash
nc -vz example.com 443
nc -vzu 10.0.0.5 53
telnet 10.0.0.5 22
```

## DNS (`dig`)

```bash
dig example.com
dig +short example.com
dig @8.8.8.8 example.com
dig +trace example.com
dig -x 8.8.8.8
```

## Tracing hops (`traceroute`)

```bash
traceroute example.com
traceroute -n example.com
sudo traceroute -I example.com
sudo traceroute -T -p 443 example.com
```

## Packet capture (`tcpdump`)

```bash
sudo tcpdump -i eth0 -nn -vv
sudo tcpdump -i eth0 port 443
sudo tcpdump -i eth0 -w capture.pcap
tcpdump -nn -r capture.pcap
```

## Scanning (`nmap`)

```bash
nmap <host>
nmap -p 22,80,443 <host>
nmap -p- <host>
nmap -sV <host>
nmap -sn 10.0.0.0/24
sudo nmap -O <host>
```

