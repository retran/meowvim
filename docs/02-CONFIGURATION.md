# Configuration & Personalization

meowvim is designed to be friendly out of the box while staying easy to tailor. This guide walks through the building blocks you can tweak to make the editor feel like home.

## 1. Directory Layout

```
~/.config/nvim/
├── init.lua                # Main entry point
├── after/                  # Optional local overrides (autoloaded)
├── assets/                 # Icons, screenshots, dashboard art
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

## 2. Editor Options

`lua/config/options.lua` contains the baseline Neovim settings. A few highlights:

- **UI:** relative numbers, cursorline, statusline, background theme, smooth folds
- **Text editing:** spaces over tabs, smart indentation, 2-space defaults
- **Search:** smart case, incremental highlight, “ignorecase” enabled
- **Spell:** automatic dictionaries for Markdown, Neorg, and git messages
- **Performance:** tuned update intervals, foldexpr configuration, and session defaults

Modify this file directly or duplicate the settings you want to change inside an `after/plugin/options.lua` file for local tweaks.

## 3. Keymaps

All leader mappings and helper combos live in `lua/config/keymaps.lua`. Each entry is a table describing the key, command, and description, making it compatible with which-key and Snacks pickers.

```lua
{ "<leader>ff", require("snacks").picker.files, desc = "Find files" }
```

- Use `<leader>ohk` in editor to discover everything interactively.
- Place personal keymaps in `after/plugin/keymaps.lua` to keep them separate from upstream updates.
- Non-leader commands (like `jj` to escape) can be added using standard `vim.keymap.set` calls.

Refer to the [Keymaps Reference](./KEYMAPS.md) for the canonical list.

## 4. Plugins & Lazy Specs

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

## 5. Language Tooling

meowvim uses Mason, nvim-lspconfig, nvim-lint, Conform.nvim, and nvim-dap to orchestrate language support.

- Mason installs language servers, formatters, linters, and debuggers. Open with `<leader>omm` or run `:Mason`.
- `lua/plugins/nvim-lspconfig.lua` defines server settings and on-attach behavior.
- Formatting flows through `lua/plugins/conform.lua` and linting through `lua/plugins/nvim-lint.lua`.
- Debugging is configured in `lua/plugins/nvim-dap.lua`, including Go presets under `lua/plugins/roslyn.lua` when needed.

To add bespoke language support:

1. Ensure the tool is available in Mason or install it manually.
2. Extend the relevant plugin config file with your server/adapter.
3. Add keymaps or commands as needed in `lua/config/keymaps.lua`.

## 6. Themes & Visual Flair

- Default theme uses the Catppuccin-inspired palette defined in `lua/plugins/themes.lua`.
- Statusline comes from `lualine.lua`.
- `noice.lua` enhances message UX, notifications, and command-line popups.
- Neovide-specific options (cursor animations, transparency, font) are set in `lua/config/neovide.lua`.

Feel free to swap colorschemes, adjust fonts, or disable Neovide features if you prefer a simpler aesthetic.

## 7. Sessions, Persistence & Toggles

- Session management uses `persistence.nvim` with keymaps under `<leader>oS*` (restore current session, restore last, stop recording).
- `utils/toggles.lua` exposes helpers that back the `<leader>o*` options: indent guides (`<leader>og`), number modes (`<leader>on`), wrap (`<leader>ow`), spell (`<leader>os`), auto-save (`<leader>oa`), format-on-save (`<leader>oF`), dim background (`<leader>od`), and more. In Neovide you also get fullscreen control via `<leader>of` alongside font scaling (`<leader>o+` / `<leader>o-`).
- Snacks pickers power fuzzy finding, command palettes, registers, and more.

Experiment with the options group to keep distractions under control — most common toggles live under `<leader>o`.

## 8. Local Overrides & Secrets

Need machine-specific tweaks? Create files under `after/` and add them to `.gitignore`:

```
after/plugin/local.lua       -- local keymaps or commands
after/plugin/copilot.lua     -- private Copilot toggles
after/plugin/autocmds.lua    -- editors hooks or experiments
```

This keeps upstream updates clean while allowing personal flair.

## 9. Raycast, Terminal & External Tools

- Scripts in `bin/` integrate meowvim with Raycast for quick launching via Spotlight-like workflows.
- `scripts/` host helpers used for dashboard art and future automation.
- If you use tmux, consider mapping `<leader>tt` to focus existing panes or launch tasks via Overseer.

## 10. Environment Variables

Set these in your shell profile if needed:

- `MEOWVIM_NEOVIDE_FONT` — override GUI font via `neovide.lua`
- `MEOWVIM_RAYCAST_BIN` — point Raycast scripts to a custom path
- Copilot and other tools detect their respective environment variables automatically.

---

Ready to put your configuration to work? Jump into the [Daily Workflows & Recipes](./03-WORKFLOWS.md) guide next.
