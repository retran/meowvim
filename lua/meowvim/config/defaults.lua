-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/defaults.lua
-- @brief: Default configuration values for meowvim.

local M = {}

M.defaults = {
  core = {
    theme = "catppuccin",
    variant = "mocha",
    enable_copilot = false,
    leader_key = " ",
    update_check = true,
    -- Day/night mode settings
    day_night_mode = "auto", -- "manual", "auto"
    -- Catppuccin - popular, modern, huge ecosystem
    day_theme = "catppuccin",
    day_variant = "latte",
    night_theme = "catppuccin",
    night_variant = "mocha",
    last_preset = "catppuccin",
  },

  editor = {
    tabstop = 2,
    indent = 2,
    expand_tabs = true,
    line_numbers = true,
    relative_numbers = true,
    wrap = false,
    -- These two are the live switches behind <leader>oa / <leader>of;
    -- utils/toggles.lua reads them and <leader>op persists them back here.
    auto_save = false,
    format_on_save = true,
  },

  performance = {
    buffer_auto_close = true,
    buffer_threshold = 10,
    startup_dashboard = true,
  },

  ui = {
    transparency = 0,
    winbar = true,
    cmdheight = 1,
    pumheight = 10,
    icons = true,
  },

  lsp = {
    diagnostics = {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    },
  },

  formatting = {
    -- Per-filetype overrides on top of the defaults in
    -- lua/plugins/conform.lua. Values are conform formatter names and replace
    -- the built-in entry for that filetype, e.g. `python = { "black" }`.
    formatters = {},
    timeout_ms = 3000,
  },

  linting = {
    auto_lint = true,
    -- Per-filetype overrides on top of the defaults in
    -- lua/plugins/nvim-lint.lua. Values are nvim-lint linter names (which are
    -- not always the binary name: `golangcilint` runs `golangci-lint`).
    linters = {},
  },

  git = {
    enable_signs = true,
    blame_line = false,
    -- Virtual lines for removed code while you edit; noisy by default.
    -- <leader>oD toggles it.
    show_deleted = false,
    lazygit_theme_sync = true,
  },

  sessions = {
    auto_save = true,
    auto_restore = true,
    per_branch = false,
  },

  snacks = {
    image_preview = true,
    scope_highlighting = true,
    custom_styles = true,
    dashboard = {
      show_projects = 8,
    },
  },

  toggles = {
    copilot = false,
    diagnostics = true,
    inlay_hints = false,
    lint = true,
    mini_indentscope = true,
    snacks_dim = false,
    -- Vim options
    cursorline = false,
    hlsearch = true,
    list = false,
    number_mode = "relative", -- "off", "number", "relative"
    signcolumn = "yes", -- "yes", "no", "auto"
    spell = false,
    wrap = false,
  },

  plugins = {},

  custom = {},
}

return M
