# 🎹 meowvim Quick Keymap Reference

Quick reference card for the most commonly used keymaps in meowvim.

## 🔥 Most Used

| Key | Action |
|-----|--------|
| `<leader>ff` | Smart find file |
| `<leader>s/` | Search in project |
| `<leader><space>` | Flash jump |
| `<leader>bb` | List buffers |
| `<leader>fe` | Toggle file explorer |
| `<leader>gg` | LazyGit |
| `<leader>cc` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>nd` | Go to definition |
| `<leader>nr` | Find references |

## 📁 Files & Buffers

| Key | Action |
|-----|--------|
| `<leader>ff` | Find file (smart) |
| `<leader>fr` | Recent files |
| `<leader>fs` | Save file |
| `<leader>bb` | Buffer list |
| `<leader>bd` | Delete buffer |
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |

## 🔍 Search

| Key | Action |
|-----|--------|
| `<leader>s/` | Grep in project |
| `<leader>sb` | Search buffers |
| `<leader>sm` | Search marks |
| `<leader>sr` | Search & replace |
| `<leader>st` | TODO comments |
| `<leader>sw` | Workspace symbols |

## 🎯 Navigation

| Key | Action |
|-----|--------|
| `<leader><space>` | Flash jump |
| `<leader>nd` | Go to definition |
| `<leader>nr` | Find references |
| `<leader>ni` | Find implementations |
| `]d` / `[d` | Next/prev diagnostic |

## 💡 Code

| Key | Action |
|-----|--------|
| `<leader>cc` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Show diagnostics |
| `<leader>ch` | Line diagnostics |

## ✨ Completion & AI

### Completion Popup

| Key | Action |
|-----|--------|
| `<C-j>` | Next item (↓) |
| `<C-k>` | Previous item (↑) |
| `<C-l>` | Accept completion |
| `<C-Space>` | Trigger manually |
| `<Esc>` | Dismiss |

### Copilot (Inline)

| Key | Action |
|-----|--------|
| `<C-l>` | Accept suggestion (smart: Copilot first, then cmp) |
| `<Esc>` | Dismiss suggestion (stay in insert mode) |

### Copilot NES (Normal Mode)

| Key | Action |
|-----|--------|
| `<M-l>` | Accept NES + jump to end of edit |
| `<M-j>` | Accept NES, stay at cursor |
| `<M-h>` | Dismiss NES |

**Note:** Tab indents, Enter creates newline (never intercepted)

### 🦀 Rust (Cargo.toml)

| Key | Action |
|-----|--------|
| `<leader>cCt` | Toggle crates UI |
| `<leader>cCu` | Update crate |
| `<leader>cCU` | Update all crates |
| `<leader>cCH` | Open homepage |

## 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gb` | Git blame line |
| `]h` / `[h` | Next/prev hunk |
| `<leader>gHs` | Stage hunk |
| `<leader>gHv` | Preview hunk |
| `<leader>gy` | Copy git link |

## 🪟 Windows

| Key | Action |
|-----|--------|
| `<leader>wh/j/k/l` | Navigate windows |
| `<leader>ws` | Split horizontal |
| `<leader>wv` | Split vertical |
| `<leader>wc` | Close window |

## 🧪 Testing

| Key | Action |
|-----|--------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ts` | Run test suite |
| `<leader>tS` | Toggle summary |

## 🐛 Debug

| Key | Action |
|-----|--------|
| `<leader>dc` | Continue/Start |
| `<leader>db` | Toggle breakpoint |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle UI |

## ⚙️ Options

| Key | Action |
|-----|--------|
| `<leader>on` | Toggle line numbers |
| `<leader>ow` | Toggle wrap |
| `<leader>os` | Toggle spell |
| `<leader>og` | Toggle indent guides |
| `<leader>od` | Toggle dim |
| `<leader>of` | Toggle format on save |
| `F2` | Toggle terminal |
| `<leader>ok` | Colorscheme switcher |

## 📝 Editing

| Key | Action |
|-----|--------|
| `jj` | Exit insert mode |
| `<Tab>` | Indent / Snippet jump |
| `<CR>` | New line (always) |
| `p` / `P` | Paste after/before |
| `Alt+n` / `Alt+p` | Cycle yank history |
| `<leader>uu` | Undo history |
| `<leader>yh` | Yank history |

## 🏃 Tasks & Review

| Key | Action |
|-----|--------|
| `<leader>xr` | Run task (Overseer) |
| `<leader>xl` | Rerun last task |
| `<leader>xo` | Toggle task list |
| `<leader>ra` | Review: add comment |
| `<leader>rd` | Review: delete comment |
| `<leader>re` | Review: export to clipboard |
| `<leader>rg` | Review: go to comment |
| `]r` / `[r` | Next/prev review comment |
| `<leader>yf` | Copy file reference |
| `<leader>yl` | Copy line reference |

## 🆘 Help

| Key | Action |
|-----|--------|
| `<leader>hh` | Search help |
| `<leader>hk` | Search keymaps |
| `<leader>hc` | Search commands |

## 💡 Tips

- Leader key is `<space>`
- Use `<leader>hk` to search all keymaps interactively
- Completion uses `<C-j/k>` to navigate, `<C-l>` to smart accept (Copilot inline first, then cmp)
- Copilot NES uses `<M-l/j/h>` in normal mode
- Tab always indents, Enter always creates newline
- Flash jump (`<leader><space>`) is your friend for quick navigation
- f/t movements also show visual jump labels like Flash

---

For complete documentation, see [KEYMAPS.md](KEYMAPS.md)
