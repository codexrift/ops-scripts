# screen Cheat Sheet

GNU screen terminal multiplexer.

Prefix is `Ctrl+a` (written as `C-a`).

## Sessions

```bash
# Create a new screen session
screen -S work

# List screen sessions
screen -ls

# Reattach to a session
screen -r work

# Quit a named session
screen -S work -X quit
```

## Windows

- New: `C-a c`
- Next/prev: `C-a n` / `C-a p`
- List: `C-a "`
- Rename: `C-a A`
- Kill: `C-a k`

## Split regions

- Split: `C-a S`
- Next region: `C-a Tab`
- Remove region: `C-a X`
- Close other regions: `C-a Q`

## Copy mode

- Enter: `C-a [`
- Paste: `C-a ]`

## Logging

```text
C-a H
```

