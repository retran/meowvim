# Configuration reference

Every setting meowvim reads lives in one Lua table at
`~/.config/meowvim/config.lua`. This page lists each option with its type,
default, and range, then covers the commands that read and write that file and
the per-project overrides.

meowvim creates the file on the first run and watches it: save it and the new
values apply, without a restart. Options you leave out keep their defaults, so
the file only needs to hold what you changed.

```lua
return {
  core = { theme = "catppuccin", variant = "mocha" },
  editor = { tabstop = 2, indent = 2 },
  ui = { transparency = 0 },
}
```

`:MeowvimConfigValidate` checks the file against the schema and names any
option whose type or range is wrong. An option the schema does not know is left
alone, so a typo fails quietly; run the validator after an edit you are unsure
about.

## core

Identity of the configuration: which theme, which leader, whether Copilot runs.

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `theme` | string | `"catppuccin"` | One of the 17 names listed under [Themes](#themes) |
| `variant` | string | `"mocha"` | Variant of the active theme |
| `leader_key` | string | `" "` | Read before the plugins load |
| `enable_copilot` | boolean | `false` | Copilot stays disabled until you turn this on |
| `update_check` | boolean | `true` | Lets lazy.nvim check for plugin updates |
| `day_night_mode` | string | `"auto"` | `auto` follows the system appearance, `manual` waits for `<leader>oK` |
| `day_theme` | string | `"catppuccin"` | Applied when the system is in light mode |
| `day_variant` | string | `"latte"` | |
| `night_theme` | string | `"catppuccin"` | Applied when the system is in dark mode |
| `night_variant` | string | `"mocha"` | |
| `last_preset` | string | `"catppuccin"` | Written by `:DayNightPreset`; you do not set it by hand |

In `auto` mode meowvim asks the operating system for its appearance every 30
seconds and whenever the terminal regains focus. The probe runs outside the
editor loop, so it never blocks typing.

## editor

Text handling. These apply before the plugins load, which is why changing
`tabstop` here beats setting it in a plugin.

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `tabstop` | number | `2` | 1 to 8 |
| `indent` | number | `2` | 1 to 8, sets `shiftwidth` |
| `expand_tabs` | boolean | `true` | |
| `line_numbers` | boolean | `true` | |
| `relative_numbers` | boolean | `true` | |
| `wrap` | boolean | `false` | `<leader>ow` toggles it per window |
| `auto_save` | boolean | `false` | Writes 1500 ms after you stop typing |
| `format_on_save` | boolean | `true` | `<leader>of` toggles it for the session |

`auto_save` and `format_on_save` are also the two switches `<leader>oa` and
`<leader>of` flip, and `<leader>op` writes the current state of every toggle
back into this file.

## ui

Appearance of the frame around the text.

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `transparency` | number | `0` | 0 to 100, passed to the theme and to `winblend` |
| `winbar` | boolean | `true` | Shows the file name per window, which matters under `laststatus=3` |
| `cmdheight` | number | `1` | 0 to 3 |
| `pumheight` | number | `10` | 5 to 20 |
| `icons` | boolean | `true` | Set to `false` for ASCII icons in mini.icons and lualine |

## performance

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `buffer_auto_close` | boolean | `true` | hbac closes unedited buffers past the threshold |
| `buffer_threshold` | number | `10` | At least 1 |
| `startup_dashboard` | boolean | `true` | The dashboard is skipped anyway when a session is restored |

## lsp

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `diagnostics.virtual_text` | boolean | `true` | |
| `diagnostics.signs` | boolean | `true` | |
| `diagnostics.underline` | boolean | `true` | |
| `diagnostics.update_in_insert` | boolean | `false` | |

Which servers start is not configured here. meowvim declares 17 and enables
each one whose binary is on your PATH, so installing `gopls` is all it takes
for Go.

## formatting

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `formatters` | table | `{}` | Per-filetype override, replaces the built-in entry |
| `timeout_ms` | number | `3000` | At least 500 |

`formatters` takes conform formatter names, which are not always the binary
name: `ruff_format` runs `ruff`, and `clang_format` runs `clang-format`.

```lua
formatting = {
  formatters = { python = { "black" }, markdown = { "prettier" } },
}
```

Buffers up to 800 lines format during the write. Larger ones format
asynchronously afterwards, and anything past 5000 lines is left alone.

## linting

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `auto_lint` | boolean | `true` | Runs on write and when you leave insert mode |
| `linters` | table | `{}` | Per-filetype override, replaces the built-in entry |

`linters` takes nvim-lint linter names. Those differ from the binaries more
often than conform's do: `golangcilint` runs `golangci-lint` and `clippy` runs
`cargo`. `:LintInfo` prints the linters for the current filetype and marks
which ones resolve.

## git

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `enable_signs` | boolean | `true` | gitsigns in the sign column |
| `blame_line` | boolean | `false` | Inline blame for the current line |
| `show_deleted` | boolean | `true` | Shows removed lines in a hunk preview |
| `lazygit_theme_sync` | boolean | `true` | Generates a lazygit theme from the active colorscheme |

meowvim writes the generated theme to its own file under `stdpath("state")` and
layers it over your lazygit config through `LG_CONFIG_FILE`. It never edits
your config, which matters when that file is a symlink into a dotfiles tree.

## sessions

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `auto_save` | boolean | `true` | Saves when the working directory changes |
| `auto_restore` | boolean | `true` | Restores on start when a session exists for the directory |
| `per_branch` | boolean | `false` | Set to `true` for one session per Git branch |

A session is restored only when you start Neovim with no file arguments and one
exists for the directory. Otherwise the dashboard opens.

## snacks

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `image_preview` | boolean | `true` | Inline images, needs a terminal with a graphics protocol |
| `scope_highlighting` | boolean | `true` | |
| `custom_styles` | boolean | `true` | |
| `dashboard.show_projects` | number | `8` | Projects listed on the dashboard |

## toggles

The runtime switches under `<leader>o`. meowvim reads them at startup and
`<leader>op` writes the current state back, so this section records how you left
the editor.

| Option | Type | Default | Toggle |
| --- | --- | --- | --- |
| `copilot` | boolean | `false` | `<leader>oC` |
| `cursorline` | boolean | `false` | `<leader>oc` |
| `diagnostics` | boolean | `true` | `<leader>ox` |
| `hlsearch` | boolean | `true` | `<leader>oh` |
| `inlay_hints` | boolean | `false` | `<leader>oi` |
| `lint` | boolean | `true` | `<leader>ot` |
| `list` | boolean | `false` | `<leader>ol` |
| `mini_indentscope` | boolean | `true` | `<leader>og` |
| `snacks_dim` | boolean | `false` | `<leader>od` |
| `spell` | boolean | `false` | `<leader>os` |
| `wrap` | boolean | `false` | `<leader>ow` |
| `number_mode` | string | `"relative"` | `<leader>on`, one of `off`, `number`, `relative` |
| `signcolumn` | string | `"yes"` | `<leader>oe`, one of `yes`, `no`, `auto` |

Auto-save and format-on-save are toggles too, and they read `editor.auto_save`
and `editor.format_on_save` rather than duplicating them here.

## plugins and custom

Two free-form tables the schema accepts without checking. `plugins` is there
for your own plugin settings and `custom` for anything else you want to read
back with `config.get()`.

## Themes

17 colorschemes ship with meowvim, and only the active one is loaded at
startup. The rest are installed but idle, so switching costs a load and not a
download.

catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa, everforest,
nightfox, zenbones, solarized-osaka, ayu, dracula, monokai-pro, onedark,
material, melange, github.

`<leader>ok` opens a menu for the day theme, the night theme, the mode, and the
ready-made pairs. `:ColorschemeSelect` picks a single theme and writes it to
your config. `<leader>oK` switches between day and night by hand and puts the
mode into `manual`.

## Commands

| Command | What it does |
| --- | --- |
| `:MeowvimConfig` | Opens `~/.config/meowvim/config.lua` |
| `:MeowvimConfigReload` | Rereads the file now |
| `:MeowvimConfigValidate` | Checks types and ranges against the schema |
| `:MeowvimConfigShow` | Prints the merged configuration |
| `:MeowvimProjects` | Opens `~/.config/meowvim/projects.lua` |
| `:MeowvimProject <name>` | Changes directory to a project and applies its settings |
| `:MeowvimProjectCurrent` | Prints the project matching the current directory |

## Per-project overrides

`~/.config/meowvim/projects.lua` gives a directory its own theme and a command
to run when you open it. meowvim matches the current directory against each
`path` and applies the first project that contains it.

```lua
return {
  work = {
    path = "~/work",
    theme = "tokyonight",
    variant = "night",
    on_open = "Neogit",
  },
  personal = {
    path = "~/personal",
    theme = "rose-pine",
    variant = "moon",
    inherit = false,
  },
}
```

`path` is required and expands `~` and environment variables. `theme` and
`variant` override `core`, `on_open` runs after the session loads, and
`inherit = false` stops the project from overriding the base theme. The project
paths also feed the `<leader>fp` picker.

## Reading the configuration from Lua

Your own plugin specs can read the same table:

```lua
local config = require("meowvim.config")
local theme = config.get("core.theme", "catppuccin")
local transparency = config.get("ui.transparency", 0)
```

`config.get(key, default)` returns the default only when the key is absent, so
an option set to `false` comes back as `false`. `config.set(key, value)` changes
the value for this session, and `config.persist()` writes the whole table back
to disk.

## Layout of the repository

```
~/.config/nvim/
  init.lua              entry point: providers, mise PATH, lazy, hooks
  bin/                  update and test scripts
  doc/                  :help meowvim
  docs/                 these guides
  lua/
    config/             options.lua and keymaps.lua
    meowvim/            config layer, themes, health, profiler
      config/           loader, defaults, schema, cache, watcher
    plugins/            one file per plugin
    utils/              sessions, toggles, upstream workarounds
```

Next: [daily workflows](03-WORKFLOWS.md).
