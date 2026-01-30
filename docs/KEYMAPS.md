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
- [Git & Version Control](#git--version-control)
- [Testing](#testing)
- [Tasks & Runners](#tasks--runners)
- [Debug (DAP)](#debug-dap)
- [Options & UI](#options--ui)
- [Sessions](#sessions)
- [Workspace](#workspace)
- [Undo & History](#undo--history)
- [Notes & Scratch](#notes--scratch)
- [Help & Discovery](#help--discovery)
- [Mason](#mason)
- [Yank/Put Operations](#yankput-operations)
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
| `L` | Next buffer (alternative) |
| `H` | Previous buffer (alternative) |

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
| `<leader>bp` | Toggle buffer pin (hbac) |
| `<leader>bP` | Pin all buffers (hbac) |
| `<leader>bu` | Unpin all buffers (hbac) |
| `<leader>bf` | Next buffer (forward) |
| `<leader>br` | Rename buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Force delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>ba` | Delete all buffers |

---

## Bookmarks

**Prefix:** `<leader>m`

| Key | Description |
|-----|-------------|
| `<leader>mm` | Toggle bookmark |
| `<leader>mi` | Add bookmark with annotation |
| `<leader>mc` | Clean bookmarks in buffer |
| `<leader>mn` | Next bookmark |
| `<leader>mp` | Previous bookmark |
| `<leader>ml` | List bookmarks |
| `<leader>mx` | Clear all bookmarks |

Bookmark keywords: `@t` (task), `@w` (warning), `@f` (fix), `@n` (note)

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
| `<leader>sr` | Search and replace (Spectre) |
| `<leader>st` | Search TODO comments |

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
| `<leader>ns` | Document symbols |
| `<leader>nw` | Workspace symbols |

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

### Diagnostics

**Prefix:** `<leader>cd`

| Key | Description |
|-----|-------------|
| `<leader>cda` | All diagnostics (project-wide) |
| `<leader>cdb` | Buffer diagnostics |
| `<leader>cdq` | Quickfix list (Trouble) |
| `<leader>cdl` | Location list (Trouble) |
| `<leader>cds` | Document symbols (Trouble) |
| `<leader>cdh` | Line diagnostics (float) |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

### Code Actions

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>cc` | n, v | Code action |
| `<leader>cr` | n | Rename symbol |
| `<leader>cl` | n | Run code lens |
| `<leader>cL` | n | Refresh code lenses |
| `<leader>cf` | n | Format buffer |
| `<leader>cs` | v | Create code screenshot |
| `<leader>co` | n | Organize imports (TypeScript)* |

**Note:** `<leader>co` wraps the `:LspOrganize` command and is only available when a TypeScript/JavaScript buffer has an attached `tsserver` client.

### Rust Crates Management

**Prefix:** `<leader>cR`

Available when editing `Cargo.toml` files:

| Key | Description |
|-----|-------------|
| `<leader>cRt` | Toggle crates UI |
| `<leader>cRr` | Reload crates data |
| `<leader>cRu` | Update crate under cursor |
| `<leader>cRU` | Update all crates |
| `<leader>cRH` | Open crate homepage |
| `<leader>cRD` | Open crate documentation |

---

## Git & Version Control

**Prefix:** `<leader>g`

### LazyGit Integration

| Key | Description |
|-----|-------------|
| `<leader>gg` | LazyGit (full TUI) |
| `<leader>gf` | LazyGit Current File |

### Status

**Prefix:** `<leader>gs`

| Key | Description |
|-----|-------------|
| `<leader>gss` | Neogit status |
| `<leader>gsp` | Git status picker |

### Changes & Commits

**Prefix:** `<leader>gc`

| Key | Description |
|-----|-------------|
| `<leader>gcc` | Commit (Neogit) |
| `<leader>gcp` | Pull (Neogit) |
| `<leader>gcP` | Push (Neogit) |
| `<leader>gcb` | Git branches |
| `<leader>gcl` | Git log |
| `<leader>gcL` | Git log (current file) |

### Diff View

**Prefix:** `<leader>gd`

| Key | Description |
|-----|-------------|
| `<leader>gdo` | Open diff view |
| `<leader>gdc` | Close diff view |
| `<leader>gdf` | File history (current file) |
| `<leader>gdF` | Repository history (all files) |

### Hunks

**Prefix:** `<leader>gh`

| Key | Description |
|-----|-------------|
| `<leader>ghn` | Next hunk |
| `<leader>ghp` | Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghv` | Preview hunk |
| `<leader>ghb` | Blame line (full) |
| `<leader>ghd` | Diff this |

#### Hunk Toggles

**Prefix:** `<leader>ght`

| Key | Description |
|-----|-------------|
| `<leader>ghtb` | Toggle blame |
| `<leader>ghtw` | Toggle word diff |
| `<leader>ghts` | Toggle signs |

### Yank Git Links

**Prefix:** `<leader>gy`

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>gyy` | n, v | Copy git link to clipboard |
| `<leader>gyo` | n, v | Open git link in browser |

### Conflicts

**Prefix:** `<leader>gx`

| Key | Description |
|-----|-------------|
| `<leader>gxn` | Next conflict |
| `<leader>gxp` | Previous conflict |
| `<leader>gxo` | Choose ours |
| `<leader>gxt` | Choose theirs |
| `<leader>gxb` | Choose both |
| `<leader>gx0` | Choose none |
| `<leader>gxl` | List conflicts |
| `<leader>gxr` | Refresh conflicts |

### GitHub Integration

**Prefix:** `<leader>go`

| Key | Description |
|-----|-------------|
| `<leader>gop` | Open pull request |
| `<leader>goi` | Open issue |
| `<leader>goP` | Search pull requests |
| `<leader>goI` | Search issues |
| `<leader>got` | Toggle threads |

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

**Prefix:** `<leader>r`

| Key | Description |
|-----|-------------|
| `<leader>rr` | Run task template (Overseer) |
| `<leader>rl` | Restart last task |
| `<leader>ro` | Toggle task list |

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
| `<leader>dbt` | Toggle breakpoint |
| `<leader>dbc` | Conditional breakpoint |
| `<leader>dbl` | Log point |
| `<leader>dba` | Clear all breakpoints |
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
| `<leader>oz` | Close all folds |
| `<leader>oZ` | Open all folds |
| `<leader>op` | Peek fold |
| `<leader>on` | Toggle line numbers (cycles: none → normal → relative) |
| `<leader>ow` | Toggle line wrap |
| `<leader>os` | Toggle spell check |
| `<leader>oc` | Toggle cursor line |
| `<leader>oC` | Toggle cursor column |
| `<leader>oF` | Toggle format on save |
| `<leader>od` | Toggle dim inactive |
| `<leader>uc` | Colorscheme switcher (interactive) |

### Developer Tools

| Key | Description |
|-----|-------------|
| `<leader>oP` | Start profiling |
| `<leader>oL` | Show profiler dashboard |

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
| `<leader>qs` | Restore current directory session |
| `<leader>qS` | Restore session (picker) |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

Enhanced session management features:
- Auto-save on directory change
- Per-branch sessions (configurable)
- Pre-save hooks to close plugin windows
- Session picker for easy restoration

---

## Workspace

**Prefix:** `<leader>oW`

| Key | Description |
|-----|-------------|
| `<leader>oWa` | Add workspace folder |
| `<leader>oWR` | Remove workspace folder |
| `<leader>oWL` | List workspace folders |

---

## Undo & History

**Prefix:** `<leader>u`

| Key | Description |
|-----|-------------|
| `<leader>uu` | Undo history |
| `<leader>ur` | Redo history |
| `<leader>uy` | Yank history (Snacks picker) |

---

## Notes & Scratch

**Prefix:** `<leader>N` and `<leader>.`

| Key | Description |
|-----|-------------|
| `<leader>.` | Open/toggle scratch buffer |
| `<leader>No` | Open scratch buffer |
| `<leader>Nf` | Find scratch buffers |
| `<leader>Nn` | New named scratch buffer |

---

## Help & Discovery

**Prefix:** `<leader>oh`

| Key | Description |
|-----|-------------|
| `<leader>ohh` | Search help |
| `<leader>ohc` | Search commands |
| `<leader>ohk` | Search keymaps |
| `<leader>ohm` | Search marks |

---

## Mason

**Prefix:** `<leader>om`

| Key | Description |
|-----|-------------|
| `<leader>omm` | Open Mason UI |
| `<leader>omi` | Install Mason tools |

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

Documentation last updated: 2026-01-30
