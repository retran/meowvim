# 🐱 meowvim

[![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/network/members)

<div align="center">

### The purr-fect Neovim configuration for a cozy coding session. May or may not increase your productivity by a feline factor.

<img src="assets/icon_small.png" alt="meowvim logo" width="200">

[Overview](#-overview) • [See It in Action](#-see-it-in-action) • [Key Features](#-key-features) • [Installation](#-installation) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Customization](#-customization) • [Troubleshooting](#-troubleshooting--support) • [Contributing](#-contributing)

</div>

---

## 🎯 Overview

**meowvim** delivers a cozy yet powerful Neovim configuration that feels right at home in the **project meow** ecosystem. It bundles a curated plugin suite, ergonomic defaults, and playful cat energy so you can drop into a modern editor experience within minutes.

### Who Is meowvim For?

- **Polyglot developers** who need LSP, formatting, debugging, and testing across languages
- **Terminal purists** who want speed and minimalism without sacrificing UI polish
- **Project meow cats** aiming for a consistent setup across macOS, Linux, and Neovide
- **Automation enthusiasts** who value lazy-loading, session persistence, and keymap discoverability

## 🎬 See It in Action

<div align="center">

### Welcome Dashboard

<img src="assets/screenshot_dashboard.png" alt="meowvim dashboard" width="800">

### Focused Editing

<img src="assets/screenshot_editor.png" alt="meowvim editor" width="800">

</div>

## ✨ Key Features

### 🎨 Cozy Interface & UX

- Catppuccin-inspired theming, custom statusline, and icon-rich buffer overview
- `noice.nvim` powered message center, notifications, and command palette UX
- Smooth folding, indent guides, and persistent layout tuned for both terminal and Neovide

### 🧠 Language Intelligence

- Auto-configured LSP servers with diagnostics, code actions, and symbol navigation
- Treesitter-powered syntax highlighting, context display, and structural selection
- Completion via `nvim-cmp`, snippet support with `LuaSnip`, and optional GitHub Copilot integration

### 🚀 Productivity & Navigation

- Flash-powered motion (`<leader><space>`) and Snacks fuzzy finders for files, buffers, and commands
- Session persistence, project switching, and scratch buffers for quick note taking
- Integrated TODO tracking, spectre-powered search & replace, and git workflows via Neogit, Diffview, and Gitsigns

### 🐾 Project Meow Integrations

- Raycast launcher scripts (`bin/`) for instant GUI access
- Mason-managed toolchains with automatic PATH injection
- Overseer task templates, Neotest runners, and DAP presets for Go, TypeScript, Python, and more

## 📦 Installation

### ⚙️ Prerequisites

| Type        | Requirements                                                             |
| ----------- | ------------------------------------------------------------------------ |
| Required    | Neovim ≥ 0.10, Git, true-color capable terminal                          |
| Recommended | Node.js ≥ 18, Python ≥ 3.8, Go ≥ 1.19, `ripgrep`, `fd`, `fzf`, Nerd Font |
| Optional    | GitHub Copilot subscription, Neovide, Raycast (for launcher scripts)     |

### ⚡ Quick Install (fresh setup)

```bash
# Backup any previous config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone meowvim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Launch the purr-fect editor
nvim
```

Plugins install on first launch via `lazy.nvim`. Sit back and let the cats arrange the house.

### 🐾 Install with project meow

```bash
git clone https://github.com/retran/meow.git ~/.meow
cd ~/.meow
git submodule update --init
./bin/meowctl install personal
```

The `meow` automation links meowvim as part of the broader dotfiles ecosystem, including Raycast scripts and helper tools.

### 🔧 Staying Updated

```bash
# Inside Neovim
:Lazy sync
:MasonToolsUpdate
```

## 🚀 Quick Start

1. **Launch Neovim** — first run installs plugins and bootstraps default LSP servers.
2. **Discover keymaps** — press `<leader>ohk` for an interactive keymap palette or peek at the [Quick Reference](docs/KEYMAPS_QUICK_REFERENCE.md).
3. **Install language tooling** — open Mason (`<leader>omm`) to review and install any missing LSP, formatter, or debugger.
4. **Supercharge navigation** — try `<leader><space>` for Flash jumps, `<leader>ff` for fuzzy file search, tap `F2` for the floating terminal, and `<leader>gss` for Git status workflows.
5. **Optional Copilot** — authenticate via `:Copilot auth` to invite your AI cat companion.

## 📖 Documentation

The full documentation lives in the [`docs/`](./docs/README.md) den:

- [01 – Installation & Upgrade Guide](docs/01-INSTALLATION.md)
- [02 – Configuration & Personalization](docs/02-CONFIGURATION.md)
- [03 – Daily Workflows & Recipes](docs/03-WORKFLOWS.md)
- [Keymaps Reference](docs/KEYMAPS.md) & [Quick Reference Card](docs/KEYMAPS_QUICK_REFERENCE.md)
- [Troubleshooting & Health Checks](docs/04-TROUBLESHOOTING.md)

Each guide follows the meowg1k documentation structure so you can prowl between tools without context switching.

## 🧩 Customization

- Tune core options in `lua/config/options.lua` for UI, spell checking, and performance tweaks.
- Add or adjust keymaps in `lua/config/keymaps.lua`; discovery is baked in with which-key.
- Drop new plugins into `lua/plugins/*.lua` — lazy loading keeps startup snappy.
- Tailor Neovide behavior via `lua/config/neovide.lua` and enable per-host overrides under `after/`.
- Scripts in `bin/` integrate with Raycast, while `scripts/` power dashboard art and helper commands.

## 🛠️ Troubleshooting & Support

- Run `:checkhealth` for environment diagnostics.
- Visit [Troubleshooting](docs/04-TROUBLESHOOTING.md) for common fixes, performance tuning, and LSP tips.
- Enable verbose logging with `:messages` and review `~/.local/state/nvim/log` if the cats get grumpy.

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
