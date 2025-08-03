# 🐱 Meowvim

> The purr-fect Neovim configuration for a cozy coding session. May or may not increase your productivity by a feline factor.

<div align="center">
  <img src="assets/icon_small.png" alt="Meowvim Logo" width="160">
  <br><br>
  <strong>Meowvim - Purr-fect Neovim</strong>
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

## 🚀 Installation

### Option 1: Fresh Installation

If you're starting fresh or want to replace your current Neovim config:

```bash
# Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone Meowvim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### Option 2: As Part of Meow System

If you're using [`meow` dotfiles management system](https://github.com/retran/meow):

```bash
# Clone the meow system
git clone https://github.com/retran/meow.git ~/.meow

# Initialize and update submodules (meowvim is connected as submodule)
cd ~/.meow
git submodule init
git submodule update

# Follow the meow installation instructions
./install.sh
```

## ⚡ Quick Start

After installation, follow these steps to get started:

### 1. First Launch

```bash
nvim
```

On first launch, `Meowvim` will:

- Install the Lazy.nvim plugin manager
- Download and install all plugins
- Configure Language Server Protocol (LSP) servers automatically

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

## ⚙️ Configuration

`Meowvim` is highly customizable. Here's how to make it your own:

### File Structure

```
~/.config/nvim/
├── init.lua              # Main configuration entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Neovim options
│   │   ├── keymaps.lua   # Key mappings
│   ├── plugins/          # Plugin configurations
│   └── utils/            # Utility functions
└── assets/               # Icons and resources
```

### Customizing Options

Edit `lua/config/options.lua` to change Neovim settings:

```lua
-- Example: Change tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Example: Enable line wrapping
vim.opt.wrap = true
```

### Adding Plugins

Create a new file in `lua/plugins/` directory:

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Customizing Keymaps

Edit `lua/config/keymaps.lua` to add your own key mappings:

```lua
-- Add your custom keymaps
{ "<leader>mp", ":MyPlugin<CR>", desc = "My Plugin" },
```

### Theme Customization

Switch themes by editing `lua/plugins/tokyonight.lua`:

```lua
-- Change variant
vim.cmd.colorscheme("tokyonight-storm")  -- or "tokyonight-day"
```

## 🔧 Troubleshooting

### Common Issues

#### Plugin Installation Fails

```bash
# Clear plugin cache and reinstall
rm -rf ~/.local/share/nvim/lazy
nvim --headless "+Lazy sync" +qa
```

#### LSP Not Working

1. Check if the language server is installed:

   ```vim
   :LspInfo
   ```

2. Language servers are managed by the `meow`. If you installed `Meowvim` as part of `meow`, they should be automatically available.
3. For standalone installation, you may need to install servers manually:

   ```bash
   # TypeScript/JavaScript
   npm install -g typescript typescript-language-server

   # Python
   pip install python-lsp-server

   # Go
   go install golang.org/x/tools/gopls@latest

   # Rust
   rustup component add rust-analyzer
   ```

#### Copilot Not Working

1. Authenticate with GitHub:

   ```vim
   :Copilot auth
   ```

2. Check status:

   ```vim
   :Copilot status
   ```

#### Performance Issues

1. Check startup time:

   ```vim
   :StartupTime
   ```

2. Disable unused plugins in `lua/plugins/`

#### Icons Not Displaying

Install [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads).

### Getting Help

- Use `:help` for Neovim documentation
- Check `:Lazy` for plugin management
- Use `<Space>?` for Which-key help
- Check the [issues page](https://github.com/retran/meowvim/issues)

## 🤝 Contributing

Contributions are welcome to help improve `Meowvim`! Here's how you can help:

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit code improvements
- 🎨 Enhance themes and UI

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

`Meowvim` builds on the excellent work of the Neovim community.

### Core Dependencies

- [Neovim](https://neovim.io/) - The extensible text editor
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin manager
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Beautiful colorscheme

### Plugins

- [auto-save.nvim](https://github.com/okuuva/auto-save.nvim) - Automatic file saving
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer line with tabs
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - Buffer completion source
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - LSP completion source
- [cmp-path](https://github.com/hrsh7th/cmp-path) - Path completion source
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) - LuaSnip completion source
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Smart commenting
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Code formatting
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot integration
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) - Copilot completion source
- [copilot-lualine](https://github.com/AndreM222/copilot-lualine) - Copilot status in lualine
- [FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim) - Fix CursorHold performance
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippet collection
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indentation guides
- [leap.nvim](https://github.com/ggandor/leap.nvim) - Quick navigation
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim) - LSP kind icons
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [mini.icons](https://github.com/echasnovski/mini.icons) - Icon provider
- [neodev.nvim](https://github.com/folke/neodev.nvim) - Lua development setup
- [neotest](https://github.com/nvim-neotest/neotest) - Test runner
- [neotest-go](https://github.com/nvim-neotest/neotest-go) - Go test adapter
- [noice.nvim](https://github.com/folke/noice.nvim) - Improved UI
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim) - UI components library
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-pairing
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug adapter protocol
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Debug UI
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linting
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio) - Async I/O library
- [nvim-notify](https://github.com/rcarriga/nvim-notify) - Notification system
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Context display
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Text objects
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - File icons
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utilities
- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) - Refactoring tools
- [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) - JSON schema store
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Collection of utilities
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git commands
- [vim-repeat](https://github.com/tpope/vim-repeat) - Repeat plugin commands
- [vim-startuptime](https://github.com/dstein64/vim-startuptime) - Startup profiling
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding help

### Inspiration

- [LazyVim](https://github.com/LazyVim/LazyVim) - Modern Neovim configuration
- [Spacemacs](https://github.com/syl20bnr/spacemacs) - Emacs configuration framework

### Author

`Meowvim` is developed by Andrew Vasilyev with help from GitHub Copilot and feline assistants Sonya Blade, Mila, and Marcus Fenix.

---

<div align="center">

**Happy coding with `project meow`! 🐱**

Made with ❤️ by Andrew Vasilyev and feline assistants

[Report Bug](https://github.com/retran/meow/issues) · [Request Feature](https://github.com/retran/meow/issues) · [Contribute](https://github.com/retran/meow/pulls)

</div>
ues) ・ [📬 Suggest Feature](https://github.com/retran/meowvim/issues) ・ [📥 Contribute](https://github.com/retran/meowvim/pulls)

</div>
