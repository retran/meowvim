-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/day_night.lua
-- @brief: Day/night mode system with system theme sync

local M = {}

local timer = nil
local is_watching = false

-- Detect system appearance cross-platform
local function get_system_appearance()
  -- macOS
  if vim.fn.has("mac") == 1 then
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not handle then
      return nil
    end

    local result = handle:read("*a")
    handle:close()

    -- If "Dark" is returned, system is in dark mode
    -- If empty/error, system is in light mode
    if result and result:match("Dark") then
      return "night"
    else
      return "day"
    end
  end

  -- Windows
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    -- Check Windows Registry for theme
    local handle = io.popen(
      'reg query "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme 2>nul'
    )
    if not handle then
      return nil
    end

    local result = handle:read("*a")
    handle:close()

    -- AppsUseLightTheme = 0x0 means dark mode
    -- AppsUseLightTheme = 0x1 means light mode
    if result:match("0x0") then
      return "night"
    elseif result:match("0x1") then
      return "day"
    end

    return nil
  end

  -- Linux - try multiple desktop environments
  if vim.fn.has("unix") == 1 then
    -- Try GNOME (gsettings)
    local handle = io.popen("gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()

      if result then
        -- Check if theme name contains "dark" (case-insensitive)
        if result:lower():match("dark") then
          return "night"
        elseif result:lower():match("light") then
          return "day"
        end
      end
    end

    -- Try KDE Plasma (kreadconfig5)
    handle = io.popen("kreadconfig5 --group General --key ColorScheme 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()

      if result then
        if result:lower():match("dark") then
          return "night"
        elseif result:lower():match("light") then
          return "day"
        end
      end
    end

    -- Try checking GTK theme directly from config file
    local gtk_config = vim.fn.expand("~/.config/gtk-3.0/settings.ini")
    if vim.fn.filereadable(gtk_config) == 1 then
      local file = io.open(gtk_config, "r")
      if file then
        local content = file:read("*a")
        file:close()

        local theme = content:match("gtk%-theme%-name%s*=%s*(.-)%s*\n")
        if theme then
          if theme:lower():match("dark") then
            return "night"
          elseif theme:lower():match("light") then
            return "day"
          end
        end
      end
    end

    -- Try freedesktop color-scheme standard (newer method)
    handle = io.popen(
      "dbus-send --session --print-reply=literal --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' 2>/dev/null"
    )
    if handle then
      local result = handle:read("*a")
      handle:close()

      -- 0 = no preference, 1 = prefer dark, 2 = prefer light
      if result:match("uint32 1") then
        return "night"
      elseif result:match("uint32 2") then
        return "day"
      end
    end

    return nil
  end

  return nil
end

-- Get theme pair for current mode
local function get_theme_for_mode(mode)
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    return nil, nil
  end

  if mode == "day" then
    return config.get("core.day_theme", "catppuccin"), config.get("core.day_variant", "latte")
  elseif mode == "night" then
    return config.get("core.night_theme", "catppuccin"), config.get("core.night_variant", "mocha")
  end

  return nil, nil
end

-- Apply theme based on current mode
local function apply_mode_theme(mode)
  local theme, variant = get_theme_for_mode(mode)
  if not theme then
    return false
  end

  -- Use colorscheme switcher to apply theme
  local switcher_ok, switcher = pcall(require, "meowvim.colorscheme_switcher")
  if switcher_ok and switcher.apply_theme then
    switcher.apply_theme(theme, variant)
    return true
  end

  return false
end

-- Get current effective mode (resolves "auto" to day/night)
function M.get_effective_mode()
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    return "night"
  end

  local mode = config.get("core.day_night_mode", "manual")

  if mode == "auto" then
    return get_system_appearance() or "night"
  else
    -- manual mode - return current state
    return nil
  end
end

-- Apply theme based on current day_night_mode setting
function M.apply_current_mode()
  local mode = M.get_effective_mode()
  if mode then
    return apply_mode_theme(mode)
  end
  return false
end

-- Set day/night mode (manual, auto)
function M.set_mode(mode)
  local valid_modes = { manual = true, auto = true }
  if not valid_modes[mode] then
    vim.notify(string.format("Invalid day/night mode: %s. Use: manual, auto", mode), vim.log.levels.ERROR)
    return false
  end

  local config_ok, config = pcall(require, "meowvim.config")
  if config_ok then
    config.set("core.day_night_mode", mode)
  end

  -- Stop watching if we're not in auto mode
  if mode ~= "auto" then
    M.stop_watching()
  end

  -- Apply theme immediately if in auto mode
  if mode == "auto" then
    M.apply_current_mode()
    M.start_watching()
  end

  vim.notify(string.format("Day/night mode set to: %s", mode), vim.log.levels.INFO)

  return true
end

-- Toggle between day and night themes (manual mode)
function M.toggle()
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    vim.notify("Config not available", vim.log.levels.ERROR)
    return
  end

  -- Switch to manual mode immediately
  local current_mode = config.get("core.day_night_mode", "manual")
  if current_mode ~= "manual" then
    config.set("core.day_night_mode", "manual")
    M.stop_watching()
  end

  -- Get current theme to determine if we're on day or night
  local current_theme = config.get("core.theme", "catppuccin")
  local current_variant = config.get("core.variant", "mocha")
  local day_theme = config.get("core.day_theme", "catppuccin")
  local day_variant = config.get("core.day_variant", "latte")
  local night_theme = config.get("core.night_theme", "catppuccin")
  local night_variant = config.get("core.night_variant", "mocha")

  -- Check if currently on day or night theme
  local is_day = (current_theme == day_theme and current_variant == day_variant)
  local is_night = (current_theme == night_theme and current_variant == night_variant)

  if is_day then
    -- Switch to night
    apply_mode_theme("night")
    vim.notify("Switched to night theme (manual mode)", vim.log.levels.INFO)
  elseif is_night then
    -- Switch to day
    apply_mode_theme("day")
    vim.notify("Switched to day theme (manual mode)", vim.log.levels.INFO)
  else
    -- Not on either theme, default to day
    apply_mode_theme("day")
    vim.notify("Switched to day theme (manual mode)", vim.log.levels.INFO)
  end
end

-- Set theme pair for day/night modes
local function set_theme_for_time(time_of_day, theme, variant)
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    return
  end

  local mode = config.get("core.day_night_mode", "manual")

  local current_theme = config.get("core.theme", "catppuccin")
  local current_variant = config.get("core.variant", "mocha")
  local old_theme = config.get("core." .. time_of_day .. "_theme", "catppuccin")
  local old_variant = config.get("core." .. time_of_day .. "_variant", time_of_day == "day" and "latte" or "mocha")

  config.set("core." .. time_of_day .. "_theme", theme)
  if variant then
    config.set("core." .. time_of_day .. "_variant", variant)
  end
  config.persist()

  if mode == "auto" then
    local current_mode = M.get_effective_mode()
    if current_mode == time_of_day then
      apply_mode_theme(time_of_day)
    end
  else
    if current_theme == old_theme and current_variant == old_variant then
      apply_mode_theme(time_of_day)
    end
  end
end

function M.set_day_theme(theme, variant)
  set_theme_for_time("day", theme, variant)
end

function M.set_night_theme(theme, variant)
  set_theme_for_time("night", theme, variant)
end

-- Watch system appearance changes (cross-platform)
function M.start_watching()
  local platform = "unknown"
  if vim.fn.has("mac") == 1 then
    platform = "macOS"
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    platform = "Windows"
  elseif vim.fn.has("unix") == 1 then
    platform = "Linux"
  end

  if platform == "unknown" then
    vim.notify("System theme sync not supported on this platform", vim.log.levels.WARN)
    return false
  end

  if is_watching then
    return true
  end

  local last_appearance = get_system_appearance()

  -- Poll every 2 seconds for system appearance changes
  timer = vim.loop.new_timer()
  if not timer then
    return false
  end

  timer:start(
    2000,
    2000,
    vim.schedule_wrap(function()
      local current_appearance = get_system_appearance()

      if current_appearance and current_appearance ~= last_appearance then
        last_appearance = current_appearance

        -- Check if still in auto mode
        local config_ok, config = pcall(require, "meowvim.config")
        local mode = config_ok and config.get("core.day_night_mode", "manual") or "manual"

        if mode == "auto" then
          apply_mode_theme(current_appearance)
          vim.notify(string.format("System theme changed to %s mode", current_appearance), vim.log.levels.INFO)
        else
          -- Mode changed, stop watching
          M.stop_watching()
        end
      end
    end)
  )

  is_watching = true
  vim.notify(string.format("Started watching system theme (%s)", platform), vim.log.levels.INFO)
  return true
end

function M.stop_watching()
  if timer then
    if not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    timer = nil
  end
  is_watching = false
end

-- Interactive mode selector
function M.select_mode()
  local config_ok, config = pcall(require, "meowvim.config")
  local current_mode = config_ok and config.get("core.day_night_mode", "manual") or "manual"

  local modes = {
    { mode = "manual", desc = "toggle with <leader>oK" },
    { mode = "auto", desc = "sync with OS" },
  }

  local displays = vim.tbl_map(function(item)
    local indicator = item.mode == current_mode and "● " or "  "
    return string.format("%s%s - %s", indicator, item.mode:gsub("^%l", string.upper), item.desc)
  end, modes)

  vim.ui.select(displays, {
    prompt = string.format("Mode (current: %s)", current_mode),
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if choice and idx then
      M.set_mode(modes[idx].mode)
    end
  end)
end

-- Interactive day/night theme pair setup
function M.setup_themes()
  local switcher_ok, _ = pcall(require, "meowvim.colorscheme_switcher")
  if not switcher_ok then
    vim.notify("Colorscheme switcher not available", vim.log.levels.ERROR)
    return
  end

  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    vim.notify("Config not available", vim.log.levels.ERROR)
    return
  end

  -- Get current day/night themes
  local current_day_theme = config.get("core.day_theme", "catppuccin")
  local current_day_variant = config.get("core.day_variant", "latte")
  local current_night_theme = config.get("core.night_theme", "catppuccin")
  local current_night_variant = config.get("core.night_variant", "mocha")

  -- Show menu
  local options = {
    string.format("Day theme: %s (%s)", current_day_theme, current_day_variant or "default"),
    string.format("Night theme: %s (%s)", current_night_theme, current_night_variant or "default"),
    "Set current theme as DAY theme",
    "Set current theme as NIGHT theme",
    "Use preset pair",
  }

  vim.ui.select(options, {
    prompt = "Day/Night theme setup:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if not choice then
      return
    end

    if idx == 1 then
      -- Select day theme
      M._select_theme_for_slot("day")
    elseif idx == 2 then
      -- Select night theme
      M._select_theme_for_slot("night")
    elseif idx == 3 then
      -- Set current as day
      local theme = config.get("core.theme", "catppuccin")
      local variant = config.get("core.variant", "mocha")
      M.set_day_theme(theme, variant)
    elseif idx == 4 then
      -- Set current as night
      local theme = config.get("core.theme", "catppuccin")
      local variant = config.get("core.variant", "mocha")
      M.set_night_theme(theme, variant)
    elseif idx == 5 then
      -- Use preset
      local presets_ok, presets = pcall(require, "meowvim.day_night_presets")
      if presets_ok then
        presets.select_preset()
      else
        vim.notify("Presets not available", vim.log.levels.ERROR)
      end
    end
  end)
end

-- Helper: select theme for day or night slot
function M._select_theme_for_slot(slot)
  local switcher_ok, switcher = pcall(require, "meowvim.colorscheme_switcher")
  if not switcher_ok then
    vim.notify("Colorscheme switcher not available", vim.log.levels.ERROR)
    return
  end

  -- Get all theme options with variants
  local options = switcher.get_all_theme_options()

  local displays = vim.tbl_map(function(opt)
    return opt.display
  end, options)

  vim.ui.select(displays, {
    prompt = string.format("Select %s theme:", slot:upper()),
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if choice and idx then
      local selected = options[idx]

      if slot == "day" then
        M.set_day_theme(selected.theme, selected.variant)
      else
        M.set_night_theme(selected.theme, selected.variant)
      end
    end
  end)
end

-- Setup
function M.setup()
  -- Apply mode on startup
  vim.defer_fn(function()
    local config_ok, config = pcall(require, "meowvim.config")
    local mode = config_ok and config.get("core.day_night_mode", "manual") or "manual"

    if mode == "auto" then
      M.apply_current_mode()
      M.start_watching()
    end
  end, 100)

  -- Cleanup on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("meowvim-day-night-cleanup", { clear = true }),
    callback = function()
      M.stop_watching()
    end,
  })

  -- Re-detect project on directory change
  vim.api.nvim_create_autocmd("DirChanged", {
    group = vim.api.nvim_create_augroup("meowvim-day-night-dirchange", { clear = true }),
    callback = function()
      local config_ok, config = pcall(require, "meowvim.config")
      if config_ok then
        config.detect_current_project()
      end
    end,
  })

  -- Register commands
  vim.api.nvim_create_user_command("DayNightMode", function(opts)
    if opts.args == "" then
      M.select_mode()
    else
      M.set_mode(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return { "manual", "auto" }
    end,
    desc = "Set or select day/night mode",
  })

  vim.api.nvim_create_user_command("DayNightToggle", function()
    M.toggle()
  end, { desc = "Toggle between day and night modes" })

  vim.api.nvim_create_user_command("DayNightSetup", function()
    M.setup_themes()
  end, { desc = "Setup day/night theme pairs interactively" })

  -- Command to set current theme as day or night theme
  vim.api.nvim_create_user_command("DayNightSetTheme", function(opts)
    local mode = opts.args
    if mode ~= "day" and mode ~= "night" then
      vim.notify("Usage: DayNightSetTheme day|night", vim.log.levels.ERROR)
      return
    end

    local config_ok, config = pcall(require, "meowvim.config")
    if not config_ok then
      vim.notify("Failed to load config", vim.log.levels.ERROR)
      return
    end

    -- Get current theme and variant
    local theme = config.get("core.theme", "catppuccin")
    local variant = config.get("core.variant", "mocha")

    if mode == "day" then
      M.set_day_theme(theme, variant)
      vim.notify(string.format("Day theme set to: %s (%s)", theme, variant or "default"), vim.log.levels.INFO)
    else
      M.set_night_theme(theme, variant)
      vim.notify(string.format("Night theme set to: %s (%s)", theme, variant or "default"), vim.log.levels.INFO)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "day", "night" }
    end,
    desc = "Set current theme as day or night theme",
  })
end

return M
