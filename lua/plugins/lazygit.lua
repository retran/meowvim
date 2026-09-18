-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/lazygit.lua
-- @brief: LazyGit integration with automatic theme synchronization.
--
-- The theme is written to a file meowvim owns and layered on top of the user's
-- own config through LG_CONFIG_FILE, which takes a comma separated list. The
-- previous implementation edited the user's `config.yml` in place; that file is
-- commonly a symlink into a dotfiles tree (here: a read-only meowctl module
-- cache), and lazygit has no named themes — `gui.theme` is a mapping of colours,
-- so writing `theme: <name>` into it produced invalid YAML.

return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local config_ok, config = pcall(require, "meowvim.config")
    if config_ok and config.get("git.lazygit_theme_sync", true) == false then
      return
    end

    local theme_file = vim.fs.joinpath(vim.fn.stdpath("state"), "meowvim", "lazygit-theme.yml")

    -- lazygit's own config, so our file only overrides the theme.
    local function base_config()
      local candidates = {}
      if vim.env.XDG_CONFIG_HOME then
        table.insert(candidates, vim.env.XDG_CONFIG_HOME .. "/lazygit/config.yml")
      end
      table.insert(candidates, vim.fn.expand("~/Library/Application Support/lazygit/config.yml"))
      table.insert(candidates, vim.fn.expand("~/.config/lazygit/config.yml"))

      for _, path in ipairs(candidates) do
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
    end

    local function hl_color(attr, ...)
      for _, name in ipairs({ ... }) do
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        if hl and hl[attr] then
          return string.format("#%06x", hl[attr])
        end
      end
    end

    -- Derive the palette from the active colorscheme so every bundled theme is
    -- reflected, rather than maintaining a name-to-palette table.
    local function sync_theme()
      local colors = {
        activeBorderColor = hl_color("fg", "FloatBorder", "Function") or "#89b4fa",
        inactiveBorderColor = hl_color("fg", "Comment", "NonText") or "#6c7086",
        searchingActiveBorderColor = hl_color("fg", "DiagnosticWarn", "Constant") or "#f9e2af",
        optionsTextColor = hl_color("fg", "Function", "Identifier") or "#89b4fa",
        selectedLineBgColor = hl_color("bg", "Visual", "CursorLine") or "#313244",
        cherryPickedCommitBgColor = hl_color("bg", "Visual", "CursorLine") or "#45475a",
        cherryPickedCommitFgColor = hl_color("fg", "Function", "Identifier") or "#cba6f7",
        unstagedChangesColor = hl_color("fg", "DiagnosticError", "Error") or "#f38ba8",
        defaultFgColor = hl_color("fg", "Normal") or "#cdd6f4",
      }

      local lines = { "gui:", "  theme:" }
      -- Stable order so the file does not churn between writes.
      for _, key in ipairs({
        "activeBorderColor",
        "cherryPickedCommitBgColor",
        "cherryPickedCommitFgColor",
        "defaultFgColor",
        "inactiveBorderColor",
        "optionsTextColor",
        "searchingActiveBorderColor",
        "selectedLineBgColor",
        "unstagedChangesColor",
      }) do
        table.insert(lines, string.format("    %s:", key))
        table.insert(lines, string.format('      - "%s"', colors[key]))
      end

      vim.fn.mkdir(vim.fs.dirname(theme_file), "p")
      vim.fn.writefile(lines, theme_file)

      local base = base_config()
      vim.env.LG_CONFIG_FILE = base and (base .. "," .. theme_file) or theme_file
    end

    sync_theme()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("meowvim-lazygit-theme", { clear = true }),
      callback = sync_theme,
    })
  end,
}
