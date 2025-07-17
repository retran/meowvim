# 🐱 MeowVim

> The purr-fect Neovim configuration for a cozy coding session

<div align="center">

![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)
![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/retran/meowvim?style=for-the-badge)

</div>

```
                        /\   /\
                       (  . .)
                        )   (
                       (  v  )
                      ^^  ^  ^^
                    MeowVim - Purr-fect Neovim
```

A carefully crafted Neovim configuration that transforms your editor into a powerful, beautiful, and efficient development environment. Part of the [meow configuration system](https://github.com/retran/meow), MeowVim provides a comprehensive setup with modern plugins, intelligent defaults, and a delightful user experience.

## 📋 Table of Contents

- [✨ Features](#-features)
- [📋 Prerequisites](#-prerequisites)
- [🚀 Installation](#-installation)
- [⚡ Quick Start](#-quick-start)
- [⚙️ Configuration](#️-configuration)
- [🎯 Usage Examples](#-usage-examples)
- [🔧 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)

## ✨ Features

MeowVim comes packed with powerful features that make coding a joy:

### 🧠 Intelligence & Completion
- **LSP Support**: Full Language Server Protocol integration with automatic setup
- **GitHub Copilot**: AI-powered code completion and suggestions
- **Smart Completion**: Context-aware autocompletion with nvim-cmp
- **Code Snippets**: Extensive snippet collection with LuaSnip
- **Syntax Highlighting**: Advanced syntax highlighting with Treesitter

### 🎨 Beautiful Interface
- **Tokyo Night Theme**: Modern, eye-friendly colorscheme
- **Status Line**: Informative lualine with Git integration
- **Buffer Management**: Elegant buffer line with easy navigation
- **Icons**: Beautiful icons throughout the interface
- **Indent Guides**: Visual indentation helpers

### 🔧 Development Tools
- **Git Integration**: Seamless Git workflow with Gitsigns and Fugitive
- **Code Formatting**: Automatic formatting with Conform.nvim
- **Linting**: Real-time code linting with nvim-lint
- **Debugging**: Full debugging support with nvim-dap
- **Testing**: Integrated test runner with Neotest
- **Refactoring**: Advanced refactoring tools

### 🚀 Productivity Boosters
- **Fuzzy Finder**: Fast file and text search with Snacks
- **Auto-save**: Automatic file saving
- **Session Management**: Persistent sessions and window layouts
- **Quick Navigation**: Leap motion for lightning-fast cursor movement
- **Comment Toggling**: Smart comment handling
- **Auto-pairs**: Automatic bracket and quote pairing

### 🎯 Language Support
- **Go**: Full Go development support with testing
- **TypeScript/JavaScript**: Modern JS/TS development
- **Python**: Comprehensive Python support
- **Lua**: Enhanced Lua development for Neovim
- **And many more**: Extensible language support

## 📋 Prerequisites

Before installing MeowVim, ensure you have the following:

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
- **A Nerd Font** (for proper icon display)

### Optional but Recommended
- **Neovide** (GUI Neovim client) - A launch script is included
- **GitHub Copilot** subscription (for AI features)

## 🚀 Installation

### Option 1: Fresh Installation

If you're starting fresh or want to replace your current Neovim config:

```bash
# Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone MeowVim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### Option 2: As Part of Meow System

If you're using the complete [meow configuration system](https://github.com/retran/meow):

```bash
# Clone the meow system
git clone https://github.com/retran/meow.git ~/.meow

# Follow the meow installation instructions
cd ~/.meow
./install.sh
```

### Platform-Specific Setup

#### macOS
```bash
# Install Neovim
brew install neovim

# Install optional dependencies
brew install ripgrep fd
```

#### Linux (Ubuntu/Debian)
```bash
# Install Neovim
sudo apt update
sudo apt install neovim

# Install optional dependencies
sudo apt install ripgrep fd-find
```

#### Windows
```powershell
# Install Neovim using Scoop
scoop install neovim

# Install optional dependencies
scoop install ripgrep fd
```

## ⚡ Quick Start

After installation, follow these steps to get started:

### 1. First Launch
```bash
nvim
```

On first launch, MeowVim will:
- Install the Lazy.nvim plugin manager
- Download and install all plugins
- Set up Language Server Protocol (LSP) servers

### 2. Basic Navigation
- **Leader key**: `Space` (most commands start with Space)
- **Open file finder**: `Space + Space`
- **Command palette**: `:`
- **Exit**: `:q` or `ZZ`

### 3. Essential Commands
```vim
" File operations
:e filename        " Edit file
:w                 " Save file
:q                 " Quit

" Window management
<C-h/j/k/l>       " Navigate windows
<Leader>w         " Window commands

" Buffer management
<Tab>             " Next buffer
<S-Tab>           " Previous buffer
```

### 4. Set Up GitHub Copilot (Optional)
```vim
:Copilot auth
```

## ⚙️ Configuration

MeowVim is highly customizable. Here's how to make it your own:

### File Structure
```
~/.config/nvim/
├── init.lua              # Main configuration entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Neovim options
│   │   ├── keymaps.lua   # Key mappings
│   │   └── neovide.lua   # Neovide GUI settings
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

## 🎯 Usage Examples

### File Management
```vim
" Open file finder
<Space><Space>

" Find files by name
<Space>f

" Find in files (grep)
<Space>g

" Recent files
<Space>r
```

### Code Navigation
```vim
" Go to definition
gd

" Go to references
gr

" Hover information
<Space>k

" Code actions
<Space>ca
```

### Git Operations
```vim
" Git status
<Space>gs

" Git blame
<Space>gb

" Git commits
<Space>gc
```

### Testing
```vim
" Run nearest test
<Space>tn

" Run all tests
<Space>ta

" Test file
<Space>tf
```

### Debugging
```vim
" Toggle breakpoint
<Space>db

" Start debugging
<Space>dc

" Step over
<Space>do
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
2. Install missing servers:
   ```vim
   :Mason
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
Install a Nerd Font:
```bash
# Download and install a Nerd Font
# https://www.nerdfonts.com/font-downloads
```

### Getting Help
- Use `:help` for Neovim documentation
- Check `:Lazy` for plugin management
- Use `<Space>?` for Which-key help
- Check the [issues page](https://github.com/retran/meowvim/issues)

## 🤝 Contributing

We welcome contributions to make MeowVim even better! Here's how you can help:

### Ways to Contribute
- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit code improvements
- 🎨 Enhance themes and UI

### Development Setup
```bash
# Fork the repository
git clone https://github.com/YOUR-USERNAME/meowvim.git
cd meowvim

# Create a feature branch
git checkout -b feature/amazing-feature

# Make your changes and test thoroughly

# Commit your changes
git commit -m "Add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Create a Pull Request
```

### Code Style
- Follow existing code patterns
- Use meaningful variable names
- Comment complex logic
- Keep functions focused and small
- Test your changes thoroughly

### Pull Request Guidelines
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a Pull Request with a clear description

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

MeowVim stands on the shoulders of giants. Special thanks to:

### Core Dependencies
- [Neovim](https://neovim.io/) - The extensible text editor
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin manager
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Beautiful theme

### Plugin Ecosystem
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration
- [GitHub Copilot](https://github.com/zbirenbaum/copilot.lua) - AI assistance

### Inspiration
- [LazyVim](https://github.com/LazyVim/LazyVim) - Modern Neovim configuration
- [AstroNvim](https://github.com/AstroNvim/AstroNvim) - Feature-rich configuration
- [NvChad](https://github.com/NvChad/NvChad) - Blazing fast configuration

### Community
- The amazing Neovim community
- Plugin maintainers and contributors
- Users who provide feedback and suggestions

---

<div align="center">

**Happy coding with MeowVim! 🐱**

Made with ❤️ by the MeowVim team

[Report Bug](https://github.com/retran/meowvim/issues) · [Request Feature](https://github.com/retran/meowvim/issues) · [Contribute](https://github.com/retran/meowvim/pulls)

</div>