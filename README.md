# meowvim

[![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/stargazers)

meowvim is a Neovim configuration for Neovim 0.12. It bundles the plugins you
would expect, and it keeps your own settings in a single Lua file that it
validates and reloads as you save. 83 plugins are declared and 17 load at
startup; the rest wait until you use them.

Language servers, formatters, and linters are checked when they run, not when
Neovim starts. A project that brings its own toolchain works without any change
here, and a machine that lacks one does without that feature.

## Features

- One settings file at `~/.config/meowvim/config.lua` with 56 validated
  options. A watcher reloads it 500 ms after you save and waits if you are in
  insert mode.
- 17 colorschemes with 69 variants. meowvim reads the system appearance and
  switches between a day theme and a night theme when it changes, without
  blocking the editor.
- Per-project overrides: a directory can set its own theme and run a command
  when you open it.
- Graceful degradation. Without a language server, document symbols come from
  treesitter, workspace symbols become a project grep, and folds fall through to
  indentation.
- Every mapping in one table with a description and an icon, rendered by
  which-key. `:KeymapConflicts` finds collisions.
- Toggles that survive a restart: `<leader>op` writes the switches under
  `<leader>o` back to your config.
- Startup timing kept across the last 100 runs, so you can see what a change
  cost you.
- Upgrades through `bin/update-meowvim.sh`, which saves a restore point first.

Under the hood: snacks.nvim for the picker, explorer, dashboard, and terminal,
and blink.cmp with Copilot for completion. 17 language servers run through
`vim.lsp.config`, with 30 treesitter parsers, conform, and nvim-lint. Git is
gitsigns, Neogit, and LazyGit, plus pull request review through the GitHub CLI.
Tests run under neotest for Go, Python, Jest, and Vitest; nvim-dap debugs Go,
Python, C#, and Godot.

## Requirements

Neovim 0.12 or later, Git, and a terminal with true color. Install a Nerd Font
and select it in the terminal, or icons render as boxes.

Everything else is optional. ripgrep and fd make the pickers faster, lazygit
backs `<leader>gg`, the GitHub CLI backs the review mappings, and language
servers are per project. `:checkhealth meowvim` reports what is present and what
each missing tool would add.

## Installation

```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/retran/meowvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on the first run and installs the plugins, then
treesitter compiles its parsers in the background. If you manage your
environment with meowctl, meowvim comes with the dotmeow module instead; see the
[installation guide](docs/01-INSTALLATION.md).

## Getting started

Run `:checkhealth meowvim` once the plugins finish installing. Press space and
wait to see the top-level menu, or `<leader>hk` to search every mapping by name.

The mappings worth learning first are `<leader>ff` to find a file, `<leader>s/`
to grep the project, `<leader>gg` for LazyGit, `<leader>cc` for a code action,
and `<leader><space>` to jump anywhere on screen. The
[keymap card](docs/KEYMAPS_QUICK_REFERENCE.md) has the rest of the daily set.

## Configuration

meowvim creates `~/.config/meowvim/config.lua` on the first run. It is a plain
Lua table, and you only list what you changed:

```lua
return {
  core = { theme = "catppuccin", variant = "mocha" },
  editor = { tabstop = 2, indent = 2 },
  ui = { transparency = 0 },
}
```

Save it and the change applies. `:MeowvimConfig` opens the file,
`:MeowvimConfigValidate` checks it against the schema, and `<leader>ok` opens a
theme menu that writes your choice back into it. Per-project overrides go in
`~/.config/meowvim/projects.lua`.

The [configuration reference](docs/02-CONFIGURATION.md) lists every option with
its type, default, and range.

## Documentation

- [Installation and upgrades](docs/01-INSTALLATION.md)
- [Configuration reference](docs/02-CONFIGURATION.md)
- [Daily workflows](docs/03-WORKFLOWS.md)
- [Keymap reference](docs/KEYMAPS.md) and the [one-page card](docs/KEYMAPS_QUICK_REFERENCE.md)
- [Troubleshooting](docs/04-TROUBLESHOOTING.md)

`:help meowvim` covers the same ground without leaving the editor.

## Updating

```bash
./bin/update-meowvim.sh
```

The script saves the current `lazy-lock.json` as a restore point, updates the
plugins, and runs the health check. If an update goes wrong,
`./bin/update-meowvim.sh --rollback` lists the restore points and takes one to
roll back to. Inside Neovim, `:Lazy sync` does the update without the restore
point.

## Contributing

Open an issue with steps to reproduce, or send a pull request. `stylua` formats
the Lua, `luacheck` lints it, and `bin/test-config.sh` runs the same checks CI
runs; `mise install` fetches all three. Keep the cat puns tasteful and the Lua
tidy.

## License

MIT. See [LICENSE](./LICENSE).

Made by Andrew Vasilyev, with feline assistance from Sonya Blade, Mila, and
Marcus Fenix, who supervised every commit from the warm side of the keyboard.
