# 🐱 Meowvim

> The purr-fect Neovim configuration for a cozy coding session. May or may not increase your productivity by a feline factor.

<div align="center">

![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)
![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/retran/meowvim?style=for-the-badge)

</div>

<div align="center">
<img src="assets/icon_small.png" alt="Meowvim Logo" width="200">
<br>
<strong>Meowvim - Purr-fect Neovim</strong>
</div>

A carefully crafted Neovim configuration that provides a modern development environment. Part of the `project meow`, `Meowvim` includes curated plugins, intelligent defaults, and a consistent user experience.

## 🖼️ Screenshots

<div align="center">

### Dashboard
<img src="assets/screenshot_dashboard.png" alt="Meowvim Dashboard" width="800">

### Editor
<img src="assets/screenshot_editor.png" alt="Meowvim Editor" width="800">

</div>

## 🌟 Key Features

- **🚀 Zero Configuration**: Works out of the box with sensible defaults
- **🎨 Modern Interface**: Tokyo Night theme with clean UI components
- **🧠 AI-Powered**: GitHub Copilot integration for coding assistance
- **⚡ Performance**: Optimized with lazy loading
- **🔧 Customizable**: Easy to extend and modify
- **🌐 Language Support**: Works with major programming languages
- **📦 Plugin Collection**: 25+ curated plugins for development

## 📋 Table of Contents

- [✨ Features](#-features)
- [📋 Prerequisites](#-prerequisites)
- [🚀 Installation](#-installation)
- [⚡ Quick Start](#-quick-start)
- [⚙️ Configuration](#️-configuration)
- [🔧 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)

## ✨ Features

`Meowvim` includes these development features:

### 🧠 Intelligence & Completion

- **LSP Support**: Language Server Protocol integration with automatic setup
- **GitHub Copilot**: AI-powered code completion and suggestions
- **Completion Engine**: Context-aware autocompletion with nvim-cmp
- **Code Snippets**: Snippet collection with LuaSnip
- **Syntax Highlighting**: Syntax highlighting with Treesitter

### 🎨 Interface

- **Tokyo Night Theme**: Modern, readable colorscheme
- **Status Line**: Informative status bar with Git integration
- **Buffer Management**: Buffer navigation and organization
- **Icons**: Consistent iconography throughout
- **Indent Guides**: Visual indentation helpers

### 🔧 Development Tools

- **Git Integration**: Git workflow with Gitsigns and Fugitive
- **Code Formatting**: Automatic formatting with Conform.nvim
- **Linting**: Real-time code linting with nvim-lint
- **Debugging**: Debugging support with nvim-dap
- **Testing**: Test runner integration with Neotest
- **Refactoring**: Code refactoring tools

### 🚀 Productivity

- **Fuzzy Finder**: File and text search with Snacks
- **Auto-save**: Automatic file saving
- **Session Management**: Session persistence
- **Quick Navigation**: Leap motion for cursor movement
- **Comment Handling**: Smart comment toggling
- **Auto-pairs**: Automatic bracket and quote pairing

### 🎯 Language Support

- **Go**: Go development support with testing
- **TypeScript/JavaScript**: JS/TS development
- **Python**: Python development support
- **Lua**: Lua development for Neovim
- **Additional languages**: Extensible language support

## 📋 Prerequisites

Before installing `Meowvim`, ensure you have the following:

### Required

- **Neovim** ≥ 0.9.0
- **Git** (for plugin management)
- **A terminal** with true color support

### Recommended

- **Node.js** ≥ 18.0 (for some LSP servers and Copilot)
- **Python** ≥ 3.8 (for Python LSP and some plugins)
- **Go** ≥ 1.19 (for Go development)
- **Ripgrep** (for faster searching)
- **fd** (for faster file finding)
- **fzf** (for fuzzy finding)
- **JetBrains Mono Nerd Font** (for proper icon display)

### Optional

- **GitHub Copilot** subscription (for AI features)

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

### 2. Basic Navigation

- **Leader key**: `Space` (main entry point for features)
- **Open project**: `Space, f, p`

- **Open smart file finder**: `Space, Space`

### 3. Set Up GitHub Copilot (Optional)

```vim
:Copilot auth
```

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
