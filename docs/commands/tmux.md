# tmux Cheat Sheet

Terminal multiplexer.

Default prefix is `Ctrl+b` (written as `C-b`).

## Sessions

```bash
# Create a new session named work
tmux new -s work

# Attach to existing session or create it if missing
tmux new -A -s work

# List sessions
tmux ls

# Attach to a session
tmux attach -t work

# Kill a session
tmux kill-session -t work
```

## Windows

- New: `C-b c`
- Next/prev: `C-b n` / `C-b p`
- Choose: `C-b w`
- Rename: `C-b ,`
- Kill: `C-b &`

## Panes

- Split L/R: `C-b %`
- Split T/B: `C-b "`
- Switch: `C-b o`
- Close: `C-b x`

## Copy mode

- Enter: `C-b [`
- Paste: `C-b ]`

## Config reload

```bash
# Reload tmux config
tmux source-file ~/.tmux.conf
```

