# Vim Cheat Sheet

Modal editor. The two core modes you use most: **Normal** and **Insert**.

## Getting around

- Normal mode: `Esc`
- Insert mode: `i` (insert), `a` (append), `o` (new line below), `O` (new line above)

Movement:

- `h j k l` left/down/up/right
- `w` next word, `b` previous word, `e` end of word
- `0` start of line, `^` first non-blank, `$` end of line
- `gg` top, `G` bottom, `:{number}` go to line
- `Ctrl+d` half-page down, `Ctrl+u` half-page up

## Open/save/quit

- Save: `:w`
- Quit: `:q`
- Save and quit: `:wq` or `ZZ`
- Quit without saving: `:q!`
- Edit file: `:e path/to/file`

## Editing

- Delete char: `x`
- Delete word: `dw`
- Delete to end of line: `D` (same as `d$`)
- Change word: `cw`
- Change to end of line: `C`
- Replace char: `r{char}`
- Replace mode: `R`

Counts:

- `3dw` delete 3 words
- `10j` move down 10 lines

## Copy/paste (yank/put)

- Yank line: `yy`
- Yank selection: `v` then move, then `y`
- Paste after cursor: `p`
- Paste before cursor: `P`

## Visual mode

- Character visual: `v`
- Line visual: `V`
- Block visual: `Ctrl+v`

Indent:

- Indent: `>`
- Outdent: `<`
- Reindent selection: `=`

## Search/replace

- Search forward: `/pattern` then `n` / `N`
- Search backward: `?pattern`
- Search word under cursor: `*` / `#`

Replace in file:

```vim
" Substitute in the whole file (global on each line)
:%s/old/new/g

" Substitute with confirmation (prompt for each match)
:%s/old/new/gc
```

## Undo/redo

- Undo: `u`
- Redo: `Ctrl+r`

## Buffers, windows, tabs

Buffers:

```vim
" List buffers
:ls

" Next buffer
:bnext

" Previous buffer
:bprev

" Delete (close) current buffer
:bd
```

Splits:

- Horizontal split: `:split` (`:sp`)
- Vertical split: `:vsplit` (`:vs`)
- Move between splits: `Ctrl+w` then `h j k l`

Tabs:

```vim
" Open a new tab
:tabnew

" Next tab
:tabnext

" Previous tab
:tabprev
```

## Useful options (temporary)

```vim
" Show absolute line numbers
:set number

" Show relative line numbers
:set relativenumber

" Case-insensitive search unless pattern contains uppercase
:set ignorecase smartcase

" Show whitespace characters (tabs/trailing spaces) if configured
:set list
```

## Help

```vim
" General help
:help

" Help for :substitute
:help :s

" Help topic
:help visual-mode
```
