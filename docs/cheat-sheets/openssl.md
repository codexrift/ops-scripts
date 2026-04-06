# OpenSSL Cheat Sheet

TLS/crypto utilities.

## Inspect certificates

Show cert details:

```bash
openssl x509 -in cert.pem -text -noout
```

Show expiry dates:

```bash
openssl x509 -in cert.pem -noout -dates
```

## Test TLS connection

```bash
openssl s_client -connect example.com:443 -servername example.com
```

Show peer cert chain:

```bash
openssl s_client -connect example.com:443 -servername example.com -showcerts
```

## Keys & CSR

Generate private key (RSA):

```bash
openssl genrsa -out key.pem 2048
```

Generate CSR:

```bash
openssl req -new -key key.pem -out req.csr
```

Self-signed cert (dev):

```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```

## Verify

```bash
openssl verify -CAfile ca.pem cert.pem
```

## Hash / base64

```bash
openssl sha256 file.bin
openssl base64 -in file.bin -out file.b64
openssl base64 -d -in file.b64 -out file.bin
```

