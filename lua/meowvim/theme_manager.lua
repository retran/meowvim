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

-- Main theme settings menu
function M.show_menu()
  local mode, day_theme, day_variant, night_theme, night_variant, last_preset = get_current_config()
  
  -- Build menu header with current state
  local mode_display = mode:gsub("^%l", string.upper)
  local header = string.format(
    "Current: %s mode | Day: %s (%s) | Night: %s (%s)",
    mode_display,
    day_theme,
    day_variant or "default",
    night_theme,
    night_variant or "default"
  )
  
  local options = {
    { id = "preset", label = "Use preset (quick setup)", desc = "Choose from 9 ready-made theme pairs" },
    { id = "day", label = "Configure day theme", desc = "Select light theme from 60+ options" },
    { id = "night", label = "Configure night theme", desc = "Select dark theme from 60+ options" },
    { id = "mode", label = "Change mode", desc = "Manual / Auto" },
  }
  
  -- Add reset option if a preset was used
  if last_preset then
    table.insert(options, {
      id = "reset",
      label = "Reset to preset default",
      desc = string.format("Restore '%s' preset", last_preset)
    })
  end
  
  local displays = vim.tbl_map(function(opt)
    return opt.label
  end, options)
  
  vim.ui.select(displays, {
    prompt = header,
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
    elseif selected.id == "reset" then
      M.reset_to_preset()
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

-- Reset to last preset
function M.reset_to_preset()
  local _, _, _, _, _, last_preset = get_current_config()
  
  if not last_preset then
    vim.notify("No preset to reset to", vim.log.levels.WARN)
    return
  end
  
  local presets_ok, presets = pcall(require, "meowvim.day_night_presets")
  if not presets_ok then
    vim.notify("Presets not available", vim.log.levels.ERROR)
    return
  end
  
  presets.apply_preset(last_preset)
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
