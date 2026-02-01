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
| `<leader>mm` | Search marks (Snacks picker) |

Note: The bookmark system has been replaced with a simpler marks-based system using Snacks picker.

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
| `<leader>cd` | Project diagnostics (Trouble) |
| `<leader>cD` | Buffer diagnostics (Trouble) |
| `<leader>ch` | Line diagnostics (float) |
| `<leader>cq` | Quickfix list |
| `<leader>cs` | Browse symbols (Trouble) |
| `]d` / `[d` | Next/Previous diagnostic |
| `]q` / `[q` | Next/Previous quickfix item |
| `]l` / `[l` | Next/Previous location list item |
| `]b` / `[b` | Next/Previous buffer |

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

## Completion & Copilot

meowvim features two separate systems that work together:
- **Completion popup** (nvim-cmp) - Shows LSP suggestions, snippets, and buffer words
- **Copilot** - Inline gray text AI suggestions

Both systems are designed to never interfere with each other, with completely separate keymaps.

### Completion Popup (nvim-cmp)

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
| `<C-b>` | Scroll documentation up |
| `<C-f>` | Scroll documentation down |

**Snippet Navigation:**

| Key | Description |
|-----|-------------|
| `<Tab>` | Jump to next snippet placeholder (or indent) |
| `<S-Tab>` | Jump to previous snippet placeholder (or dedent) |

**Important:** `<C-n>` and `<C-p>` are reserved for Copilot and will NOT navigate the completion popup.

### GitHub Copilot (Inline Suggestions)

Copilot shows gray text suggestions as you type (auto-triggered).

**Suggestion Control:**

| Key | Description |
|-----|-------------|
| `<C-y>` | Accept full Copilot suggestion |
| `<C-g>` | Accept next word only |
| `<C-n>` | Cycle to next alternative suggestion |
| `<C-p>` | Cycle to previous alternative suggestion |
| `<Esc>` | Dismiss Copilot suggestion (and popup) |

**Panel:**

| Key | Description |
|-----|-------------|
| `<M-CR>` | Open Copilot panel (alternative suggestions view) |

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

Or use the toggle system:
```vim
:lua vim.g.copilot_enabled = false  " Disable
:lua vim.g.copilot_enabled = true   " Enable
```

### Conflict-Free Design

The keymaps are designed to be completely conflict-free:

- **Completion popup** uses `<C-j/k/l>` (hjkl pattern)
- **Copilot** uses `<C-y/g/n/p>` (separate keys)
- `<C-n>/<C-p>` always pass through to Copilot (reserved)
- `<Esc>` dismisses both systems at once
- `<Tab>` and `<Enter>` never interfere with completion

This design allows both Copilot and the completion popup to be visible simultaneously without conflicts.

---

## Git & Version Control

**Prefix:** `<leader>g`

### LazyGit & Status

| Key | Description |
|-----|-------------|
| `<leader>gg` | LazyGit (full TUI) |
| `<leader>gf` | LazyGit current file |
| `<leader>gl` | Git log |
| `<leader>gb` | Git blame line |
| `<leader>gB` | Git browse (open in browser) |
| `<leader>gC` | Commit (Neogit) |
| `<leader>gp` | Pull (Neogit) |
| `<leader>gP` | Push (Neogit) |
| `<leader>gw` | Browse branches |

### Hunks

| Key | Description |
|-----|-------------|
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gR` | Reset buffer |
| `<leader>gv` | Preview hunk |
| `<leader>gd` | Diff buffer |
| `]h` / `[h` | Next/Previous hunk |

### DiffView

**Prefix:** `<leader>gD`

| Key | Description |
|-----|-------------|
| `<leader>gDo` | Open diff view |
| `<leader>gDc` | Close diff view |
| `<leader>gDf` | File history (current file) |
| `<leader>gDh` | Repository history |

### Git Links

| Key | Modes | Description |
|-----|-------|-------------|
| `<leader>gy` | n, v | Copy git link |
| `<leader>gY` | n, v | Open git link in browser |

### Conflicts

| Key | Description |
|-----|-------------|
| `<leader>go` | Choose ours |
| `<leader>gt` | Choose theirs |
| `]x` / `[x` | Next/Previous conflict |

**Prefix:** `<leader>gx`

| Key | Description |
|-----|-------------|
| `<leader>gxb` | Choose both |
| `<leader>gxn` | Choose none |
| `<leader>gxl` | List conflicts |

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
| `<leader>oPs` | Start profiling |
| `<leader>oPe` | Stop profiling |
| `<leader>oPl` | Show plugin load times |
| `<leader>oPr` | Measure render time |

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
| `<leader>qq` | Quit all |
| `<leader>qQ` | Force quit all |

Note: Session management has been simplified. Auto-save and restoration happens automatically.

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

## Mason

**Prefix:** `<leader>T`

| Key | Description |
|-----|-------------|
| `<leader>Tm` | Open Mason UI |
| `<leader>Ti` | Install Mason tools |

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
