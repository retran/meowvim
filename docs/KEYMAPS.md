# 🎹 meowvim Keymaps Reference

> Comprehensive guide to all keyboard shortcuts and keybindings in meowvim.

This document provides a complete reference of all keymaps available in
meowvim. The configuration uses `<leader>` (space key by default) as the
primary prefix for most commands.

## 📚 Table of Contents

- [General Bindings](#general-bindings)
- [File Operations](#file-operations)
- [Buffer Management](#buffer-management)
- [Window Management](#window-management)
- [Search & Navigation](#search--navigation)
- [Jump (Flash)](#jump-flash)
- [Code Navigation](#code-navigation)
- [Code Intelligence](#code-intelligence)
- [Completion & Copilot](#completion--copilot)
- [Git & Version Control](#git--version-control)
- [Testing](#testing)
- [Tasks & Runners](#tasks--runners)
- [Code Review](#code-review)
- [Debug (DAP)](#debug-dap)
- [Options & UI](#options--ui)
- [Sessions](#sessions)
- [Undo & History](#undo--history)
- [Notes & Scratch](#notes--scratch)
- [Help & Discovery](#help--discovery)
- [Yank/Put Operations](#yankput-operations)
- [Yank References](#yank-references)
- [Quit](#quit)
- [Terminal](#terminal)

---

## General Bindings

### Insert Mode

| Key | Description |
|-----|-------------|
| `jj` | Exit insert mode (Escape alternative) |
| `оо` | Exit insert mode (Cyrillic layout support) |

### Normal Mode - Buffer Navigation

| Key | Description |
|-----|-------------|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |

### Spelling

| Key | Description |
|-----|-------------|
| `zg` | Add word to spell file |
| `zw` | Mark word as incorrect |

---

## File Operations

**Prefix:** `<leader>f`

| Key | Description |
|-----|-------------|
| `<leader>ff` | Smart find file (context-aware) |
| `<leader>fF` | Find file (all files) |
| `<leader>fg` | Find in git files |
| `<leader>fr` | Recent files |
| `<leader>fn` | New file (with path creation) |
| `<leader>fe` | Toggle file explorer |
| `<leader>fp` | Project picker |
| `<leader>fs` | Save current file |
| `<leader>fS` | Save all files |

---

## Buffer Management

**Prefix:** `<leader>b`

| Key | Description |
|-----|-------------|
| `<leader>bb` | List buffers (picker) |
| `<leader>bn` | New buffer |
| `<leader>br` | Rename buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Force delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>ba` | Delete all buffers |
| `<leader>bp` | Toggle pin buffer |
| `<leader>bP` | Pin all buffers |
| `<leader>bu` | Unpin all buffers |

---

## Bookmarks

The bookmark system has been replaced with a simpler marks-based system using Snacks picker. See `<leader>sm` under [Search & Navigation](#search--navigation).

---

## Window Management

**Prefix:** `<leader>w`

### Navigation

| Key | Description |
|-----|-------------|
| `<leader>wh` | Focus left window |
| `<leader>wj` | Focus lower window |
| `<leader>wk` | Focus upper window |
| `<leader>wl` | Focus right window |

### Splits

| Key | Description |
|-----|-------------|
| `<leader>ws` | Split horizontal |
| `<leader>wv` | Split vertical |
| `<leader>wc` | Close window |
| `<leader>wo` | Close other windows |

### Tabs

| Key | Description |
|-----|-------------|
| `<leader>wt` | New tab |
| `<leader>wT` | Close tab |
| `]t` / `[t` | Next/Previous tab |

### Resize

| Key | Description |
|-----|-------------|
| `<leader>w=` | Equalize windows |
| `<leader>w>` | Increase width |
| `<leader>w<` | Decrease width |
| `<leader>w+` | Increase height |
| `<leader>w-` | Decrease height |

### Move

| Key | Description |
|-----|-------------|
| `<leader>wH` | Move window far left |
| `<leader>wL` | Move window far right |
| `<leader>wK` | Move window far top |
| `<leader>wJ` | Move window far bottom |

---

## Search & Navigation

**Prefix:** `<leader>s`

| Key | Description |
|-----|-------------|
| `<leader>s/` | Search in project (grep) |
| `<leader>sb` | Search in open buffers |
| `<leader>sg` | Search in git (git grep) |
| `<leader>sm` | Search marks (Snacks picker) |
| `<leader>sr` | Search and replace (Spectre) |
| `<leader>st` | Search TODO comments |
| `<leader>sw` | Workspace symbols (Snacks picker) |

**Note:** `<leader>sr` works in both normal and visual mode for selection-based search.

---

## Jump (Flash)

**Prefix:** `<leader>j` and `<leader><space>`

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader><space>` | n, x, o | Quick jump (Flash) |
| `<leader>jj` | n, x, o | Flash jump in current window |
| `<leader>jt` | n, x, o | Flash treesitter (jump to AST nodes) |
| `<leader>ja` | n, x, o | Flash jump (all windows) |
| `<leader>jm` | n, x, o | Flash remote operation |

---

## Code Navigation

**Prefix:** `<leader>n`

### LSP Navigation

| Key | Description |
|-----|-------------|
| `<leader>nd` | Glance definitions |
| `<leader>nD` | Pick declaration (picker) |
| `<leader>nr` | Glance references |
| `<leader>ni` | Glance implementations |
| `<leader>nt` | Glance type definitions |

### Workspace Folders

**Prefix:** `<leader>nW`

| Key | Description |
|-----|-------------|
| `<leader>nWa` | Add workspace folder |
| `<leader>nWR` | Remove workspace folder |
| `<leader>nWL` | List workspace folders |

### Hierarchies

| Key | Description |
|-----|-------------|
| `<leader>nh` | Type hierarchy (subtypes) |
| `<leader>nH` | Type hierarchy (supertypes) |
| `<leader>nc` | Call hierarchy (callers) |
| `<leader>nC` | Call hierarchy (callees) |

---

## Code Intelligence

**Prefix:** `<leader>c`

### Actions

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>cc` | n, v | Code action |
| `<leader>cr` | n | Rename symbol |
| `<leader>cl` | n | Run code lens |
| `<leader>cL` | n | Refresh code lenses |
| `<leader>cf` | n | Format buffer |
| `<leader>co` | n | Organize imports (TypeScript/JavaScript) |

### Diagnostics

| Key | Description |
|-----|-------------|
| `<leader>cd` | Project diagnostics (Snacks picker) |
| `<leader>cD` | Buffer diagnostics (Snacks picker) |
| `<leader>ch` | Line diagnostics (float) |
| `<leader>cq` | Quickfix list |
| `<leader>cs` | Browse symbols (Snacks picker) |
| `]d` / `[d` | Next/Previous diagnostic |
| `]q` / `[q` | Next/Previous quickfix item |
| `]l` / `[l` | Next/Previous location list item |
| `]b` / `[b` | Next/Previous buffer |

### Rust Crates Management

**Prefix:** `<leader>cC`

Available when editing `Cargo.toml` files:

| Key | Description |
|-----|-------------|
| `<leader>cCt` | Toggle crates UI |
| `<leader>cCr` | Reload crates data |
| `<leader>cCu` | Update crate under cursor |
| `<leader>cCU` | Update all crates |
| `<leader>cCH` | Open crate homepage |
| `<leader>cCD` | Open crate documentation |

---

## Completion & Copilot

meowvim features two separate systems that work together:
- **Completion popup** (blink.cmp) - Shows LSP suggestions, snippets, and buffer words
- **Copilot** - Inline gray text AI suggestions

Both systems are designed to never interfere with each other, with completely separate keymaps.

### Completion Popup (blink.cmp)

**Navigation (hjkl-based):**

| Key | Description |
|-----|-------------|
| `<C-j>` | Navigate down in popup (next item) |
| `<C-k>` | Navigate up in popup (previous item) |
| `<C-l>` | Accept selected completion (move right/forward) |
| `<C-Space>` | Manually trigger completion |
| `<Esc>` | Dismiss popup (and Copilot) |

**Documentation:**

| Key | Description |
|-----|-------------|
| `<C-u>` | Scroll documentation up |
| `<C-d>` | Scroll documentation down |

**Snippet Navigation:**

| Key | Description |
|-----|-------------|
| `<Tab>` | Jump to next snippet placeholder (or indent) |
| `<S-Tab>` | Jump to previous snippet placeholder (or dedent) |

**Note:** `<C-l>` is a smart accept: if a Copilot inline suggestion is visible it accepts that; otherwise it confirms the selected cmp item.

### GitHub Copilot (Inline Suggestions)

Copilot shows gray text suggestions as you type (auto-triggered).

**Inline suggestion control (insert mode):**

| Key | Description |
|-----|-------------|
| `<C-l>` | Accept inline suggestion (smart: Copilot first, then selected cmp item) |
| `<Esc>` | Dismiss inline suggestion and stay in insert mode; if no suggestion, exit insert |

**Toggle:**

| Key | Description |
|-----|-------------|
| `<leader>oC` | Toggle Copilot on/off globally |

### Tab & Enter Behavior

These keys preserve their normal Vim behavior:

| Key | Behavior |
|-----|----------|
| `<Tab>` | Indent (or jump to next snippet placeholder if in snippet) |
| `<S-Tab>` | Dedent (or jump to previous snippet placeholder if in snippet) |
| `<CR>` | Always creates a newline (never intercepts for completion) |

### Enable/Disable Copilot

```vim
:Copilot enable   " Enable Copilot
:Copilot disable  " Disable Copilot
:Copilot auth     " Authenticate with GitHub
:Copilot status   " Check Copilot status
```

Or use the toggle keymap: `<leader>oC`

### Conflict-Free Design

The keymaps are designed to be completely conflict-free:

- **Completion popup** uses `<C-j/k/l>` (hjkl pattern)
- **Copilot inline** accept uses `<C-l>` (shared smart accept — Copilot takes priority)
- `<Esc>` dismisses Copilot inline suggestion first (staying in insert); falls through to exit insert if no suggestion is visible
- `<Tab>` and `<Enter>` never interfere with completion

This design allows both Copilot and the completion popup to coexist without conflicts.

---

## Git & Version Control

**Prefix:** `<leader>g`

### LazyGit & Status

| Key | Description |
|-----|-------------|
| `<leader>gg` | LazyGit (full TUI) |
| `<leader>gf` | LazyGit current file |
| `<leader>gb` | Git blame line |
| `<leader>gB` | Git browse (open in browser) |
| `<leader>gC` | Commit (Neogit) |
| `<leader>gp` | Pull (Neogit) |
| `<leader>gP` | Push (Neogit) |
| `<leader>gw` | Browse branches |

### Hunks

**Prefix:** `<leader>gH`

| Key | Description |
|-----|-------------|
| `<leader>gHs` | Stage hunk |
| `<leader>gHr` | Reset hunk |
| `<leader>gHS` | Stage buffer |
| `<leader>gHR` | Reset buffer |
| `<leader>gHv` | Preview hunk |
| `<leader>gHd` | Diff buffer |
| `]h` / `[h` | Next/Previous hunk |

### Diffview

**Prefix:** `<leader>gD`

| Key | Description |
|-----|-------------|
| `<leader>gDd` | Open diff explorer |
| `<leader>gDh` | File history |
| `<leader>gDH` | Repo history |
| `<leader>gDc` | Close Diffview |

### Git Links

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>gy` | n, v | Copy git link |
| `<leader>gY` | n, v | Open git link in browser |

### Conflicts

**Prefix:** `<leader>gx`

| Key | Description |
|-----|-------------|
| `<leader>gxo` | Choose ours |
| `<leader>gxt` | Choose theirs |
| `<leader>gxb` | Choose both |
| `<leader>gxn` | Choose none |
| `<leader>gxl` | List conflicts |
| `]x` / `[x` | Next/Previous conflict |

### GitHub

**Prefix:** `<leader>gh`

| Key | Description |
|-----|-------------|
| `<leader>ghp` | Open pull request |
| `<leader>ghi` | Open issue |
| `<leader>ghP` | Search pull requests |
| `<leader>ghI` | Search issues |
| `<leader>ght` | Toggle threads |

---

## Testing

**Prefix:** `<leader>t`

| Key | Description |
|-----|-------------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ts` | Run test suite |
| `<leader>tS` | Toggle test summary |
| `<leader>to` | Show test output |
| `<leader>td` | Debug nearest test |
| `<leader>tx` | Stop tests |

---

## Tasks & Runners

**Prefix:** `<leader>x`

| Key | Description |
|-----|-------------|
| `<leader>xr` | Run task template (Overseer) |
| `<leader>xl` | Restart last task |
| `<leader>xo` | Toggle task list |

---

## Code Review

AI-assisted inline code review via `meow.review.nvim`.

**Prefix:** `<leader>r`

### Adding & Managing Comments

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>ra` | n, v | Add comment (modal; Tab cycles type, `<C-s>` confirms) |
| `<leader>rd` | n, v | Delete comment |
| `<leader>rE` | n | Edit comment (pre-filled modal) |
| `<leader>rv` | n | View comment under cursor |

### Export

| Key | Description |
|-----|-------------|
| `<leader>re` | Export review to clipboard |
| `<leader>rf` | Export to file (prompts for filename) |
| `<leader>rF` | Export annotations for current file only |
| `<leader>rC` | Export and clear all annotations |
| `<leader>rc` | Clear all annotations |
| `<leader>rr` | Reload from store file |

### Navigation & Pickers

| Key | Description |
|-----|-------------|
| `<leader>rg` | Go to comment (picker; jump to any annotation) |
| `<leader>rG` | Go to comment in current file |
| `<leader>rt` | Go to comment by type (type picker, then annotation picker) |
| `<leader>rx` | Resolve comment at cursor |
| `<leader>rX` | Resolve all comments |
| `<leader>rV` | Validate annotations (detect stale) |
| `]r` | Next review comment |
| `[r` | Previous review comment |

---

## Debug (DAP)

**Prefix:** `<leader>d`

### Debug Control

| Key | Description |
|-----|-------------|
| `<leader>dc` | Continue / Start debugging |
| `<leader>dt` | Terminate debug session |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Run to cursor |
| `<leader>du` | Toggle debug UI |
| `<leader>dR` | Open REPL |

### Breakpoints

**Prefix:** `<leader>db`

| Key | Description |
|-----|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Clear all breakpoints |
| `<leader>dbc` | Conditional breakpoint |
| `<leader>dbl` | Log point |
| `<leader>dbe` | Exception breakpoints |

### Debug Views

**Prefix:** `<leader>dv`

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>dvs` | n | View scopes |
| `<leader>dvf` | n | View frames |
| `<leader>dvh` | n, v | Inspect hover |
| `<leader>dvp` | n, v | Preview variable |

---

## Options & UI

**Prefix:** `<leader>o`

### UI Toggles

| Key | Description |
|-----|-------------|
| `<leader>og` | Toggle indent guides |
| `<leader>on` | Toggle line numbers (cycles: none → normal → relative) |
| `<leader>ow` | Toggle line wrap |
| `<leader>os` | Toggle spell check |
| `<leader>oc` | Toggle cursor line |
| `<leader>of` | Toggle format on save |
| `<leader>oa` | Toggle auto-save |
| `<leader>od` | Toggle dim inactive |
| `<leader>oe` | Toggle signcolumn |
| `<leader>ol` | Toggle whitespace characters |
| `<leader>oh` | Toggle search highlighting |
| `<leader>ox` | Toggle diagnostics |
| `<leader>oi` | Toggle inlay hints |
| `<leader>ok` | Colorscheme switcher (interactive) |

### Developer Tools

**Prefix:** `<leader>oP`

| Key | Description |
|-----|-------------|
| `<leader>oPs` | Profile startup time (`:StartupTime`) |

Commands:
- `:KeymapConflicts` - Show keymap conflicts
- `:KeymapList [mode]` - List all keymaps for mode
- `:ProfileStart` / `:ProfileStop` - Control profiling
- `:MeowvimProfile` - Show plugin load times
- `:MeasureRender` - Measure buffer render time
- `:StartupTrends` - Analyze startup time trends

---

## Sessions

**Prefix:** `<leader>q`

| Key | Description |
|-----|-------------|
| `<leader>qs` | Restore session |
| `<leader>qS` | Select session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop saving session |
| `<leader>qq` | Quit all |
| `<leader>qQ` | Force quit all |

Sessions are managed by `persistence.nvim` and save automatically.

---

## Undo & History

**Prefix:** `<leader>u`

| Key | Description |
|-----|-------------|
| `<leader>uu` | Undo history |
| `<leader>ur` | Redo history |

---

## Notes & Scratch

**Prefix:** `<leader>N` and `<leader>.`

| Key | Description |
|-----|-------------|
| `<leader>.` | Open/toggle scratch buffer (fast alias) |
| `<leader>Ns` | Open scratch buffer |
| `<leader>Nf` | Find scratch buffers |
| `<leader>Nn` | New named scratch buffer |

---

## Help & Discovery

**Prefix:** `<leader>h`

| Key | Description |
|-----|-------------|
| `<leader>hh` | Search help |
| `<leader>hc` | Search commands |
| `<leader>hk` | Search keymaps |
| `<leader>hm` | Search man pages |
| `<leader>hn` | Notification history |

---

## Yank/Put Operations

### Basic Put/Paste

| Key | Modes | Description |
|-----|-------|-------------|
| `p` | n, x | Put after cursor (Yanky) |
| `P` | n, x | Put before cursor (Yanky) |
| `gp` | n, x | Put after and leave cursor after |
| `gP` | n, x | Put before and leave cursor after |

### Cycle Through Yank History

| Key | Description |
|-----|-------------|
| `Alt+n` | Next entry in yank ring |
| `Alt+p` | Previous entry in yank ring |

### Indented Put

| Key | Description |
|-----|-------------|
| `]p` | Put after with indent (linewise) |
| `[p` | Put before with indent (linewise) |
| `]P` | Put after with indent (linewise, alternative) |
| `[P` | Put before with indent (linewise, alternative) |

### Shifted Put

| Key | Description |
|-----|-------------|
| `>p` | Put after and shift right |
| `<p` | Put after and shift left |
| `>P` | Put before and shift right |
| `<P` | Put before and shift left |

### Filtered Put

| Key | Description |
|-----|-------------|
| `=p` | Put after with filter |
| `=P` | Put before with filter |

---

## Yank References

Copy file/line references in OpenCode/Claude-compatible format (e.g. `@lua/plugins/copilot.lua:42`).

**Prefix:** `<leader>y`

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>yf` | n | Copy file reference (e.g. `@lua/plugins/copilot.lua`) |
| `<leader>yh` | n | Show yank history (Snacks picker) |
| `<leader>yl` | n, v | Copy line reference (e.g. `@lua/plugins/copilot.lua:42`) |

---

## Quit

**Prefix:** `<leader>q`

| Key | Description |
|-----|-------------|
| `<leader>qq` | Quit all |
| `<leader>qQ` | Force quit all |

---

## Terminal

| Key | Modes | Description |
|-----|-------|-------------|
| `F2` | n, t | Toggle floating terminal |

---

## Plugin-Specific Keymaps

### Treesitter Swap

**Prefix:** `<leader>S`

Treesitter swap operations are available through the group `<leader>S`. Actual bindings are defined by the nvim-treesitter plugin configuration.

---

## Tips & Tricks

### Context-Aware Features

- **Smart Find File** (`<leader>ff`): Intelligently chooses between git files,
  recent files, or all files based on context
- **Flash Jump** (`<leader><space>` or `<leader>jj`): Quick navigation to any
  visible text with minimal keystrokes
- **Code Actions** (`<leader>cc`): Context-aware actions based on cursor
  position and LSP capabilities

### Visual Mode Enhancements

Many operations work in visual mode:

- `<leader>sr`: Search and replace with selection
- `<leader>gyy/gyo`: Git link operations on selected lines
- `<leader>cc`: Code actions on selection
- All yank/put operations

### Multi-Window Navigation

Flash Jump supports multi-window jumping:

- `<leader>ja`: Jump to any text in any visible window
- `<leader>jm`: Remote operations across windows

### Diagnostic Navigation

Quick diagnostic navigation without prefix:

- `]d`: Next diagnostic
- `[d`: Previous diagnostic

---

## Configuration

All keymaps are defined in:

- Main keymaps: `lua/config/keymaps.lua`
- Plugin-specific: `lua/plugins/*.lua`

To customize keymaps, edit these files or add your own in `lua/config/custom.lua`.

---

## Legend

- **n**: Normal mode
- **i**: Insert mode
- **v**: Visual mode
- **x**: Visual and select mode
- **o**: Operator-pending mode
- **t**: Terminal mode

**Notation:**

- `<leader>` = Space key
- `Ctrl` = Control key
- `Shift` = Shift key
- `Alt` = Alt/Option key

---

## Documentation Info

Documentation last updated: 2026-04-01
