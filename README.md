# meowvim

[![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/stargazers)

A Neovim 0.12 configuration with a settings layer of its own. It bundles the
plugins you would expect, and it adds a handful of things those plugins do not
do: one validated settings file that reloads as you save it, themes that follow
the system between day and night, per-project overrides, and tooling that is
resolved when it runs so a per-project toolchain works.

83 plugins are declared and 17 load at startup.

## What meowvim adds

These are written here rather than pulled from a plugin. If you are comparing
configurations, this is the part that differs.

**Settings as one validated table.** Your configuration is a plain Lua table at
`~/.config/meowvim/config.lua` with 56 options across 13 sections, each with a
type, a default, and a range. `:MeowvimConfigValidate` checks it. A file watcher
reloads it 500 ms after you save, and defers the reload while you are in insert
mode or on the command line, so a save mid-edit never interrupts you.

**Themes that follow the system.** 17 colorschemes with 69 variants, described
once and installed but idle until you pick one. meowvim asks the operating
system for its appearance and switches between a day theme and a night theme
when it changes, with 16 ready-made pairs to choose from. The probe runs through
`vim.system` on a 30 second timer plus a check when the terminal regains focus,
so it never blocks typing. It reads macOS through `osascript`, Windows through
the registry, and Linux through gsettings, KDE, or the freedesktop portal.

**Per-project settings.** `~/.config/meowvim/projects.lua` gives a directory its
own theme and a command to run when you open it. meowvim matches the working
directory, applies the settings, and feeds the same list to the project picker.

**Tooling resolved when it runs, and features that degrade.** Language servers,
formatters, and linters are declared in full and checked at the moment they are
used, not at startup, so a project that brings its own toolchain through mise
works without touching this configuration. 17 language servers are configured,
16 gated on their binary and gdscript on a connection Godot opens.

When a server is missing or answers only part of the protocol, the commands that
depend on it fall back rather than open an empty window: document symbols come
from treesitter, workspace symbols become a project grep, folds come from
treesitter and then indentation, formatting falls back to the server and then to
nothing, and diagnostics still arrive from nvim-lint. What has no fallback says
which capability is missing.

**A health check that knows about your project.** `:checkhealth meowvim` walks up
from the working directory for a `mise.toml`, lists the tools it declares, and
marks the ones that are not installed with the command that installs them. It
also reports the configuration, the projects and their paths, the external tools,
and the plugin and parser counts.

**One keymap table.** Every mapping is declared in one place with a description
and an icon, and which-key renders it. `:KeymapConflicts` reports mappings that
resolve to more than one action, and `:KeymapList` prints everything for a mode.

**Toggles that persist.** The switches under `<leader>o` are backed by a registry
that keeps Vim's state, the session, and your configuration in step.
`<leader>op` writes all of them to disk, so the next start begins where you left
off.

**Startup you can measure.** meowvim records every start and keeps the last 100.
`<leader>oPt` compares them, which is what tells you whether a change cost you
something; `<leader>oPl` breaks the current start down by plugin.

**Upgrades with a way back.** `bin/update-meowvim.sh` saves the lock file as a
restore point, updates, and runs the health check. Rolling back restores the
pinned versions.

**A lazygit theme generated from yours.** meowvim derives lazygit's colors from
the active colorscheme and layers them over your config through
`LG_CONFIG_FILE`, so the two match without meowvim ever editing a file you own.

## Quick start

You need Neovim 0.12 or later, Git, and a terminal with true color.

```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/retran/meowvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself and installs the plugins; treesitter then compiles
its parsers in the background. Run `:checkhealth meowvim` when it settles.

Press space and wait: which-key lists the groups. `<leader>hk` searches every
mapping by name.

## What it bundles

snacks.nvim provides the picker, explorer, dashboard, scratch buffers, terminal,
and the GitHub pull request review. blink.cmp handles completion, with Copilot
inline suggestions accepted by the same key. Treesitter installs 30 parsers.
conform formats and nvim-lint lints. gitsigns, Neogit, and LazyGit cover Git,
neotest runs Go, Python, Jest, and Vitest, and nvim-dap debugs Go, Python, C#,
and Godot. Everything except the startup set loads on first use.

Two plugins come from the same author as this configuration: `meow.review.nvim`
for inline code review annotations, and `meow.yarn.nvim` for call and type
hierarchy trees.

## Configuration

```lua
return {
  core = { theme = "catppuccin", variant = "mocha" },
  editor = { tabstop = 2, indent = 2 },
  ui = { transparency = 0 },
}
```

Save it and meowvim reloads. `:MeowvimConfig` opens the file and `<leader>ok`
opens the theme menu, which writes your choice back into it. The
[configuration reference](docs/02-CONFIGURATION.md) lists every option.

## Documentation

- [Installation and upgrades](docs/01-INSTALLATION.md)
- [Configuration reference](docs/02-CONFIGURATION.md)
- [Daily workflows](docs/03-WORKFLOWS.md)
- [Keymap reference](docs/KEYMAPS.md) and the [one-page card](docs/KEYMAPS_QUICK_REFERENCE.md)
- [Troubleshooting](docs/04-TROUBLESHOOTING.md)

`:help meowvim` covers the same ground without leaving the editor.

## Contributing

Open an issue with steps to reproduce, or send a pull request. `stylua` formats
the Lua, `luacheck` lints it, and `bin/test-config.sh` runs what CI runs;
`mise install` fetches all three. Keep the cat puns tasteful and the Lua tidy.

## License

MIT. See [LICENSE](./LICENSE).

Made by Andrew Vasilyev, with feline assistance from Sonya Blade, Mila, and
Marcus Fenix, who supervised every commit from the warm side of the keyboard.
