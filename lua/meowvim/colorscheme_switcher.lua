-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/colorscheme_switcher.lua
-- @brief: Interactive colorscheme switcher.
--
-- Theme definitions (plugin, variants, setup) live in `meowvim.themes`; this
-- module only drives the selection UI and persists the choice.

local M = {}

local Themes = require("meowvim.themes")

-- Base themes, no variants (for the main theme picker)
local function get_base_theme_options()
  local options = {}
  for _, name in ipairs(Themes.names()) do
    table.insert(options, { theme = name, display = name })
  end
  return options
end

-- Every theme/variant combination (for day/night setup)
local function get_all_theme_options()
  local options = {}
  for _, name in ipairs(Themes.names()) do
    local variants = Themes.variants(name)
    if #variants == 0 then
      table.insert(options, { theme = name, variant = nil, display = name })
    else
      for _, variant in ipairs(variants) do
        table.insert(options, {
          theme = name,
          variant = variant,
          display = string.format("%s (%s)", name, variant),
        })
      end
    end
  end
  table.sort(options, function(a, b)
    return a.display < b.display
  end)
  return options
end

local function apply_theme(theme, variant)
  local config_ok, config = pcall(require, "meowvim.config")
  if config_ok then
    config.set("core.theme", theme)
    if variant then
      config.set("core.variant", variant)
    end
  end

  return Themes.apply(theme, variant)
end

function M.select()
  local options = get_base_theme_options()
  local config_ok, config = pcall(require, "meowvim.config")

  local displays = vim.tbl_map(function(opt)
    return opt.display
  end, options)

  vim.ui.select(displays, {
    prompt = "Select theme:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if not (choice and idx) then
      return
    end

    local theme = options[idx].theme
    local variant = M.get_smart_variant(theme)

    if not apply_theme(theme, variant) then
      return
    end

    if config_ok then
      config.set("core.theme", theme)
      config.set("core.variant", variant)
      config.persist()
      vim.notify(
        string.format("Theme set to %s (%s) and saved to config.", theme, variant or "default"),
        vim.log.levels.INFO
      )
    else
      vim.notify(string.format("Theme set to %s (not persisted).", theme), vim.log.levels.WARN)
    end
  end)
end

-- Variant names that indicate a light background
local LIGHT_VARIANT_PATTERNS = {
  "latte",
  "day",
  "dawn",
  "lotus",
  "light",
  "dayfox",
  "zenwritten",
  "onelight",
  "lighter",
  "classic",
}

local function is_light_variant(variant)
  if not variant then
    return false
  end
  for _, pattern in ipairs(LIGHT_VARIANT_PATTERNS) do
    if variant:match(pattern) then
      return true
    end
  end
  return false
end

-- Pick a sensible variant for a theme based on the current system appearance
function M.get_smart_variant(theme)
  local variants = Themes.variants(theme)
  if #variants == 0 then
    return nil
  end

  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  local system_mode = day_night_ok and day_night.get_effective_mode() or nil

  if system_mode == "day" then
    for _, variant in ipairs(variants) do
      if is_light_variant(variant) then
        return variant
      end
    end
  end

  for _, variant in ipairs(variants) do
    if not is_light_variant(variant) then
      return variant
    end
  end

  return variants[1]
end

function M.preview_theme(theme, variant)
  apply_theme(theme, variant)
end

function M.apply_theme(theme, variant)
  return apply_theme(theme, variant)
end

function M.get_themes()
  return Themes.themes
end

function M.get_all_theme_options()
  return get_all_theme_options()
end

-- Default dark/light variants for a theme
function M.get_default_variants(theme)
  local variants = Themes.variants(theme)
  if #variants == 0 then
    return nil, nil
  end

  local light_variant, dark_variant
  for _, variant in ipairs(variants) do
    if is_light_variant(variant) then
      light_variant = light_variant or variant
    else
      dark_variant = dark_variant or variant
    end
  end

  return dark_variant or variants[1], light_variant or variants[1]
end

vim.api.nvim_create_user_command("ColorschemeSelect", function()
  M.select()
end, { desc = "Select colorscheme with live preview" })

return M
