# TLS (Transport Layer Security) Cheat Sheet

TLS provides encryption and authentication for network connections (commonly HTTPS).

## What TLS gives you

- Encryption (confidentiality)
- Integrity (tamper detection)
- Authentication (server identity via certificates; client identity with mTLS)

## Certificates and chains

- Server presents a certificate with:
  - Subject / SANs (hostnames)
  - Issuer
  - Validity dates
- Client validates:
  - hostname matches SAN
  - chain builds to a trusted root
  - certificate is within date range
  - optionally checks revocation

Chain terms:

- **Leaf**: the server certificate
- **Intermediate CA**: signs leaf
- **Root CA**: trust anchor (preinstalled in OS/browser)

## Common TLS failures (what they usually mean)

- "hostname mismatch": wrong certificate for that name
- "unknown authority": missing intermediate or untrusted CA
- "expired": cert dates invalid
- "handshake failure": protocol/cipher mismatch, SNI mismatch, middlebox
- "bad record mac": corruption, MTU issues, buggy middlebox, wrong protocol on port

## mTLS (mutual TLS)

- Server validates a client certificate.
- Used for service-to-service auth, internal APIs, zero trust patterns.

## Quick diagnostics (examples)

```bash
# Inspect a server's TLS handshake and cert chain (SNI with -servername)
openssl s_client -connect example.com:443 -servername example.com -showcerts

# Show details of a local cert file
openssl x509 -in cert.pem -text -noout
```

