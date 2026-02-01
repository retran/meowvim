-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/defaults.lua
-- @brief: Default configuration values for meowvim.

local M = {}

M.defaults = {
  core = {
    theme = "everforest",
    variant = "dark_medium",
    enable_copilot = false,
    leader_key = " ",
    update_check = true,
    -- Day/night mode settings
    day_night_mode = "manual", -- "manual", "auto", "day", "night"
    -- Everforest - recommended for Amsterdam weather (warm, easy on eyes)
    day_theme = "everforest",
    day_variant = "light_soft",
    night_theme = "everforest",
    night_variant = "dark_medium",
    last_preset = "everforest", -- Track last applied preset for reset
  },

  editor = {
    tabstop = 2,
    indent = 2,
    expand_tabs = true,
    line_numbers = true,
    relative_numbers = true,
    wrap = false,
    auto_save = false,
    format_on_save = true,
  },

  performance = {
    buffer_auto_close = true,
    buffer_threshold = 10,
    startup_dashboard = true,
    lazy_load_plugins = true,
  },

  ui = {
    transparency = 0,
    winbar = true,
    cmdheight = 1,
    pumheight = 10,
    icons = true,
  },

  lsp = {
    auto_install = true,
    diagnostics = {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    },
    inlay_hints = true,
  },

  formatting = {
    formatters = {
      lua = { "stylua" },
      go = { "gofmt", "goimports" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      typescriptreact = { "prettier" },
      javascriptreact = { "prettier" },
      rust = { "rustfmt" },
      python = { "black", "isort" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
    },
    timeout_ms = 3000,
  },

  linting = {
    auto_lint = true,
    linters = {
      lua = { "luacheck" },
      go = { "golangci-lint" },
      typescript = { "eslint" },
      javascript = { "eslint" },
      python = { "ruff" },
    },
  },

  git = {
    enable_signs = true,
    blame_line = false,
    show_deleted = true,
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
      show_recent = 10,
      show_projects = 8,
    },
  },

  toggles = {
    autoformat = true,
    autosave = false,
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
