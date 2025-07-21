# 🐱 Meowvim

> The purr-fect Neovim configuration for a cozy and productive coding session.

<div align="center">
  <img src="assets/icon_small.png" alt="Meowvim Logo" width="160">
  <br><br>
  <strong>Modern, minimal, and cat-approved Neovim setup.</strong>
  <br><br>
  
  ![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)
  ![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)
  ![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)
  ![GitHub forks](https://img.shields.io/github/forks/retran/meowvim?style=for-the-badge)
</div>

---

A carefully curated Neovim configuration that delivers a modern and delightful developer experience. Part of the [Project Meow](https://github.com/retran/meow), `Meowvim` includes elegant defaults, essential plugins, and playful polish.

---

## 🖼️ Screenshots

<div align="center">

### Dashboard
<img src="assets/screenshot_dashboard.png" alt="Dashboard Screenshot" width="800">

### Editor
<img src="assets/screenshot_editor.png" alt="Editor Screenshot" width="800">

</div>

---

## 🌟 Key Features

- 🚀 **Zero Configuration** – Sensible defaults out of the box  
- 🎨 **Modern UI** – Clean interface powered by Tokyo Night theme  
- 🧠 **AI Integration** – GitHub Copilot support for smart code suggestions  
- ⚡ **Fast & Lazy** – Optimized with Lazy.nvim for performance  
- 🔧 **Fully Customizable** – Easy to extend with your own tweaks  
- 🌐 **Language Ready** – Preconfigured LSPs for major languages  
- 📦 **25+ Curated Plugins** – For everything from Git to testing  
- 🧑‍💻 **GitHub Copilot Subscription** – Optional AI enhancements

---

## 📦 Installation

### 🔹 Option 1: Fresh Setup

```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/retran/meowvim.git ~/.config/nvim
nvim
```

### 🔹 Option 2: Use with `meow` System

```bash
git clone https://github.com/retran/meow.git ~/.meow
cd ~/.meow
git submodule update --init
./install.sh
```

---

## ⚡ Quick Start

```bash
nvim
```

On first launch, Meowvim will:
- Automatically install Lazy.nvim
- Fetch and configure plugins
- Set up LSP servers
- **Leader key**: `Space` (main entry point for features)
- **Open project**: `Space, f, p`
- **Open smart file finder**: `Space, Space`

### Optional: Set Up GitHub Copilot

```vim
:Copilot auth
```

---

## 🛠 Prerequisites

### Required
- [Neovim](https://neovim.io) ≥ 0.9.0  
- Git  
- Terminal with true color support

### Recommended
- Node.js ≥ 18  
- Python ≥ 3.8  
- Go ≥ 1.19  
- [Ripgrep](https://github.com/BurntSushi/ripgrep)  
- [fd](https://github.com/sharkdp/fd)  
- [fzf](https://github.com/junegunn/fzf)  
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)

---

## 🔧 Configuration

The config is modular and easy to modify:

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua   # Neovim options
│   │   ├── keymaps.lua   # Key mappings
│   ├── plugins/          # Plugin configurations
│   └── utils/            # Utility functions
└── assets/               # Icons and resources
```

Edit options: `lua/config/options.lua`  
Customize keymaps: `lua/config/keymaps.lua`  
Add plugins: `lua/plugins/`  
Change theme: `lua/plugins/tokyonight.lua`

---

## 🧠 Features (In Detail)

### Code Intelligence
- Full LSP support
- GitHub Copilot integration
- Autocompletion via `nvim-cmp`
- LuaSnip for snippets
- Treesitter for syntax and structure

### Interface
- Tokyo Night theme
- Status bar (lualine)
- Buffer tabs
- Icons (devicons)
- Indentation guides

### Dev Tools
- Git tools: Fugitive, Gitsigns
- Formatters: Conform.nvim
- Linters: nvim-lint
- Debugger: nvim-dap
- Tests: Neotest

### Productivity
- Fuzzy finder (Snacks)
- Autosave
- Session manager
- Motion tools (Leap)
- Comment toggles
- Auto-pairing

### Language Support
- TypeScript / JavaScript  
- Python  
- Go  
- Lua  
- ...and more!

---

## ❓ Troubleshooting

### Plugins not installing?
```bash
rm -rf ~/.local/share/nvim/lazy
nvim --headless "+Lazy sync" +qa
```

### LSP not working?
```vim
:LspInfo
```

Install missing servers (e.g. `npm i -g typescript-language-server`).

### Copilot issues?
```vim
:Copilot auth
:Copilot status
```

### Font issues?
Install a Nerd Font like [JetBrains Mono](https://www.nerdfonts.com/font-downloads).

---

## 🤝 Contributing

All contributions welcome!

- 🐞 Fix bugs  
- 📖 Improve docs  
- ✨ Add features  
- 🎨 Suggest theme tweaks  

---

## 📄 License

MIT License – see [`LICENSE`](LICENSE) file.

---

## 🙏 Credits

Built by [Andrew Vasilyev](https://github.com/retran)  
With help from GitHub Copilot and cats Sonya Blade, Mila & Marcus Fenix 🐈

Thanks to:
- [LazyVim](https://github.com/LazyVim/LazyVim)  
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)  
- [bubu07codes](https://github.com/bubu07codes)  
- All open source plugin authors!

---

<div align="center">

✨ Happy coding with Meowvim ✨  
[🐛 Report Issue](https://github.com/retran/meowvim/issues) ・ [📬 Suggest Feature](https://github.com/retran/meowvim/issues) ・ [📥 Contribute](https://github.com/retran/meowvim/pulls)

</div>