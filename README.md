# 🐱 meowvim

[![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/network/members)

<div align="center">

### The purr-fect Neovim configuration for a cozy coding session. May or may not increase your productivity by a feline factor.


[Overview](#-overview) • [See It in Action](#-see-it-in-action) • [Key Features](#-key-features) • [Installation](#-installation) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Customization](#-customization) • [Troubleshooting](#-troubleshooting--support) • [Contributing](#-contributing)

</div>

---

## 🎯 Overview

**meowvim** is a fast, well-configured Neovim setup for the **project meow** ecosystem. It bundles curated plugins, sensible defaults, and playful touches so you can start coding immediately.

### Who Is This For?

- **Polyglot developers** who need LSP, formatting, debugging, and testing
- **Terminal users** who want speed without sacrificing polish
- **Project meow users** who need consistent setup across macOS and Linux
- **Automation fans** who value lazy-loading, sessions, and keymap discovery

## ✨ Key Features

### 🎨 Interface & UX

- **17 colorschemes** with 70+ variants: Catppuccin, TokyoNight, Rose Pine, Gruvbox, Nord, Kanagawa, Everforest, Nightfox, Zenbones, Solarized Osaka, Ayu, Dracula, Monokai Pro, One Dark, Material, Melange, GitHub
- **Transparency** from 0-100% opacity
- **Theme picker** with live preview (`:ColorschemeSelect` or `<leader>ok`)
- `noice.nvim` message center and command palette
- Smooth folds, indent guides, persistent layout with auto-reload

### 🧠 Language Support

- LSP servers with diagnostics, actions, and symbol navigation
- Treesitter syntax highlighting and structural selection
- Completion with `<C-j/k>` navigate, `<C-l>` smart accept (Copilot inline first, then blink.cmp), `<C-u>/<C-d>` scroll documentation

### 🚀 Navigation & Productivity

- **Flash motion** (`<leader><space>`) and Snacks finders for files, buffers, commands
- **LazyGit** (`<leader>gg`)
- **Marks** for quick navigation (`<leader>sm`)
- **Code screenshots** with syntax highlighting (`<leader>cs` in visual mode)
- **Auto buffer cleanup** (configurable threshold)
- **Sessions** with per-branch support and project switching
- TODO tracking, search & replace, git workflows via Diffview and Gitsigns

### 🐾 Project Meow Features

- **Config system** with Lua tables, auto-reload, project settings
- **Developer tools**: conflict detection, profiling, startup tracking
- **Automation**: `update-meowvim.sh` with backup/rollback, test suite
- **CI/CD** with lint and multi-platform tests
- mise-managed tools with auto PATH setup
- Overseer tasks, Neotest runners, DAP for Go, TypeScript, Python, more
- **AI code review** with inline annotations via meow.review.nvim (`<leader>r` group) and `<leader>yf/yl` file/line references

## 📦 Installation

### ⚙️ Prerequisites

| Type        | Requirements                                                   |
| ----------- | -------------------------------------------------------------- |
| Required    | Neovim ≥ 0.12, Git, true-color terminal                        |
| Recommended | Node.js ≥ 18, Python ≥ 3.8, Go ≥ 1.19, ripgrep, fd, fzf, Nerd Font |
| Optional    | GitHub Copilot                                                  |

### ⚡ Quick Install

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone meowvim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Start Neovim
nvim
```

Plugins install automatically on first launch via `lazy.nvim`.

### 🐾 Install with project meow

```bash
git clone https://github.com/retran/meow.git ~/.meow
cd ~/.meow
git submodule update --init
./bin/meowctl install personal
```

The `meow` automation links meowvim with your dotfiles.

### 🔧 Staying Updated

```bash
# Automated update with backup/rollback
./bin/update-meowvim.sh

# Or manually inside Neovim
:Lazy sync

# Check health after updates
:checkhealth meowvim
```

## 🚀 Quick Start

1. **Launch** — first run installs plugins and bootstraps LSP servers
2. **Configure** — edit `~/.config/meowvim/config.lua` (theme, transparency, features)
3. **Keymaps** — press `<leader>hk` for interactive search or see [Quick Reference](docs/KEYMAPS_QUICK_REFERENCE.md)
4. **Language tools** — install LSP servers, formatters, and debuggers via mise
5. **Navigate** — `<leader><space>` Flash jumps, `<leader>ff` file search, `<leader>gg` LazyGit, `F2` terminal
6. **Copilot** (optional) — authenticate via `:Copilot auth`

## 📖 Documentation

The full documentation lives in the [`docs/`](./docs/README.md) den:

- [01 – Installation & Upgrade Guide](docs/01-INSTALLATION.md)
- [02 – Configuration & Personalization](docs/02-CONFIGURATION.md)
- [03 – Daily Workflows & Recipes](docs/03-WORKFLOWS.md)
- [Keymaps Reference](docs/KEYMAPS.md) & [Quick Reference Card](docs/KEYMAPS_QUICK_REFERENCE.md)
- [Troubleshooting & Health Checks](docs/04-TROUBLESHOOTING.md)

Each guide follows the meowg1k documentation structure so you can prowl between tools without context switching.

## 🧩 Customization

Customize meowvim through simple Lua tables:

- **User config**: Edit `~/.config/meowvim/config.lua` - plain Lua table
- **Project settings**: Create `~/.config/meowvim/projects.lua` for project overrides
- **Commands**: `:MeowvimConfig`, `:MeowvimConfigReload`, `:MeowvimConfigShow`
- **Theme picker**: `:ColorschemeSelect` or `<leader>ok` for live preview
- **Options**: `lua/config/options.lua` - Neovim settings
- **Keymaps**: `lua/config/keymaps.lua` - discoverable with which-key
- **Plugins**: `lua/plugins/*.lua` - one file per plugin

See [Configuration Guide](docs/02-CONFIGURATION.md) for details.

## 🛠️ Troubleshooting & Support

- Run `:checkhealth meowvim` for comprehensive environment diagnostics
- Use developer tools: `:KeymapConflicts`, `:MeowvimProfile`, `:StartupTrends`
- Run test suite: `./bin/test-config.sh` to verify configuration integrity
- Visit [Troubleshooting](docs/04-TROUBLESHOOTING.md) for common fixes, performance tuning, and LSP tips
- Enable verbose logging with `:messages` and review `~/.local/state/nvim/log` if the cats get grumpy

## 🤝 Contributing

We welcome issues, feature ideas, and pull requests. Please:

1. Search existing issues to avoid duplicates.
2. Provide repro steps or screenshots where helpful.
3. Keep the cat puns tasteful and the Lua tidy.

## 📄 License

This project is released under the [MIT License](./LICENSE).

---

<div align="center">

### Made with ❤️ by Andrew Vasilyev and feline assistants Sonya Blade, Mila, and Marcus Fenix

**Happy coding with project meow! 🐱**

[⭐ Star us on GitHub](https://github.com/retran/meowvim) • [🐛 Report Bug](https://github.com/retran/meowvim/issues) • [💡 Request Feature](https://github.com/retran/meowvim/issues) • [🔀 Contribute](https://github.com/retran/meowvim/pulls)

</div>
