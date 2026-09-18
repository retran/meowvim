# Troubleshooting

This page starts from what you see. Each entry names the cause and the fix, and
says when the symptom is expected and can be ignored.

Run `:checkhealth meowvim` first. It reports Neovim's version, whether the
configuration and projects files load and validate, which external tools it
found, the mise tools declared for the current project, the plugin and parser
counts, and which language servers are on your PATH. Most of what follows is a
line from that report explained.

A warning about a missing tool is informative: meowvim checks for every
external tool before using it, so a missing one costs you that feature and
nothing else.

## Installing and starting

**`E492: Not an editor command: Lazy`.** lazy.nvim did not bootstrap. Check
that `~/.config/nvim/init.lua` exists and that `~/.local/share/nvim/lazy/lazy.nvim`
was cloned; a proxy or a missing certificate usually stops the clone. Remove
`~/.local/share/nvim/lazy` and start Neovim again to retry.

**It sits on "Installing plugins" for minutes.** The first run clones about 80
repositories and then compiles 27 treesitter parsers. Watch `:Lazy` for the
progress. If a single plugin hangs, `q` closes the window and `:Lazy restore`
puts you back on the pinned commits.

**Icons render as boxes.** Install a Nerd Font and select it in the terminal,
not in Neovim. To go without, set `ui.icons = false` in
`~/.config/meowvim/config.lua`.

**Colors look wrong or the screen tears under tmux or zellij.** meowvim enables
true color only when the terminal advertises it through `COLORTERM`, `TERM`, or
`TERM_PROGRAM`, because forcing it where it is unsupported causes partial
redraws. Export `COLORTERM=truecolor` in the shell your multiplexer starts.

## Configuration

**Your settings have no effect.** Run `:MeowvimConfigValidate`. It reports any
option whose type or range is wrong, and it stays silent about an option the
schema does not know, so check the spelling against the
[reference](02-CONFIGURATION.md). `:MeowvimConfigShow` prints the merged table,
which tells you what meowvim actually read.

**An edit needs a restart.** It should not: a file watcher reloads
`~/.config/meowvim/config.lua` 500 ms after you save, and it defers the reload
until you leave insert mode or the command line. `:MeowvimConfigReload` forces
it. Options that only apply before the plugins load, such as `leader_key`, do
need a restart.

**The theme does not change.** Check `core.theme` against the 17 names in the
reference and `core.variant` against that theme's variants. In `auto` mode the
day and night themes win over `core.theme`, so set those two instead, or switch
`core.day_night_mode` to `manual`.

## Language servers

**No server attaches.** meowvim starts a server only when its binary is on your
PATH. `:checkhealth meowvim` lists the ones it found, and `:LspInfo` was removed
in nvim-lspconfig 2, so use `:checkhealth vim.lsp` for the live clients. Install
the server and reopen the file.

**A project-local toolchain is not picked up.** meowvim resolves servers,
formatters, and linters when they run, not at startup, so a directory change
into a project with its own tools works. What does not work is a tool that only
exists in a shell meowvim never sees; start Neovim from that shell, or put the
tool on PATH globally.

**Formatting does nothing.** `:ConformInfo` lists the formatters for the
filetype and marks which resolve. A filetype with no formatter falls back to the
language server, and with neither the buffer is left alone. Check that
format-on-save is on with `<leader>of`, and remember that files over 5000 lines
are skipped on purpose.

**Diagnostics are missing.** Check the toggle with `<leader>ox`, then check that
a server attached. If the server runs but reports nothing, the project probably
has no configuration it recognizes, such as a `tsconfig.json` or a `go.mod`.

**Linting does nothing.** `:LintInfo` lists the linters for the filetype and
marks the ones that resolve. Names differ from binaries here more than
elsewhere: `golangcilint` runs `golangci-lint` and `clippy` runs `cargo`.

## Syntax and folds

**A file has no syntax highlighting.** meowvim starts treesitter for any
filetype with an installed parser. `:checkhealth meowvim` counts the installed
parsers, and `:TSInstall <language>` adds one. A very large file has its
filetype set to `bigfile` on purpose, which turns highlighting off.

**`:TSInstall` fails.** The parser is compiled locally, so it needs a C
compiler and `tree-sitter`. Install `gcc` or `clang`, and `tree-sitter` through
mise or your package manager.

**Folds are wrong or everything is folded on open.** nvim-ufo takes its ranges
from the language server, then treesitter, then indentation, so a file whose
server has not attached yet folds differently for a moment. `zR` opens
everything.

## Git

**`<leader>gg` does nothing.** lazygit is not installed. `brew install lazygit`
or `apt install lazygit`.

**lazygit looks unthemed.** meowvim generates a theme from the active
colorscheme into its own file under `~/.local/state/nvim/meowvim/` and layers it
over yours through `LG_CONFIG_FILE`. It never edits your lazygit config. Set
`git.lazygit_theme_sync = false` to keep your own colors.

**The diff pickers are empty.** They need Git 2.30 or later and a file inside a
work tree.

**`<leader>gh` reports that gh is missing.** Install the GitHub CLI and run `gh
auth login` once.

## Copilot

**Suggestions never appear.** Copilot is off unless `core.enable_copilot` is
`true`, and `<leader>oC` toggles it for the session. It also needs
`copilot-language-server` on your PATH and `:Copilot auth` to have run.

**`:Copilot auth` fails.** Check that Node.js runs at all: a version manager
shim with no version selected exists on PATH and fails when executed, which
looks like a missing binary from inside Neovim. `:Copilot signout` and retry.

## Performance

**Startup feels slow.** `<leader>oPl` lists the plugins by load time and
`<leader>oPt` compares the last 100 starts, which is the one that shows a
regression. meowvim loads 17 plugins at startup and the rest on demand.

**Typing lags in a large file.** Turn off inline diagnostics with
`lsp.diagnostics.virtual_text = false`, and raise `updatetime` if the machine
is slow. Very large files already have most features disabled through
`snacks.bigfile`.

**Memory grows over a long session.** hbac closes unedited buffers past
`performance.buffer_threshold`, which defaults to 10. `<leader>bp` pins a buffer
so it survives that, and closing the neotest and debug panels releases the rest.

## Mappings

`:KeymapConflicts` lists mappings that resolve to more than one action, and
`:KeymapList <mode>` prints everything for a mode. Note that a buffer-local
mapping shadowing a global one shows up here, which is usually intended rather
than a conflict.

To change a mapping, edit `lua/config/keymaps.lua`, where every mapping is
declared in one table with its description and icon.

## Reading the logs

`:messages` shows what Neovim printed, `<leader>hN` opens the noice history with
the messages that scrolled past, and `:Lazy log` shows what the plugin manager
did. The file log is at `~/.local/state/nvim/log`.

## Starting over

This clears the plugins and the state but keeps your configuration:

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim
nvim
```

Your sessions and undo history go with it. `~/.config/meowvim/` is untouched, so
your settings survive.

Before opening an issue, run `bin/test-config.sh` and include its output, the
output of `nvim --version`, and what you did to reach the problem.
