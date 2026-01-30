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
| `<leader>gss` | Git status |
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
| `Tab` / `L` | Next buffer |
| `Shift+Tab` / `H` | Previous buffer |

## 🔍 Search

| Key | Action |
|-----|--------|
| `<leader>s/` | Grep in project |
| `<leader>sb` | Search buffers |
| `<leader>sr` | Search & replace |
| `<leader>st` | TODO comments |

## 🎯 Navigation

| Key | Action |
|-----|--------|
| `<leader><space>` | Flash jump |
| `<leader>nd` | Go to definition |
| `<leader>nr` | Find references |
| `<leader>ni` | Find implementations |
| `<leader>ns` | Document symbols |
| `]d` / `[d` | Next/prev diagnostic |

## 💡 Code

| Key | Action |
|-----|--------|
| `<leader>cc` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer |
| `<leader>cda` | Show diagnostics |
| `<leader>cdh` | Line diagnostics |

### 🦀 Rust (Cargo.toml)

| Key | Action |
|-----|--------|
| `<leader>cRt` | Toggle crates UI |
| `<leader>cRu` | Update crate |
| `<leader>cRU` | Update all crates |
| `<leader>cRH` | Open homepage |

## 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gss` | Git status |
| `<leader>gcc` | Commit |
| `<leader>ghn` / `<leader>ghp` | Next/prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghv` | Preview hunk |
| `<leader>gyy` | Copy git link |

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
| `<leader>dbt` | Toggle breakpoint |
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
| `<leader>oF` | Toggle format on save |
| `F2` | Toggle terminal |
| `<leader>uc` | Colorscheme switcher |

## 📝 Editing

| Key | Action |
|-----|--------|
| `jj` | Exit insert mode |
| `p` / `P` | Paste after/before |
| `Alt+n` / `Alt+p` | Cycle yank history |
| `<leader>uu` | Undo history |
| `<leader>uy` | Yank history |

## 🆘 Help

| Key | Action |
|-----|--------|
| `<leader>ohh` | Search help |
| `<leader>ohk` | Search keymaps |
| `<leader>ohc` | Search commands |

## 💡 Tips

- Leader key is `<space>`
- Use `<leader>ohk` to search all keymaps interactively
- Most keymaps work in visual mode too
- Flash jump (`<leader><leader>`) is your friend for quick navigation
- f/t movements also show visual jump labels like Flash

---

For complete documentation, see [KEYMAPS.md](KEYMAPS.md)
