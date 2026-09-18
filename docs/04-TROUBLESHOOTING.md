# Troubleshooting

This page starts from what you see. Each entry names the cause, then the fix.

Run `:checkhealth meowvim` first. It reports Neovim's version, whether your
configuration loads and validates, which external tools it found, the mise tools
declared for the current project, the plugin and parser counts, and the language
servers on your PATH.

A warning about a missing tool is informative. meowvim checks for every external
tool before it uses one, so a missing tool costs you that feature and nothing
else.

## Installing and starting

### `E492: Not an editor command: Lazy`

lazy.nvim did not bootstrap. Check that `~/.config/nvim/init.lua` exists, then
check that `~/.local/share/nvim/lazy/lazy.nvim` was cloned. A proxy or a missing
certificate usually stops that clone.

Delete `~/.local/share/nvim/lazy` and start Neovim again to retry.

### The first run sits on "Installing plugins"

That run clones about 80 repositories, then compiles 27 treesitter parsers.
Watch `:Lazy` for progress.

If one plugin hangs, press `q` to close the window. `:Lazy restore` puts you
back on the pinned commits.

### Icons render as boxes

Install a Nerd Font and select it in your terminal, not in Neovim. To go
without icons, set `ui.icons = false` in `~/.config/meowvim/config.lua`.

### Colors look wrong, or the screen tears under tmux

meowvim enables true color only when the terminal advertises it through
`COLORTERM`, `TERM`, or `TERM_PROGRAM`. Forcing it where it is unsupported
causes partial redraws, which is why the check is there.

Export `COLORTERM=truecolor` in the shell your multiplexer starts.

## Configuration

### Your settings have no effect

Run `:MeowvimConfigValidate`. It reports any option whose type or range is
wrong. It stays silent about an option the schema does not know, so a typo fails
quietly; check the spelling against the
[configuration reference](02-CONFIGURATION.md).

`:MeowvimConfigShow` prints the merged table, which is what meowvim actually
read.

### An edit seems to need a restart

It should not. A watcher reloads `~/.config/meowvim/config.lua` 500 ms after you
save, and defers the reload until you leave insert mode or the command line.
`:MeowvimConfigReload` forces it.

Options that apply before the plugins load, such as `leader_key`, do need a
restart.

### The theme does not change

Check `core.theme` against the 17 names in the reference, and `core.variant`
against that theme's variants.

In `auto` mode the day and night themes win over `core.theme`. Set those two
instead, or switch `core.day_night_mode` to `manual`.

## Language servers

### No server attaches

meowvim starts a server only when its binary is on your PATH.
`:checkhealth meowvim` lists the ones it found, and `:checkhealth vim.lsp` shows
the live clients.

Neovim 0.12 ships its own `:lsp` command, and nvim-lspconfig stops before
defining `:LspInfo`, `:LspLog`, `:LspStart`, `:LspRestart`, and `:LspStop` when
it sees one. Use `:lsp` and `:checkhealth vim.lsp` instead.

### A project-local toolchain is ignored

meowvim resolves servers, formatters, and linters when they run, so changing
into a project with its own tools works. What does not work is a tool that only
exists in a shell meowvim never sees. Start Neovim from that shell, or put the
tool on your PATH globally.

### Formatting does nothing

`:ConformInfo` lists the formatters for the filetype and marks which ones
resolve. A filetype with no formatter falls back to the language server. With
neither, the buffer is left alone.

Check that format-on-save is on with `<leader>of`. Files over 5000 lines are
skipped on purpose.

### Diagnostics are missing

Check the toggle with `<leader>ox`, then check that a server attached. If the
server runs and still reports nothing, the project probably has no configuration
it recognizes, such as a `tsconfig.json` or a `go.mod`.

### Linting does nothing

`:LintInfo` lists the linters for the filetype and marks the ones that resolve.
Names differ from binaries here: `golangcilint` runs `golangci-lint`, and
`clippy` runs `cargo`.

## Syntax and folds

### A file has no highlighting

meowvim starts treesitter for any filetype with an installed parser.
`:checkhealth meowvim` counts them, and `:TSInstall <language>` adds one.

A very large file has its filetype set to `bigfile` on purpose, which turns
highlighting off.

### `:TSInstall` fails

Parsers are compiled locally, so the build needs a C compiler and
`tree-sitter`. Install `gcc` or `clang`, and get `tree-sitter` from mise or your
package manager.

### Folds are wrong, or everything is folded on open

nvim-ufo takes its ranges from the language server, then treesitter, then
indentation. A file whose server has not attached yet folds differently for a
moment. `zR` opens everything.

## Git

### `<leader>gg` does nothing

lazygit is not installed. Run `brew install lazygit` or `apt install lazygit`.

### lazygit looks unthemed

meowvim generates a theme from the active colorscheme into its own file under
`~/.local/state/nvim/meowvim/`, then layers it over yours through
`LG_CONFIG_FILE`. It never edits your lazygit config.

To keep your own colors, set `git.lazygit_theme_sync = false`.

### The diff pickers are empty

They need Git 2.30 or later, and a file inside a work tree.

### `<leader>gh` reports that gh is missing

Install the GitHub CLI, then run `gh auth login` once.

## Copilot

### Suggestions never appear

Copilot stays off unless `core.enable_copilot` is `true`. `<leader>oC` toggles
it for the session. It also needs `copilot-language-server` on your PATH, and
`:Copilot auth` to have run.

### `:Copilot auth` fails

Check that Node.js runs at all. A version manager shim with no version selected
exists on PATH and fails when executed, which looks like a missing binary from
inside Neovim.

Run `:Copilot signout`, then retry.

## Performance

### Startup feels slow

`<leader>oPl` lists the plugins by load time. `<leader>oPt` compares the last
100 starts, which is the one that shows a regression. meowvim loads 17 plugins
at startup and the rest on demand.

### Typing lags in a large file

Turn off inline diagnostics with `lsp.diagnostics.virtual_text = false`, and
raise `updatetime` if the machine is slow. Very large files already have most
features disabled through `snacks.bigfile`.

### Memory grows over a long session

hbac closes unedited buffers past `performance.buffer_threshold`, which defaults
to 10. `<leader>bp` pins a buffer so it survives that. Closing the neotest and
debug panels releases the rest.

## Mappings

`:KeymapConflicts` lists mappings that resolve to more than one action.
`:KeymapList <mode>` prints everything for a mode.

A buffer-local mapping that shadows a global one shows up there too. That is
usually intended.

To change a mapping, edit `lua/config/keymaps.lua`. Every mapping is declared in
one table with its description and icon.

## Reading the logs

`:messages` shows what Neovim printed. `<leader>hN` opens the noice history,
which keeps the messages that scrolled past. `:Lazy log` shows what the plugin
manager did. The file log is at `~/.local/state/nvim/log`.

## Starting over

This clears the plugins and the state, and keeps your configuration:

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim
nvim
```

Your sessions and undo history go with it. `~/.config/meowvim/` is untouched, so
your settings survive. Delete that directory too if you want nothing left.

Before opening an issue, run `bin/test-config.sh`. Include its output, the
output of `nvim --version`, and what you did to reach the problem.
