# Terminal Multiplexers Cheat Sheet (tmux + screen)

## tmux

Default prefix is `Ctrl+b` (written as `C-b`).

Sessions:

```bash
tmux new -s work
tmux new -A -s work
tmux ls
tmux attach -t work
tmux kill-session -t work
```

Windows:

- New: `C-b c`
- Next/prev: `C-b n` / `C-b p`
- Choose: `C-b w`
- Rename: `C-b ,`
- Kill: `C-b &`

Panes:

- Split L/R: `C-b %`
- Split T/B: `C-b "`
- Switch: `C-b o`
- Close: `C-b x`

Copy mode:

- Enter: `C-b [`
- Paste: `C-b ]`

Config reload:

```bash
tmux source-file ~/.tmux.conf
```

## GNU screen

Prefix is `Ctrl+a` (written as `C-a`).

Sessions:

```bash
screen -S work
screen -ls
screen -r work
screen -S work -X quit
```

Windows:

- New: `C-a c`
- Next/prev: `C-a n` / `C-a p`
- List: `C-a "`
- Rename: `C-a A`
- Kill: `C-a k`

Split regions:

- Split: `C-a S`
- Next region: `C-a Tab`
- Remove region: `C-a X`
- Close other regions: `C-a Q`

Copy mode:

- Enter: `C-a [`
- Paste: `C-a ]`

Logging:

```text
C-a H
```

