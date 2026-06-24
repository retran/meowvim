# Configuration

meowvim loads configuration from `~/.config/meowvim/config.lua`. Edit this file to change themes, toggle features, and adjust editor behavior. Changes reload automatically within 500ms.

## Quick Start

Edit your config:
```
:MeowvimConfig
```

Your config is a plain Lua table:

```lua
return {
  core = {
    theme = "catppuccin",
    variant = "mocha",
    enable_copilot = false,
  },

  editor = {
    tabstop = 2,
    indent = 2,
    format_on_save = true,
  },

  ui = {
    transparency = 0, -- 0-100
    cmdheight = 1,
  },
}
```

Changes save automatically and apply within 500ms.

## Configuration Sections

### core

Theme and global settings:

```lua
core = {
  theme = "catppuccin",           -- colorscheme name
  variant = "mocha",               -- theme variant
  enable_copilot = false,          -- GitHub Copilot toggle
  leader_key = " ",                -- leader key (space)
  update_check = true,             -- check for updates
  day_night_mode = "auto",         -- "manual" | "auto" | "sync"
  day_theme = "catppuccin",        -- theme for daytime
  day_variant = "latte",           -- variant for daytime
  night_theme = "catppuccin",      -- theme for nighttime
  night_variant = "mocha",         -- variant for nighttime
}
```

### editor

Text editing behavior:

```lua
editor = {
  tabstop = 2,                     -- tab width (1-8)
  indent = 2,                      -- indent width (1-8)
  expand_tabs = true,              -- use spaces instead of tabs
  line_numbers = true,             -- show line numbers
  relative_numbers = true,         -- show relative line numbers
  wrap = false,                    -- wrap long lines
  auto_save = false,               -- save on focus loss
  format_on_save = true,           -- format when saving
}
```

### ui

Interface appearance:

```lua
ui = {
  transparency = 0,                -- window transparency (0-100)
  winbar = true,                   -- show winbar
  cmdheight = 1,                   -- command line height (0-3)
  pumheight = 10,                  -- popup menu height (5-20)
  icons = true,                    -- show icons
}
```

### lsp

Language server settings:

```lua
lsp = {
  auto_install = true,             -- install servers automatically
  diagnostics = {
    virtual_text = true,           -- show inline diagnostics
    signs = true,                  -- show gutter signs
    underline = true,              -- underline problems
    update_in_insert = false,      -- update while typing
  },
  inlay_hints = true,              -- show type hints inline
}
```

### formatting

Code formatting:

```lua
formatting = {
  timeout_ms = 3000,               -- format timeout (min: 500)
  formatters = {
    lua = { "stylua" },
    go = { "gofmt", "goimports" },
    typescript = { "prettier" },
    python = { "black", "isort" },
    -- add more languages
  },
}
```

### linting

Code linting:

```lua
linting = {
  auto_lint = true,                -- lint automatically
  linters = {
    lua = { "luacheck" },
    go = { "golangci-lint" },
    typescript = { "eslint" },
    python = { "ruff" },
    -- add more languages
  },
}
```

### git

Git integration:

```lua
git = {
  enable_signs = true,             -- show git changes in gutter
  blame_line = false,              -- show blame inline
  show_deleted = true,             -- show deleted lines
  lazygit_theme_sync = true,       -- sync theme with lazygit
}
```

### sessions

Session management:

```lua
sessions = {
  auto_save = true,                -- save session on exit
  auto_restore = true,             -- restore session on start
  per_branch = false,              -- separate session per git branch
}
```

### snacks

Snacks plugin features:

```lua
snacks = {
  image_preview = true,            -- preview images
  scope_highlighting = true,       -- highlight scope
  custom_styles = true,            -- custom UI styles
  dashboard = {
    show_recent = 10,              -- recent files count
    show_projects = 8,             -- project count
  },
}
```

### toggles

Toggle states (persisted):

```lua
toggles = {
  autoformat = true,               -- format on save
  autosave = false,                -- auto-save files
  copilot = false,                 -- Copilot suggestions
  diagnostics = true,              -- LSP diagnostics
  inlay_hints = false,             -- type hints
  lint = true,                     -- linting
  mini_indentscope = true,         -- indent scope highlighting
  snacks_dim = false,              -- dim inactive windows
  cursorline = false,              -- highlight current line
  hlsearch = true,                 -- highlight search
  list = false,                    -- show whitespace
  number_mode = "relative",        -- "off" | "number" | "relative"
  signcolumn = "yes",              -- "yes" | "no" | "auto"
  spell = false,                   -- spell checking
  wrap = false,                    -- line wrapping
}
```

### performance

Performance settings:

```lua
performance = {
  buffer_auto_close = true,        -- close old buffers
  buffer_threshold = 10,           -- max buffers before closing (min: 1)
  startup_dashboard = true,        -- show dashboard on startup
  lazy_load_plugins = true,        -- lazy-load plugins
}
```

### plugins

Custom plugin settings (any key-value pairs):

```lua
plugins = {
  -- your custom plugin config
}
```

### custom

Your own settings (any key-value pairs):

```lua
custom = {
  -- your custom settings
}
```

## Commands

| Command | Action |
|---------|--------|
| `:MeowvimConfig` | Edit config file |
| `:MeowvimConfigReload` | Reload config now |
| `:MeowvimConfigValidate` | Check for errors |
| `:MeowvimConfigShow` | Show current config |
| `:MeowvimProjects` | Edit projects file |
| `:MeowvimProject <name>` | Switch to project |
| `:MeowvimProjectCurrent` | Show current project |

## Projects

Override settings per project in `~/.config/meowvim/projects.lua`:

```lua
return {
  work = {
    path = "~/work",
    theme = "tokyonight",
    variant = "night",
    on_open = "Neogit",        -- optional command to run
    inherit = true,            -- inherit base config (default: true)
  },
  
  personal = {
    path = "~/personal",
    theme = "rose-pine",
    variant = "moon",
  },
}
```

meowvim detects your project automatically based on the current directory and applies its settings.

## Reading Config in Lua

Access config values from plugins:

```lua
local config = require("meowvim.config")
local theme = config.get("core.theme", "catppuccin")
local transparency = config.get("ui.transparency", 0)
```

Set runtime values (not persisted):

```lua
config.set("ui.transparency", 50)
```

## Directory Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── bin/                  # Helper scripts (update, test)
├── docs/                 # Documentation
├── lua/
│   ├── config/           # Core Neovim settings
│   │   ├── keymaps.lua   # Keybindings
│   │   └── options.lua   # Vim options
│   ├── meowvim/          # Configuration system
│   │   └── config/       # Config loader, schema, cache, watcher
│   ├── plugins/          # Plugin specs (one per file)
│   └── utils/            # Helpers (hooks, patches, toggles, session)
└── spell/                # Dictionaries
```

Customize in `lua/config/` and `lua/plugins/`.

## Editor Options

`lua/config/options.lua` sets base Neovim options:

- **UI**: Relative numbers, cursorline, folds
- **Editing**: 2-space indent, smart tabs
- **Search**: Smart case, incremental
- **Spell**: Auto-enable for Markdown, git commits
- **Performance**: Optimized update times

Override in `after/plugin/options.lua` for local tweaks.

## Keymaps

Keybindings live in `lua/config/keymaps.lua`:

```lua
{ "<leader>ff", require("snacks").picker.files, desc = "Find files" }
```

- Press `<leader>hk` to search keymaps interactively
- Add local keymaps in `after/plugin/keymaps.lua`
- See [Keymaps Reference](./KEYMAPS.md) for the full list

Check for conflicts:
```
:KeymapConflicts
:KeymapList [mode]
```

## Plugins

Each file in `lua/plugins/` returns a plugin spec:

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
- Use `event`, `cmd`, `ft` for lazy loading
- Follow patterns from existing plugins
- Add personal plugins in your fork

## Language Tools

Language servers, formatters, linters, and debuggers are managed by **mise** (project-local tool management):

- LSP config: `lua/plugins/nvim-lspconfig.lua`
- Formatters: `lua/plugins/conform.lua`
- Linters: `lua/plugins/nvim-lint.lua`
- Debuggers: `lua/plugins/nvim-dap.lua`

Add language support:
1. Install tools via mise (e.g. `mise install`) or manually
2. Update the plugin config file
3. Add keymaps in `lua/config/keymaps.lua`

## Themes

17 colorschemes with 70+ variants:

1. **Catppuccin**: mocha, latte, frappe, macchiato
2. **TokyoNight**: storm, night, moon, day
3. **Rose Pine**: main, moon, dawn
4. **Gruvbox**: hard, medium, soft
5. **Nord**: single variant
6. **Kanagawa**: wave, dragon, lotus
7. **Everforest**: dark_hard, dark_medium, dark_soft, light_hard, light_medium, light_soft
8. **Nightfox**: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
9. **Zenbones**: zenbones, zenwritten, neobones, tokyobones, seoulbones, forestbones, nordbones, kanagawabones, rosebones
10. **Solarized Osaka**: storm, night, moon, day
11. **Ayu**: dark, light, mirage
12. **Dracula**: single variant
13. **Monokai Pro**: pro, octagon, machine, ristretto, spectrum, classic
14. **One Dark**: onedark, onelight, onedark_vivid, onedark_dark
15. **Material**: darker, lighter, oceanic, palenight, deep ocean
16. **Melange**: single variant
17. **GitHub**: github_dark, github_dark_dimmed, github_dark_high_contrast, github_light, github_light_high_contrast, and more

### Transparency

```lua
ui = {
  transparency = 25,  -- 0-100
}
```

### Theme Switcher

Live preview themes:
```
:ColorschemeSelect
<leader>ok
```

## Sessions

Session management via `persistence.nvim`:

- Auto-save on directory change
- Per-branch sessions (optional)
- Session picker

Sessions save and restore automatically. No manual keymaps required.

## Toggles

Toggle features with `<leader>o*`:

- `<leader>og` - Indent guides
- `<leader>on` - Number modes
- `<leader>ow` - Line wrap
- `<leader>os` - Spell check
- `<leader>oa` - Auto-save
- `<leader>oF` - Format on save
- `<leader>od` - Dim inactive
- `<leader>ok` - Theme switcher

## Developer Tools

- **Conflicts**: `:KeymapConflicts`, `:KeymapList`
- **Profiler**: `:ProfileStart`, `:ProfileStop`, `:MeowvimProfile`
- **Startup**: `:StartupTrends`
- **Render**: `:MeasureRender`

## Automation

### Updates

Safe updates with backup:

```bash
./bin/update-meowvim.sh
```

Features:
- Timestamped backups
- Plugin updates
- Health checks
- Auto-rollback on failure
- Manual rollback: `./bin/update-meowvim.sh --rollback backup_TIMESTAMP`

Or update manually:
```
:Lazy sync
:checkhealth meowvim
```

### Tests

Verify config:

```bash
./bin/test-config.sh
```

Checks:
- Startup
- Config loading
- Health checks
- Plugin integrity
- LSP, Treesitter
- Syntax



## Environment Variables

- `XDG_CONFIG_HOME` - Config directory (default: `~/.config`)

Config values support environment expansion:

```lua
core = {
  custom_path = "$HOME/projects",  -- expands to /Users/you/projects
}
```

---

Next: [Daily Workflows](./03-WORKFLOWS.md)
