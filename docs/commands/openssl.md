# OpenSSL Cheat Sheet

TLS/crypto utilities.

## Inspect certificates

Show cert details:

```bash
# Display certificate contents (subject, issuer, SANs, extensions)
openssl x509 -in cert.pem -text -noout
```

Show expiry dates:

```bash
# Show notBefore / notAfter dates
openssl x509 -in cert.pem -noout -dates
```

## Test TLS connection

```bash
# Test a TLS handshake (SNI set via -servername)
openssl s_client -connect example.com:443 -servername example.com
```

Show peer cert chain:

```bash
# Test handshake and print the full certificate chain
openssl s_client -connect example.com:443 -servername example.com -showcerts
```

## Keys & CSR

Generate private key (RSA):

```bash
# Generate a 2048-bit RSA private key
openssl genrsa -out key.pem 2048
```

Generate CSR:

```bash
# Generate a Certificate Signing Request (CSR)
openssl req -new -key key.pem -out req.csr
```

Self-signed cert (dev):

```bash
# Generate a self-signed cert and key (dev only; prompts for subject)
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```

## Verify

```bash
# Verify a certificate against a CA bundle/file
openssl verify -CAfile ca.pem cert.pem
```

## Hash / base64

```bash
# Compute SHA-256 hash of a file
openssl sha256 file.bin

# Base64-encode a file
openssl base64 -in file.bin -out file.b64

# Base64-decode a file
openssl base64 -d -in file.b64 -out file.bin
```
