---
title: "<Title: X reference>"
type: "reference"
owner: "<name or team>"
last_updated: "YYYY-MM-DD"
---

# <Title: X reference>

<!--
Reference = information-oriented. It should be scannable, accurate, and complete for its scope.
Avoid narrative. Prefer tables, definitions, and canonical examples.
-->

## Scope

- **In scope:** <what this reference covers>
- **Out of scope:** <what it does not cover>

## Cheat sheet

Most-used commands/snippets for fast copy/paste.

| Task | Command |
|---|---|
| Identify version | `<command> --version` |
| Basic example | `<command> <args>` |
| Debug | `<command> -v` |
| Validate config | `<command> --check` |

## Quick start (minimal)

```bash
<one-line canonical example>
```

## Interfaces

### CLI commands

#### `<command>`

**Synopsis**

```text
<command> [options] <args>
```

**Parameters**

| Name | Required | Type | Default | Description |
|---|---:|---|---|---|
| `<param>` | yes/no | <string/int/bool> | <default> | <desc> |

**Options / flags**

| Flag | Alias | Default | Description |
|---|---|---|---|
| `--<flag>` | `-<f>` | <default> | <desc> |

**Exit codes**

| Code | Meaning | Notes |
|---:|---|---|
| 0 | Success | |
| 1 | Generic failure | |

**Examples**

```powershell
<windows example>
```

```bash
<linux/macos example>
```

**Common errors**

| Error | Meaning | Fix |
|---|---|---|
| `<error>` | <meaning> | <fix> |

---

### Configuration

#### Config file locations

- Windows: `<path>`
- Linux: `<path>`
- macOS: `<path>`

#### Config schema

| Key | Type | Default | Allowed values | Description |
|---|---|---|---|---|
| `<key>` | <type> | <default> | <values> | <desc> |

#### Examples

```yaml
<example config>
```

### Environment variables

| Name | Required | Default | Description |
|---|---:|---|---|
| `<ENV_VAR>` | yes/no | <default> | <desc> |

## Best Practices

- Keep the reference accurate and up to date; remove outdated examples.
- Prefer canonical examples that work across environments.
- Keep "how-to" steps out of Reference; link to a How-to guide instead.

## Security

### Authentication and authorization

- <How auth works>
- <Least-privilege guidance>

### Secrets handling

- Never store secrets in Git.
- Use: `<secret manager>` or `<encrypted store>`.
- Redaction patterns: `<what to redact from logs/output>`.

## Observability

### Logs

- Locations: <paths>
- Key events: <what to look for>
- Common filters:

```bash
<example>
```

### Metrics

| Metric | Type | Meaning | Alerts |
|---|---|---|---|
| `<metric>` | counter/gauge/histogram | <meaning> | <alert> |

### Tracing (if applicable)

- <trace IDs, propagation, sampling>

## Compatibility

- OS support: <Windows/Linux/macOS versions>
- Dependency versions: <list>
- Backward compatibility: <policy>

## Limits and known behaviors

- <Rate limits>
- <Timeouts>
- <Non-obvious defaults>

## Change log (doc)

| Date | Version | Change | Author |
|---|---|---|---|
| YYYY-MM-DD | 0.1.0 | Initial | <name> |

