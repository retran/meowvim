# meowvim

[![Neovim](https://img.shields.io/badge/neovim-%23019733.svg?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/retran/meowvim?style=for-the-badge)](https://github.com/retran/meowvim/stargazers)

A Neovim configuration for Neovim 0.12, built around snacks.nvim, blink.cmp,
and the built-in LSP client. It starts with 17 plugins loaded and installs the
rest on demand.

meowvim keeps your settings in one Lua table at `~/.config/meowvim/config.lua`.
The repository holds the plugin specs; that file holds the choices you make,
and a file watcher reloads it when you save.

## Quick start

You need Neovim 0.12 or later, Git, and a terminal with true color. Everything
else is optional and the configuration checks for it before using it.

Move any existing configuration aside, clone this repository in its place, and
start Neovim:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/retran/meowvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on the first run and installs the plugins. Run
`:checkhealth meowvim` when it finishes: the report lists which external tools
it found and what each missing one would give you.

Press `<leader>` (space) to see the top-level menu, or `<leader>hk` to search
every mapping.

## What you get

**Finding things.** snacks.nvim provides the picker, the file explorer, the
dashboard, scratch buffers, and the terminal. `<leader>ff` finds a file,
`<leader>s/` greps the project, and `<leader>fe` opens the explorer.

**Language support.** The built-in LSP client is configured through
`vim.lsp.config()` for 17 servers, and each one starts only when its binary is
on your PATH. Treesitter installs 27 parsers on top of the 7 that ship with
Neovim. conform formats and nvim-lint lints; both resolve their tools when they
run, so a project-local toolchain works.

**Git.** gitsigns shows the hunks, `<leader>gg` opens LazyGit, `<leader>gD`
browses diffs through the snacks picker, and `<leader>gh` reviews pull requests
through the GitHub CLI without leaving the editor.

**Themes.** 17 colorschemes with 70 variants. meowvim reads the system
appearance and switches between a day theme and a night theme; `<leader>ok`
opens the theme menu.

**Tests and debugging.** neotest runs Go, Python, Jest, and Vitest suites.
nvim-dap debugs Go, Python, C#, and Godot. Both load on first use.

## Configuration

Your settings live in `~/.config/meowvim/config.lua`, which meowvim creates on
the first run. It is a plain Lua table:

```lua
return {
  core = { theme = "catppuccin", variant = "mocha" },
  editor = { tabstop = 2, indent = 2 },
  ui = { transparency = 0 },
}
```

Save the file and meowvim reloads it. `:MeowvimConfig` opens it,
`:MeowvimConfigValidate` checks it against the schema, and `<leader>op` writes
the current toggle states back into it.

Per-project overrides go in `~/.config/meowvim/projects.lua`. The
[configuration reference](docs/02-CONFIGURATION.md) lists every option with its
type, default, and range.

## Documentation

- [Installation and upgrades](docs/01-INSTALLATION.md)
- [Configuration reference](docs/02-CONFIGURATION.md)
- [Daily workflows](docs/03-WORKFLOWS.md)
- [Keymap reference](docs/KEYMAPS.md) and the [one-page card](docs/KEYMAPS_QUICK_REFERENCE.md)
- [Troubleshooting](docs/04-TROUBLESHOOTING.md)

Inside Neovim, `:help meowvim` covers the same ground.

## Staying current

`bin/update-meowvim.sh` saves the current `lazy-lock.json` as a restore point,
updates the plugins, and runs the health check. If the update goes wrong,
`bin/update-meowvim.sh --rollback <restore-point>` puts the old versions back.

You can also run `:Lazy sync` and check `:checkhealth meowvim` yourself.

## Contributing

Open an issue with steps to reproduce, or send a pull request. `stylua` formats
the Lua, `luacheck` lints it, and `bin/test-config.sh` runs the checks that CI
runs. `mise install` fetches all three.

## License

MIT. See [LICENSE](./LICENSE).

Made by Andrew Vasilyev, with feline assistance from Sonya Blade, Mila, and
Marcus Fenix.
