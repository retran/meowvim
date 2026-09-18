# Installation and upgrades

This guide installs meowvim, tells you which optional tools change what, and
shows how to upgrade with a way back. It ends with removal, so you can undo
everything this page did.

## What you need

meowvim requires Neovim 0.12 or later, Git, and a terminal that supports true
color. It checks for everything else at runtime and does without what it cannot
find, so a minimal install works and grows as you add tools.

Install a Nerd Font and select it in your terminal, otherwise icons render as
boxes. JetBrains Mono Nerd Font is the one the code screenshots assume.

## Install

Move any existing configuration aside, clone this repository in its place, and
start Neovim:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/retran/meowvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on the first run and installs the plugins, which
takes a couple of minutes on a cold cache. Treesitter then compiles 27 parsers
in the background, so the first files you open may highlight a moment late.

Check the result with `:checkhealth meowvim`. The report has four kinds of
entry: Neovim's version, the configuration and its projects file, the external
tools, and the plugin and parser counts. A warning about a missing optional
tool is informative, and the next section says what each one buys.

## Optional tools

Everything here is optional. The left column names what stops working without
it.

| Without it you lose | Tool | Install |
| --- | --- | --- |
| Project-wide grep in the picker | ripgrep | `brew install ripgrep` or `apt install ripgrep` |
| Fast file listing in the picker | fd | `brew install fd` or `apt install fd-find` |
| `<leader>gg` and `<leader>gf` | lazygit | `brew install lazygit` or `apt install lazygit` |
| `<leader>cs` code screenshots | silicon | `cargo install silicon` |
| GitHub review under `<leader>gh` | GitHub CLI | `brew install gh`, then `gh auth login` |
| Copilot suggestions | copilot-language-server | see the copilot.lua README |

Language servers, formatters, and linters are separate. meowvim configures 17
servers and starts each one only when its binary is on your PATH, so install
the ones your projects need and nothing happens for the rest. The same applies
to conform's formatters and nvim-lint's linters, which resolve their tools every
time they run. A project-local toolchain, through mise or anything else that
changes PATH, therefore works without touching this configuration.

## Platform notes

On macOS, use Ghostty, Kitty, WezTerm, or iTerm2. meowvim enables true color
only when the terminal advertises it, because forcing it under a multiplexer
that does not support it causes partial redraws.

On Linux, set `XDG_CONFIG_HOME` if you do not use `~/.config`. meowvim reads it
for both its own directory and Neovim's.

On Windows, install Neovim inside WSL and run it from Windows Terminal with a
Nerd Font selected. The native Windows build is not tested.

## Install through meowctl

If you manage your environment with [meowctl](https://github.com/meowshed/meowctl),
meowvim arrives with the [dotmeow](https://github.com/meowshed/dotmeow) module
and not as a component you add by name. dotmeow clones this repository into
`~/.config/nvim`, fast-forwards it on `meowctl upgrade`, and exports `EDITOR`
and `VISUAL` as `nvim`.

Bootstrap a machine from an existing dotfiles repository:

```bash
meowctl init https://github.com/YOUR_USER/dotfiles
meowctl apply
```

Starting without one, scaffold a config directory, declare the dependency, and
reference the module:

```bash
meowctl init
meowctl dep add dotmeow
```

Then add one line to `~/.config/meowctl/init.star` and apply it:

```python
component("@dotmeow")
```

```bash
meowctl apply
```

dotmeow brings the rest of the terminal environment with it, including the
ghostty, tmux, fish, ripgrep, and lazygit configurations meowvim expects. The
ghostty theme follows the system appearance between Catppuccin Latte and Mocha,
which is the pair meowvim defaults to, so the editor and the terminal switch
together.

If `~/.config/nvim` already exists and is not a Git clone, the component logs a
message and skips, so your files stay where they are. Move the directory aside
and run `meowctl apply` again.

## Your first configuration

meowvim writes `~/.config/meowvim/config.lua` on the first run and reloads it
whenever you save. Start by choosing a theme:

```lua
return {
  core = {
    -- catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa, everforest,
    -- nightfox, zenbones, solarized-osaka, ayu, dracula, monokai-pro, onedark,
    -- material, melange, github
    theme = "catppuccin",
    variant = "mocha",
  },
  ui = { transparency = 0 },
}
```

Save it and the theme changes. `:MeowvimConfig` opens the file, and
`<leader>ok` opens a menu that writes your choice back into it. The
[configuration reference](02-CONFIGURATION.md) lists every option.

## Upgrades

`bin/update-meowvim.sh` copies the current `lazy-lock.json` into a restore
point, runs `:Lazy! sync`, and then runs the health check:

```bash
./bin/update-meowvim.sh
```

The restore point is the lock file, not a copy of the plugin directory, because
lazy.nvim pins every plugin to a commit there. Rolling back puts the file back
and runs `:Lazy! restore`:

```bash
./bin/update-meowvim.sh --rollback              # lists the restore points
./bin/update-meowvim.sh --rollback backup_20260918_143000
```

The script keeps the last 10 restore points. To upgrade by hand, run `:Lazy
sync` and then `:checkhealth meowvim`.

## Checking a change

`bin/test-config.sh` runs what CI runs. It checks nine things:

- Neovim starts
- the configuration layer loads
- your user config validates
- the plugins load
- the LSP setup answers
- the treesitter parsers are installed
- the health check passes
- no two mappings collide
- the documentation names only mappings and commands that exist
- every Lua file parses

```bash
./bin/test-config.sh
```

## Moving from another configuration

Keep your old configuration at `~/.config/nvim.backup` until you are sure. Add
your own plugin specs as new files in `lua/plugins/`, one per plugin, and lazy
picks them up without any further registration. Options belong in
`lua/config/options.lua` and mappings in `lua/config/keymaps.lua`, where
which-key shows them alongside everything else.

## Removal

This deletes the configuration, the plugins, and the state, including your
sessions and the undo history:

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim
```

Your settings in `~/.config/meowvim/` survive that, so delete the directory too
if you want nothing left.

Next: [configuration reference](02-CONFIGURATION.md).
