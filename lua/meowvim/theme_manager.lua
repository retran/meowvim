-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/theme_manager.lua
-- @brief: Unified theme management interface

local M = {}

-- Show current configuration
local function get_current_config()
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    return "manual", "catppuccin", "latte", "catppuccin", "mocha", nil
  end

  local mode = config.get("core.day_night_mode", "manual")
  local day_theme = config.get("core.day_theme", "catppuccin")
  local day_variant = config.get("core.day_variant", "latte")
  local night_theme = config.get("core.night_theme", "catppuccin")
  local night_variant = config.get("core.night_variant", "mocha")
  local last_preset = config.get("core.last_preset", nil)

  return mode, day_theme, day_variant, night_theme, night_variant, last_preset
end

-- Check if current theme config matches a preset
local function get_effective_preset()
  local _, day_theme, day_variant, night_theme, night_variant, last_preset = get_current_config()
  if not last_preset then
    return nil
  end

  -- Check if current config still matches the preset
  local presets_ok, presets_module = pcall(require, "meowvim.day_night_presets")
  if not presets_ok then
    return last_preset
  end

  local preset = presets_module.get_preset(last_preset)
  if not preset then
    return nil
  end

  -- Compare current config with preset
  if
    day_theme == preset.day_theme
    and day_variant == preset.day_variant
    and night_theme == preset.night_theme
    and night_variant == preset.night_variant
  then
    return last_preset
  end

  -- Config doesn't match preset anymore - user customized it
  return "manual"
end

-- Main theme settings menu
function M.show_menu()
  local mode, day_theme, day_variant, night_theme, night_variant, _ = get_current_config()
  local effective_preset = get_effective_preset()

  local mode_display = mode:gsub("^%l", string.upper)
  local preset_display = effective_preset or "none"

  local function format_theme(theme, variant)
    if variant and variant ~= "" then
      return string.format("%s (%s)", theme, variant)
    end
    return theme
  end

  local options = {
    {
      id = "preset",
      label = "Use preset",
      value = preset_display,
      desc = "Choose from 9 ready-made theme pairs",
    },
    {
      id = "day",
      label = "Day theme",
      value = format_theme(day_theme, day_variant),
      desc = "Light theme for daytime",
    },
    {
      id = "night",
      label = "Night theme",
      value = format_theme(night_theme, night_variant),
      desc = "Dark theme for nighttime",
    },
    {
      id = "mode",
      label = "Mode",
      value = mode_display,
      desc = "Manual toggle or auto-sync with system",
    },
  }

  local displays = vim.tbl_map(function(opt)
    local max_label_width = 12
    local padding = string.rep(" ", math.max(0, max_label_width - #opt.label))
    return string.format("%s%s: %s", opt.label, padding, opt.value)
  end, options)

  vim.ui.select(displays, {
    prompt = "Theme Settings",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if not choice then
      return
    end

    local selected = options[idx]

    if selected.id == "preset" then
      M.select_preset()
    elseif selected.id == "day" then
      M.configure_day_theme()
    elseif selected.id == "night" then
      M.configure_night_theme()
    elseif selected.id == "mode" then
      M.select_mode()
    end
  end)
end

-- Select and apply preset
function M.select_preset()
  local presets_ok, presets = pcall(require, "meowvim.day_night_presets")
  if not presets_ok then
    vim.notify("Presets not available", vim.log.levels.ERROR)
    return
  end

  presets.select_preset()
end

-- Configure day theme
function M.configure_day_theme()
  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  if not day_night_ok then
    vim.notify("Day/Night module not available", vim.log.levels.ERROR)
    return
  end

  day_night._select_theme_for_slot("day")
end

-- Configure night theme
function M.configure_night_theme()
  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  if not day_night_ok then
    vim.notify("Day/Night module not available", vim.log.levels.ERROR)
    return
  end

  day_night._select_theme_for_slot("night")
end

-- Select mode
function M.select_mode()
  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  if not day_night_ok then
    vim.notify("Day/Night module not available", vim.log.levels.ERROR)
    return
  end

  day_night.select_mode()
end

-- Quick toggle day/night
function M.quick_toggle()
  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  if not day_night_ok then
    vim.notify("Day/Night module not available", vim.log.levels.ERROR)
    return
  end

  day_night.toggle()
end

-- Setup
function M.setup()
  -- Register command
  vim.api.nvim_create_user_command("ThemeSettings", function()
    M.show_menu()
  end, { desc = "Open theme settings menu" })
end

return M
