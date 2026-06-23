# meowvim TODO

Research date: 2026-06-18  
Neovim target: 0.12.x (current stable: 0.12.3)

---

## 🔴 Critical — Breaking on Neovim 0.12

### 1. `vim.diagnostic.disable()` removed
**File:** `lua/config/keymaps.lua:1113`  
`vim.diagnostic.disable()` and `vim.diagnostic.is_disabled()` were removed in Neovim 0.12 (deprecated since 0.10).  
**Fix:** Replace with `vim.diagnostic.enable(false)` / `vim.diagnostic.enable(true)`.

### 2. `vim.lsp.handlers` float overrides broken
**File:** `lua/plugins/nvim-lspconfig.lua:61–63`  
```lua
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(...)
```
Neovim 0.12 no longer routes LSP responses through global handler callbacks.  
**Fix:** Remove those two lines. Add `vim.o.winborder = "rounded"` to `lua/config/options.lua` — it applies globally to all floating windows including LSP hover, signature help, and diagnostics.

### 3. `vim.fn.sign_define` for diagnostics removed
**File:** `lua/plugins/nvim-lspconfig.lua:57–59`  
`:sign-define` based diagnostic signs were removed in 0.12.  
**Fix:** Move sign icons into `vim.diagnostic.config()`:
```lua
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN]  = "󰀪",
      [vim.diagnostic.severity.HINT]  = "󰌶",
      [vim.diagnostic.severity.INFO]  = "󰋼",
    },
  },
})
```

### 4. nvim-treesitter archived — restructuring required
**File:** `lua/plugins/nvim-treesitter.lua`, `lua/config/options.lua:79`  
nvim-treesitter was archived on April 3, 2026. The maintainer rewrote it for Neovim 0.12 only; the community kept demanding backward compat; maintainer burned out. The plugin is read-only.

In Neovim 0.12, treesitter highlighting is **built-in** — no plugin needed for supported languages. `foldexpr = "nvim_treesitter#foldexpr()"` will error with the new treesitter.

**Actions required:**
- Remove `lua/plugins/nvim-treesitter.lua` entirely (or gut it).
- Replace `opt.foldexpr = "nvim_treesitter#foldexpr()"` with the built-in: `opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"`.
- `nvim-ts-autotag` (dep): check if it supports native treesitter or needs migration.
- `nvim-treesitter/nvim-treesitter-textobjects`: check if it works without the archived parent.
- `nvim-treesitter/nvim-treesitter-context`: same check.
- For parsers not bundled with Neovim 0.12, use `tree-sitter-cli` + `:TSInstall <lang>` (there is no maintained community replacement yet).

### 5. rustaceanvim — `checkOnSave` config is broken
**File:** `lua/plugins/rustaceanvim.lua:18`  
rustaceanvim v6+ changed `checkOnSave` to a boolean. The current config passes a table:
```lua
checkOnSave = { command = "clippy" }  -- BROKEN in v6+
```
**Fix for v6/v7/v8:**
```lua
["rust-analyzer"] = {
  check = { command = "clippy" },
  checkOnSave = true,
}
```
**Also:** rustaceanvim v9 (current: v9.0.5) requires Neovim 0.12. Pin to `v8.0.5` if supporting 0.11 users, remove the pin for 0.12-only.

### 6. nvim-lspconfig v2 — `require('lspconfig')[server].document_config` usage
**File:** `lua/plugins/nvim-lspconfig.lua:231–232`  
`require('lspconfig').servername.setup({})` is deprecated in lspconfig v2 (current: v2.10.0) and will be removed in v3. The config already uses `vim.lsp.config()` + `vim.lsp.enable()` — good. But it still accesses `lspconfig[server_name].document_config` to read default cmd/filetypes. This internal field is not guaranteed in v2+.  
**Fix:** Remove the lspconfig dependency entirely. Define `cmd` and `filetypes` inline in `server_settings`, or use `vim.lsp.get_configs()` (new 0.12 API) to query registered server defaults.

### 7. Neovim 0.12 default LSP keymaps conflict
Neovim 0.11 added default LSP keymaps (`grn`=rename, `grr`=references, `gri`=implementation, `gra`=code action, `[d`/`]d`=diagnostics). Neovim 0.12 added `grt`=type definition, `grx`=code lens.  
`[d` and `]d` are already mapped in `keymaps.lua:651–652` to `vim.diagnostic.goto_next/prev` — these now duplicate built-in defaults. Review all `gr*` keys to decide whether to keep the built-in defaults or replace them.

---

## 🟠 Confirmed Bugs

### 8. `<leader>cR` keymap conflict
**Files:** `lua/plugins/snacks.lua:79–84`, `lua/config/keymaps.lua:671`  
`snacks.lua` lazy `keys` registers `<leader>cR` as "Rename File". `keymaps.lua` registers it as a which-key group prefix for "Rust Crates". The snacks lazy key wins — `<leader>cRt`, `<leader>cRr`, etc. are unreachable.  
**Fix:** Move Rust Crates group to `<leader>cC` or remove the snacks lazy key and register it explicitly in `keymaps.lua`.

### 9. Flash f/t custom mappings break `;`/`,` repeat
**File:** `lua/plugins/flash.lua:10–51`  
`f`, `F`, `t`, `T` use flash's `search` mode, not `char` mode. Flash's `;`/`,` repeat only works with `char` mode — so after a flash jump with `f`, `;` falls through to native Vim behavior (wrong). `char.enabled = false` confirms char mode is off.  
**Fix:** Use `mode = "char"` for the f/t overrides (with `max_length = 2`) or accept that `;`/`,` repeat is lost and document it.  
**Also:** flash.nvim v2.0.0 (July 2024) disabled search-mode integration by default. If you rely on `/` search triggering flash labels, you need `modes.search.enabled = true` explicitly — it's already set in your config, so this is fine.

### 10. All 17 themes load eagerly at startup
**File:** `lua/plugins/themes.lua`  
All 17 themes have `lazy = false, priority = 1000`. Each loads its plugin module at startup and returns early. Read the active theme before `lazy.setup()` (you already do this in `config.init()`) and mark non-active themes `lazy = true` or `enabled = false`.  
**Fix example:**
```lua
local active_theme = (function()
  local ok, cfg = pcall(require, "meowvim.config")
  return ok and cfg.get("core.theme", "catppuccin") or "catppuccin"
end)()

local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  enabled = active_theme == "catppuccin",
  ...
}
```

### 11. noice.nvim `inc_rename` preset enabled but plugin not installed
**File:** `lua/plugins/noice.lua:48`  
`presets.inc_rename = true` tells noice to route `:IncRename` through a popup, but `smjonas/inc-rename.nvim` is not in the plugin list. The preset is harmless but misleading — either add the plugin (recommended, see §Plugins to Add) or remove the preset.

### 12. Lualine palette cache stale after theme switch
**File:** `lua/plugins/lualine.lua:8–26`  
`cached_palette` is set on first call and never cleared. When day/night toggle switches the catppuccin flavour, the Copilot lualine component keeps stale colors.  
**Fix:** Add a `ColorScheme` autocmd that resets `cached_palette = nil`.

### 13. overseer.nvim uses `toggleterm` strategy without declaring it as a dependency
**File:** `lua/plugins/overseer.lua:36–38`  
`strategy = { "toggleterm", direction = "float" }` requires `akinsho/toggleterm.nvim`. It's not in `dependencies` or the plugin list at all. If toggleterm is absent, overseer errors at task run time.  
**Fix:** Add toggleterm as a plugin + dependency, or change strategy to `"terminal"`.

### 14. nvim-cmp ghost_text patch accesses private API
**File:** `lua/plugins/nvim-cmp.lua:246–256`  
```lua
local cmp_view = require("cmp").core.view
cmp_view.ghost_text_view.show = function(...) ...
```
This reaches into nvim-cmp private internals and silently breaks when cmp reorganizes its internals. The correct approach if staying on nvim-cmp is to use `ghost_text = { hl_group = "Comment" }` and accept that cmp and Copilot both show ghost text (hide one using `hide_during_completion = true` in copilot.lua, which is already set).  
**Better fix:** Migrate to blink.cmp (see §Migrations) — it has native Copilot ghost text coordination.

### 15. `opt.linebreak = true` is a no-op when `wrap = false`
**File:** `lua/config/options.lua:49–50`  
`linebreak` only affects where soft-wrapped lines break. With `wrap = false` it does nothing.  
**Fix:** Remove it, or add a comment that it takes effect when wrap is toggled on via `<leader>ow`.

### 16. nvim-lint indentation error on line 35
**File:** `lua/plugins/nvim-lint.lua:35`  
```lua
for _, linter in ipairs(linters) do
      if vim.fn.executable(linter) == 1 then   -- 6 spaces (wrong)
```
Should be 8 spaces to align with 2-space indent inside the `for` body. Will fail `luacheck`/`stylua`.

---

## 🔵 Migrations

### 17. Migrate from nvim-cmp to blink.cmp
**Files:** `lua/plugins/nvim-cmp.lua`, `lua/plugins/luasnip.lua`  
nvim-cmp is no longer actively developed. LazyVim switched to blink.cmp as its default. blink.cmp v1.x (latest: v1.10.2, April 2026) is production-stable. Use `version = "1.*"` — do **not** upgrade to v2.x yet (requires `blink.lib` separate package, many breaking changes).

For Copilot integration with blink.cmp, use `fang2hou/blink-copilot` (actively maintained). This eliminates the need for the ghost_text private API patch.

### 18. Remove neotest-rust (archived August 2025)
**File:** `lua/plugins/neotest.lua`  
`rouge8/neotest-rust` was archived on August 19, 2025.  
**Alternative:** Use rustaceanvim's built-in `:RustLsp testables` and `:RustLsp runnables` commands. No maintained neotest-rust replacement exists.

### 19. Add missing neotest adapters
**File:** `lua/plugins/neotest.lua`  
You have LSP+formatters for Python, TypeScript, C# but neotest only runs Go tests.  
- **Python:** `nvim-neotest/neotest-python` (pytest, unittest, doctest) — install from main branch
- **JS/TS:** `marilari88/neotest-vitest` or `nvim-neotest/neotest-jest`
- ~~**Rust:** archived~~ — use rustaceanvim testables instead

### 20. Add nvim-dap-python
**File:** `lua/plugins/nvim-dap.lua`  
Python DAP is not configured. Add `mfussenegger/nvim-dap-python` as a dap dependency. It now supports `uv` directly — Python debugging works even without Mason's debugpy.

---

## 🟢 Plugin Additions

### 21. Add `smjonas/inc-rename.nvim`
noice.nvim already has `presets.inc_rename = true` waiting for this plugin. Provides live LSP rename preview. The Neovim 0.11+ built-in `grn` does basic rename without preview — inc-rename gives visual feedback during typing. Still actively maintained.

### 22. Add `stevearc/aerial.nvim`
Persistent sidebar code outline. Better than trouble's symbols mode for large file navigation — supports jumping, preview, and treesitter + LSP hybrid. Complements the existing `<leader>cs` browse symbols shortcut.

### 23. Add `sindrets/diffview.nvim`
Richer diff and file history UI. Complements codediff and neogit. Provides tabbed views for git history per file, merge conflict resolution view, and side-by-side history diff.

### 24. Add `HiPhish/rainbow-delimiters.nvim`
Rainbow bracket/delimiter matching. Catppuccin has native integration for it. Works with Neovim 0.12's built-in treesitter.

---

## 🗒️ Minor / Quality

### 25. `keymaps.lua` top-level `require("snacks")` should use `safe_require`
**File:** `lua/config/keymaps.lua:9`  
`local snacks = require("snacks")` at module top-level: if snacks fails to load, all keymaps silently fail. Use `safe_require` like every other optional plugin reference in the file.

### 26. `conform.lua` — `codespell` runs on all files ≤ 1000 lines
**File:** `lua/plugins/conform.lua:131–138`  
`codespell` is registered under `"_"` (fallback for all filetypes). It'll run on every buffer under 1000 lines including Lua, Go, Rust, etc. Consider scoping it to text-heavy filetypes (`markdown`, `text`, `gitcommit`) to avoid slow saves and false positives in code.

### 27. lualine extension `"nvim-tree"` with snacks explorer
**File:** `lua/plugins/lualine.lua:140`  
`extensions = { "lazy", "nvim-tree", "trouble" }` — you use snacks explorer, not nvim-tree. The `"nvim-tree"` extension entry is a no-op load. Remove it.

### 28. `meowvim/config/init.lua` — redundant private wrapper functions
**File:** `lua/meowvim/config/init.lua:25–35`  
`get_config_dir()`, `get_config_path()`, `get_projects_path()` are module-level private functions that just call the identical `M.*` public methods. Delete the private wrappers and call `M.*` directly inside the module.

### 29. Neovim 0.12 built-in `'autocomplete'` option
Neovim 0.12 adds a native `'autocomplete'` option for insert-mode auto-completion using the built-in LSP completion (`vim.lsp.completion`). It won't conflict with blink.cmp/nvim-cmp (they disable it), but worth being aware of for documentation purposes.

### 30. copilot.lua v3 requires Node.js v22+
**File:** `lua/plugins/copilot.lua`  
copilot.lua v3.0.0 (June 11, 2026) requires Node.js v22+. Add to health checks or mise.toml: `node = "22"`.
