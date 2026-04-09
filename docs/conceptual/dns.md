# DNS Concepts Cheat Sheet

DNS maps names to data (most commonly IP addresses). Its two big ideas are:

- **Hierarchy** (root -> TLD -> domain -> subdomain)
- **Caching** (TTLs control how long results are reused)

## Common record types

| Type | Meaning | Example |
|---|---|---|
| A | Name -> IPv4 | `app.example.com -> 203.0.113.10` |
| AAAA | Name -> IPv6 | `app.example.com -> 2001:db8::10` |
| CNAME | Alias -> another name | `www -> app` |
| MX | Mail exchangers | `example.com -> mail.example.com` |
| TXT | Free-form text | SPF, DKIM, verification tokens |
| NS | Authoritative servers | Delegation for a zone |
| SRV | Service locator | `_ldap._tcp.example.com` |
| PTR | Reverse lookup | `10.113.0.203.in-addr.arpa` |

Notes:

- A `CNAME` cannot normally coexist with other records at the same name (provider-specific exceptions exist).
- DNS answers can include multiple A/AAAA records (load distribution).

## Recursion vs authoritative

- **Recursive resolver**: does the lookup on your behalf, caches results (e.g., corporate DNS, ISP DNS, `8.8.8.8`).
- **Authoritative server**: source of truth for a zone (e.g., Route53, Infoblox, Cloudflare auth).

Typical flow:

1. Client asks resolver for `app.example.com`.
2. Resolver queries root -> TLD -> authoritative zone servers.
3. Resolver caches the result per TTL and answers the client.

## TTL and caching

- TTL is per record set; lower TTL = faster propagation but more query load.
- "DNS propagation" is mostly: caches expiring at different times.

## Split-horizon DNS

Same name, different answers depending on where you ask from:

- Internal resolver returns private IPs.
- Public resolver returns public IPs.

Common cause of "works on VPN but not off VPN" and vice versa.

## Common failure patterns

- Wrong record type (CNAME when you need A/AAAA, or missing MX/TXT)
- Resolver caching old answers (TTL not expired)
- NXDOMAIN due to delegation/NS issues
- Client using the wrong DNS server (DHCP option, VPN DNS, hardcoded DNS)
- Search domains causing unexpected lookups (`app` -> `app.corp.example.com`)

## Quick troubleshooting checklist

- Confirm which resolver you are using (system settings)
- Query the same name via:
  - your resolver (what clients see)
  - authoritative name servers (source of truth)
- Check TTLs and whether you recently changed records
- Validate delegation:
  - domain NS at registrar
  - zone NS in DNS provider

## Useful tools (examples)

```bash
# Basic lookup
dig app.example.com

# Short answer only
dig +short app.example.com

# Query a specific resolver
dig @8.8.8.8 app.example.com

# Trace delegation path
dig +trace app.example.com
```

