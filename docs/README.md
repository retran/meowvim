# meowvim documentation

Five guides, in the order you are likely to need them. Each one stands on its
own; none of them assume you read the others first.

## Guides

- **[Installation and upgrades](01-INSTALLATION.md)** covers a fresh install,
  the optional tools and what each one adds, upgrades with a restore point, and
  removal.

- **[Configuration reference](02-CONFIGURATION.md)** lists every option in
  `~/.config/meowvim/config.lua` with its type, default, and range, plus the
  commands that read and write that file and the per-project overrides.

- **[Daily workflows](03-WORKFLOWS.md)** shows the sequences you repeat:
  finding a file, resolving a conflict, running one test, reviewing a pull
  request, switching a theme.

- **[Troubleshooting](04-TROUBLESHOOTING.md)** starts from the symptom. Each
  entry names the cause and the fix, and says which ones you can ignore.

- **[Keymap reference](KEYMAPS.md)** groups every mapping the way which-key
  groups them. The [one-page card](KEYMAPS_QUICK_REFERENCE.md) holds the
  subset you use daily.

## Finding a mapping without leaving Neovim

Press `<leader>` and wait: which-key lists the groups, and each keystroke
narrows the list. `<leader>hk` searches every mapping by name, which is faster
when you know what the command is called but not where it sits.

## Where the code lives

`lua/config/` holds the options and the keymap table. `lua/meowvim/` holds the
configuration layer, the theme system, and the health check. `lua/plugins/`
holds one file per plugin. `lua/utils/` holds the session helpers, the toggle
registry, and the workarounds for upstream bugs.

## Contributing

Open an issue or send a pull request. Documentation changes follow the same
review as code changes.

This documentation is covered by the project's [MIT License](../LICENSE).
