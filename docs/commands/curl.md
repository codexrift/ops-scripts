# curl Cheat Sheet

HTTP client for quick checks and API calls.

```bash
# Simple GET request
curl https://example.com

# Follow redirects
curl -L https://example.com

# Fetch only response headers
curl -I https://example.com

# Add a bearer token header
curl -H "Authorization: Bearer $TOKEN" https://api.example.com/items

# POST JSON payload
curl -X POST https://api.example.com/items -H "Content-Type: application/json" -d '{"name":"a"}'
```

