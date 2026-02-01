# Configuration & Personalization

meowvim features a powerful configuration system with a Lua DSL, auto-reload capabilities, and project-specific settings. This guide walks through the building blocks you can tweak to make the editor feel like home.

## 1. Configuration System Overview

Starting from Phase 0, meowvim includes a comprehensive configuration system:

- **User config**: `~/.config/meowvim/config.lua` - Your personal settings
- **Project config**: `~/.config/meowvim/projects.lua` - Per-project overrides
- **Auto-reload**: File watching with 500ms debounce
- **Validation**: Schema-based type checking
- **Caching**: Performance optimization for repeated access

### User Config Example

```lua
local config = require("meowvim.config.builder")

config.core({
  theme = "catppuccin",
  variant = "mocha",
  enable_copilot = true,
})

config.ui({
  transparency = 15, -- 0-100%
  statusline_style = "bubbles",
})

config.lsp({
  format_on_save = true,
  diagnostic_signs = true,
})

config.editor({
  relative_numbers = true,
  indent_width = 2,
})

return config.build()
```

### Available Config Modules

- **core**: Theme, colorscheme variant, Copilot toggle
- **ui**: Transparency, statusline style, dashboard
- **lsp**: Format on save, diagnostics, signs
- **editor**: Line numbers, indent, spell checking
- **git**: Integration settings, auto-commit
- **performance**: Lazy loading, cache settings
- **custom**: Your own key-value pairs

### Config Commands

| Command | Description |
|---------|-------------|
| `:MeowvimConfig` | Open user config file |
| `:MeowvimConfigReload` | Reload config and apply changes |
| `:MeowvimConfigValidate` | Validate config against schema |
| `:MeowvimConfigShow` | Display current configuration |
| `:MeowvimProjects` | List all projects |
| `:MeowvimProject <name>` | Switch to project and apply settings |
| `:MeowvimProjectCurrent` | Show current project |

### Project-Specific Configuration

Create `~/.config/meowvim/projects.lua`:

```lua
local config = require("meowvim.config.builder")

return {
  work = config.project({
    root = "~/work",
    theme = "tokyonight",
    variant = "night",
    ui = { transparency = 0 },
    lsp = { format_on_save = true },
  }),
  
  personal = config.project({
    root = "~/personal",
    theme = "rose-pine",
    variant = "moon",
    ui = { transparency = 25 },
  }),
}
```

### Accessing Config in Plugins

```lua
local config_ok, config = pcall(require, "meowvim.config")
if config_ok then
  local theme = config.get("core.theme", "catppuccin")
  local transparency = config.get("ui.transparency", 0)
end
```

## 2. Directory Layout

```
~/.config/nvim/
├── init.lua                # Main entry point
├── after/                  # Optional local overrides (autoloaded)
├── bin/                    # Raycast launch scripts
├── docs/                   # Documentation den (you are here!)
├── lua/
│   ├── config/             # Core editor settings
│   │   ├── keymaps.lua
│   │   ├── neovide.lua
│   │   └── options.lua
│   ├── plugins/            # One file per plugin or feature
│   └── utils/              # Helper modules, toggles, patches
├── scripts/                # Helper commands used by plugins/UX
└── spell/                  # Personal dictionaries (auto-created)
```

Most customization lives under `lua/config/` and `lua/plugins/`. Files in `after/` load last and are ideal for machine-specific overrides that you don’t want to commit.

## 3. Editor Options

`lua/config/options.lua` contains the baseline Neovim settings. A few highlights:

- **UI:** relative numbers, cursorline, statusline, background theme, smooth folds
- **Text editing:** spaces over tabs, smart indentation, 2-space defaults
- **Search:** smart case, incremental highlight, "ignorecase" enabled
- **Spell:** automatic dictionaries for Markdown, Neorg, and git messages
- **Performance:** tuned update intervals, foldexpr configuration, and session defaults

Modify this file directly or duplicate the settings you want to change inside an `after/plugin/options.lua` file for local tweaks.

## 4. Keymaps

All leader mappings and helper combos live in `lua/config/keymaps.lua`. Each entry is a table describing the key, command, and description, making it compatible with which-key and Snacks pickers.

```lua
{ "<leader>ff", require("snacks").picker.files, desc = "Find files" }
```

- Use `<leader>ohk` in editor to discover everything interactively.
- Place personal keymaps in `after/plugin/keymaps.lua` to keep them separate from upstream updates.
- Non-leader commands (like `jj` to escape) can be added using standard `vim.keymap.set` calls.

Refer to the [Keymaps Reference](./KEYMAPS.md) for the canonical list.

### Keymap Conflict Detection

Use `:KeymapConflicts` to detect duplicate or conflicting keymaps, or `:KeymapList [mode]` to list all keymaps for a specific mode.

## 5. Plugins & Lazy Specs

Lazy loading keeps meowvim snappy. Each file in `lua/plugins/` returns a plugin spec. To add new functionality:

```lua
-- lua/plugins/catppuccin.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin")
  end,
}
```

Tips:

- Follow existing files for patterns (e.g., `flash.lua`, `trouble.lua`).
- Set `event`, `cmd`, or `ft` properties to lazy load when appropriate.
- For personal plugins, create a dedicated file and commit it in your fork or local branch.

## 6. Language Tooling

meowvim uses Mason, nvim-lspconfig, nvim-lint, Conform.nvim, and nvim-dap to orchestrate language support.

- Mason installs language servers, formatters, linters, and debuggers. Open with `<leader>omm` or run `:Mason`.
- `lua/plugins/nvim-lspconfig.lua` defines server settings and on-attach behavior.
- Formatting flows through `lua/plugins/conform.lua` and linting through `lua/plugins/nvim-lint.lua`.
- Debugging is configured in `lua/plugins/nvim-dap.lua`, including Go presets under `lua/plugins/roslyn.lua` when needed.

To add bespoke language support:

1. Ensure the tool is available in Mason or install it manually.
2. Extend the relevant plugin config file with your server/adapter.
3. Add keymaps or commands as needed in `lua/config/keymaps.lua`.

## 7. Themes & Visual Flair

meowvim now supports **6 colorschemes** with **30+ variants**:

### Available Themes

1. **Catppuccin** - mocha, latte, frappe, macchiato
2. **TokyoNight** - storm, night, moon, day
3. **Rose Pine** - main, moon, dawn
4. **Gruvbox** - hard, medium, soft (dark/light)
5. **Nord** - single variant
6. **Kanagawa** - wave, dragon, lotus

### Transparent Backgrounds

All themes support transparency (0-100%):

```lua
config.ui({ transparency = 25 }) -- 25% transparent
```

### Interactive Theme Switcher

Use `:ColorschemeSelect` or `<leader>uc` to:
- Browse all available themes and variants
- Live preview themes (cancel restores original)
- Apply and save your selection

### Statusline & UI

- Statusline comes from `lualine.lua` (configured for all themes)
- `noice.lua` enhances message UX, notifications, and command-line popups
- Image preview support via Snacks (configurable)

## 8. Sessions, Persistence & Toggles

### Enhanced Session Management

Session management uses `persistence.nvim` with new features:

- **Auto-save on directory change** - Never lose your session state
- **Per-branch sessions** - Different session for each git branch (configurable)
- **Session picker** - Browse and restore previous sessions
- **Pre-save hooks** - Automatically closes plugin windows before saving

Keymaps:
- `<leader>qs` - Restore current directory session
- `<leader>qS` - Restore session (picker)
- `<leader>ql` - Restore last session
- `<leader>qd` - Don't save current session

### UI Toggles

`utils/toggles.lua` exposes helpers under `<leader>o*`:

- `<leader>og` - Toggle indent guides
- `<leader>on` - Cycle number modes (relative/absolute/none)
- `<leader>ow` - Toggle line wrap
- `<leader>os` - Toggle spell checking
- `<leader>oa` - Toggle auto-save
- `<leader>oF` - Toggle format-on-save
- `<leader>od` - Toggle dim background
- `<leader>uc` - Interactive colorscheme switcher

### Developer Tools

New tools for productivity:

- **Keymap checker**: `:KeymapConflicts`, `:KeymapList [mode]`
- **Profiler**: `:ProfileStart`, `:ProfileStop`, `:MeowvimProfile` (`<leader>oP`, `<leader>oL`)
- **Startup tracker**: `:StartupTrends` - Analyze startup time trends
- **Measure render**: `:MeasureRender` - Benchmark buffer rendering

## 9. Local Overrides & Secrets

Need machine-specific tweaks? Create files under `after/` and add them to `.gitignore`:

```
after/plugin/local.lua       -- local keymaps or commands
after/plugin/copilot.lua     -- private Copilot toggles
after/plugin/autocmds.lua    -- editors hooks or experiments
```

This keeps upstream updates clean while allowing personal flair.

## 10. Automation & External Tools

### Update Script

Use `./bin/update-meowvim.sh` for safe updates:

- Creates timestamped backups
- Updates plugins via lazy.nvim
- Runs health checks
- Auto-rollback on failure
- Manual rollback: `./bin/update-meowvim.sh --rollback backup_TIMESTAMP`
- Cleans old backups (keeps last 10)

### Test Suite

Run `./bin/test-config.sh` to verify:

- Neovim startup
- Config loading
- Health checks
- User config validation
- Plugin integrity
- LSP, Treesitter, keymaps
- Lua syntax

### Raycast Integration

- Scripts in `bin/` integrate with Raycast for quick launching
- `scripts/` host helpers for dashboard art

## 11. Environment Variables

Set these in your shell profile if needed:

- `MEOWVIM_RAYCAST_BIN` — point Raycast scripts to a custom path
- Copilot and other tools detect their respective environment variables automatically

Configuration system supports environment variable expansion in config values.

---

Ready to put your configuration to work? Jump into the [Daily Workflows & Recipes](./03-WORKFLOWS.md) guide next.
