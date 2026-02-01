-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/schema.lua
-- @brief: Configuration validation schema.

local M = {}

M.schema = {
  core = {
    theme = { type = "string", default = "catppuccin" },
    variant = { type = "string", default = "mocha" },
    enable_copilot = { type = "boolean", default = false },
    leader_key = { type = "string", default = " " },
    update_check = { type = "boolean", default = true },
    -- Day/Night mode settings
    day_night_mode = {
      type = "string",
      default = "manual",
      enum = { "manual", "auto" },
    },
    day_theme = { type = "string", default = "catppuccin" },
    day_variant = { type = "string", default = "latte" },
    night_theme = { type = "string", default = "catppuccin" },
    night_variant = { type = "string", default = "mocha" },
    last_preset = { type = "string", default = nil },
  },

  editor = {
    tabstop = { type = "number", default = 2, min = 1, max = 8 },
    indent = { type = "number", default = 2, min = 1, max = 8 },
    expand_tabs = { type = "boolean", default = true },
    line_numbers = { type = "boolean", default = true },
    relative_numbers = { type = "boolean", default = true },
    wrap = { type = "boolean", default = false },
    auto_save = { type = "boolean", default = false },
    format_on_save = { type = "boolean", default = true },
  },

  performance = {
    buffer_auto_close = { type = "boolean", default = true },
    buffer_threshold = { type = "number", default = 10, min = 1 },
    startup_dashboard = { type = "boolean", default = true },
    lazy_load_plugins = { type = "boolean", default = true },
  },

  ui = {
    transparency = { type = "number", default = 0, min = 0, max = 100 },
    winbar = { type = "boolean", default = true },
    cmdheight = { type = "number", default = 1, min = 0, max = 3 },
    pumheight = { type = "number", default = 10, min = 5, max = 20 },
    icons = { type = "boolean", default = true },
  },

  lsp = {
    auto_install = { type = "boolean", default = true },
    diagnostics = { type = "table" },
    inlay_hints = { type = "boolean", default = true },
  },

  formatting = {
    formatters = { type = "table" },
    timeout_ms = { type = "number", default = 3000, min = 500 },
  },

  linting = {
    auto_lint = { type = "boolean", default = true },
    linters = { type = "table" },
  },

  git = {
    enable_signs = { type = "boolean", default = true },
    blame_line = { type = "boolean", default = false },
    show_deleted = { type = "boolean", default = true },
    lazygit_theme_sync = { type = "boolean", default = true },
  },

  sessions = {
    auto_save = { type = "boolean", default = true },
    auto_restore = { type = "boolean", default = true },
    per_branch = { type = "boolean", default = false },
  },

  snacks = {
    image_preview = { type = "boolean", default = true },
    scope_highlighting = { type = "boolean", default = true },
    custom_styles = { type = "boolean", default = true },
    dashboard = { type = "table" },
  },

  toggles = {
    autoformat = { type = "boolean", default = true },
    autosave = { type = "boolean", default = false },
    copilot = { type = "boolean", default = false },
    diagnostics = { type = "boolean", default = true },
    inlay_hints = { type = "boolean", default = false },
    lint = { type = "boolean", default = true },
    mini_indentscope = { type = "boolean", default = true },
    snacks_dim = { type = "boolean", default = false },
    cursorline = { type = "boolean", default = false },
    hlsearch = { type = "boolean", default = true },
    list = { type = "boolean", default = false },
    number_mode = {
      type = "string",
      default = "relative",
      enum = { "off", "number", "relative" },
    },
    signcolumn = {
      type = "string",
      default = "yes",
      enum = { "yes", "no", "auto" },
    },
    spell = { type = "boolean", default = false },
    wrap = { type = "boolean", default = false },
  },

  plugins = { type = "table" },
  custom = { type = "table" },
}

-- Validate a value against schema definition
function M.validate_value(value, schema_def)
  if schema_def.type == "boolean" then
    return type(value) == "boolean", "expected boolean"
  elseif schema_def.type == "string" then
    if type(value) ~= "string" then
      return false, "expected string"
    end
    if schema_def.enum and not vim.tbl_contains(schema_def.enum, value) then
      return false, "expected one of: " .. table.concat(schema_def.enum, ", ")
    end
    return true
  elseif schema_def.type == "number" then
    if type(value) ~= "number" then
      return false, "expected number"
    end
    if schema_def.min and value < schema_def.min then
      return false, "must be >= " .. schema_def.min
    end
    if schema_def.max and value > schema_def.max then
      return false, "must be <= " .. schema_def.max
    end
    return true
  elseif schema_def.type == "table" then
    return type(value) == "table", "expected table"
  end
  return true
end

-- Validate entire config
function M.validate(config)
  local errors = {}

  for section, section_schema in pairs(M.schema) do
    if config[section] then
      for key, schema_def in pairs(section_schema) do
        if type(schema_def) == "table" and schema_def.type then
          local value = config[section][key]
          if value ~= nil then
            local ok, err = M.validate_value(value, schema_def)
            if not ok then
              table.insert(errors, string.format("%s.%s: %s", section, key, err))
            end
          end
        end
      end
    end
  end

  return #errors == 0, errors
end

return M
