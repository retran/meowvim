-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/day_night.lua
-- @brief: Day/night mode system with system theme sync
--
-- Appearance detection shells out to the OS, which is far too slow to do on the
-- main loop: a single `osascript` call costs ~110ms. Every probe therefore runs
-- through `vim.system()` asynchronously and answers from `cached_appearance`,
-- refreshed on a slow timer and whenever the terminal regains focus.

local M = {}

local timer = nil
local is_watching = false
local cached_appearance = nil

local POLL_INTERVAL_MS = 30000

-- Ordered list of probes for the current platform. The first one that yields a
-- mode wins; the rest are only tried when it fails or is not installed.
local function appearance_probes()
  if vim.fn.has("mac") == 1 then
    return {
      {
        cmd = { "osascript", "-e", 'tell app "System Events" to tell appearance preferences to get dark mode' },
        parse = function(out)
          if out:match("true") then
            return "night"
          elseif out:match("false") then
            return "day"
          end
        end,
      },
      {
        cmd = { "defaults", "read", "-g", "AppleInterfaceStyle" },
        parse = function(out)
          return out:match("Dark") and "night" or nil
        end,
      },
    }
  end

  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return {
      {
        cmd = {
          "reg",
          "query",
          [[HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]],
          "/v",
          "AppsUseLightTheme",
        },
        -- AppsUseLightTheme: 0x0 = dark, 0x1 = light
        parse = function(out)
          if out:match("0x0") then
            return "night"
          elseif out:match("0x1") then
            return "day"
          end
        end,
      },
    }
  end

  if vim.fn.has("unix") == 1 then
    local function by_name(out)
      out = out:lower()
      if out:match("dark") then
        return "night"
      elseif out:match("light") then
        return "day"
      end
    end

    return {
      { cmd = { "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" }, parse = by_name },
      { cmd = { "gsettings", "get", "org.gnome.desktop.interface", "gtk-theme" }, parse = by_name },
      { cmd = { "kreadconfig5", "--group", "General", "--key", "ColorScheme" }, parse = by_name },
      {
        cmd = {
          "dbus-send",
          "--session",
          "--print-reply=literal",
          "--dest=org.freedesktop.portal.Desktop",
          "/org/freedesktop/portal/desktop",
          "org.freedesktop.portal.Settings.Read",
          "string:org.freedesktop.appearance",
          "string:color-scheme",
        },
        -- 0 = no preference, 1 = prefer dark, 2 = prefer light
        parse = function(out)
          if out:match("uint32 1") then
            return "night"
          elseif out:match("uint32 2") then
            return "day"
          end
        end,
      },
    }
  end

  return {}
end

-- Detect the system appearance without blocking; `callback` receives
-- "day" | "night" | nil.
local function detect_appearance(callback)
  local probes = appearance_probes()

  local function try(index)
    local probe = probes[index]
    if not probe then
      callback(nil)
      return
    end

    if vim.fn.executable(probe.cmd[1]) == 0 then
      try(index + 1)
      return
    end

    vim.system(probe.cmd, { text = true }, function(result)
      local mode = result.code == 0 and result.stdout and probe.parse(result.stdout) or nil
      vim.schedule(function()
        if mode then
          cached_appearance = mode
          callback(mode)
        else
          try(index + 1)
        end
      end)
    end)
  end

  try(1)
end

local function configured_mode()
  local config_ok, config = pcall(require, "meowvim.config")
  return config_ok and config.get("core.day_night_mode", "manual") or "manual"
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

  local switcher_ok, switcher = pcall(require, "meowvim.colorscheme_switcher")
  if switcher_ok and switcher.apply_theme then
    return switcher.apply_theme(theme, variant) ~= false
  end

  return false
end

-- Current effective mode. In "auto" this answers from the last probe, so it
-- never blocks; in "manual" there is no implicit mode.
function M.get_effective_mode()
  if configured_mode() == "auto" then
    return cached_appearance or "night"
  end
  return nil
end

-- Probe the system and apply the matching theme when it changed.
function M.check_appearance(force)
  if configured_mode() ~= "auto" then
    M.stop_watching()
    return
  end

  local previous = cached_appearance
  detect_appearance(function(appearance)
    if not appearance then
      return
    end
    if force or appearance ~= previous then
      apply_mode_theme(appearance)
      if previous and appearance ~= previous then
        vim.notify(string.format("System theme changed to %s mode", appearance), vim.log.levels.INFO)
      end
    end
  end)
end

-- Apply theme based on current day_night_mode setting
function M.apply_current_mode()
  if configured_mode() ~= "auto" then
    return false
  end
  M.check_appearance(true)
  return true
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

  if mode == "auto" then
    M.apply_current_mode()
    M.start_watching()
  else
    M.stop_watching()
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
  if config.get("core.day_night_mode", "manual") ~= "manual" then
    config.set("core.day_night_mode", "manual")
    M.stop_watching()
  end

  local current_theme = config.get("core.theme", "catppuccin")
  local current_variant = config.get("core.variant", "mocha")
  local day_theme = config.get("core.day_theme", "catppuccin")
  local day_variant = config.get("core.day_variant", "latte")

  local is_day = (current_theme == day_theme and current_variant == day_variant)
  local target = is_day and "night" or "day"

  apply_mode_theme(target)
  vim.notify(string.format("Switched to %s theme (manual mode)", target), vim.log.levels.INFO)
end

-- Set theme pair for day/night modes. `persist` defaults to true; callers that
-- change both slots at once pass false and persist once at the end.
local function set_theme_for_time(time_of_day, theme, variant, persist)
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    return
  end

  local current_theme = config.get("core.theme", "catppuccin")
  local current_variant = config.get("core.variant", "mocha")
  local old_theme = config.get("core." .. time_of_day .. "_theme", "catppuccin")
  local old_variant = config.get("core." .. time_of_day .. "_variant", time_of_day == "day" and "latte" or "mocha")

  config.set("core." .. time_of_day .. "_theme", theme)
  if variant then
    config.set("core." .. time_of_day .. "_variant", variant)
  end
  if persist ~= false then
    config.persist()
  end

  if configured_mode() == "auto" then
    if M.get_effective_mode() == time_of_day then
      apply_mode_theme(time_of_day)
    end
  elseif current_theme == old_theme and current_variant == old_variant then
    apply_mode_theme(time_of_day)
  end
end

function M.set_day_theme(theme, variant, persist)
  set_theme_for_time("day", theme, variant, persist)
end

function M.set_night_theme(theme, variant, persist)
  set_theme_for_time("night", theme, variant, persist)
end

-- Watch system appearance changes
function M.start_watching()
  if #appearance_probes() == 0 then
    vim.notify("System theme sync not supported on this platform", vim.log.levels.WARN)
    return false
  end

  if is_watching then
    return true
  end

  timer = vim.uv.new_timer()
  if not timer then
    return false
  end

  timer:start(
    POLL_INTERVAL_MS,
    POLL_INTERVAL_MS,
    vim.schedule_wrap(function()
      M.check_appearance()
    end)
  )

  -- Returning to the terminal is the moment a stale theme is most visible, so
  -- probe then too instead of relying on the slow timer alone.
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = vim.api.nvim_create_augroup("meowvim-day-night-focus", { clear = true }),
    callback = function()
      M.check_appearance()
    end,
  })

  is_watching = true
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
  pcall(vim.api.nvim_del_augroup_by_name, "meowvim-day-night-focus")
  is_watching = false
end

-- Interactive mode selector
function M.select_mode()
  local current_mode = configured_mode()

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
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    vim.notify("Config not available", vim.log.levels.ERROR)
    return
  end

  local current_day_theme = config.get("core.day_theme", "catppuccin")
  local current_day_variant = config.get("core.day_variant", "latte")
  local current_night_theme = config.get("core.night_theme", "catppuccin")
  local current_night_variant = config.get("core.night_variant", "mocha")

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
      M._select_theme_for_slot("day")
    elseif idx == 2 then
      M._select_theme_for_slot("night")
    elseif idx == 3 or idx == 4 then
      local theme = config.get("core.theme", "catppuccin")
      local variant = config.get("core.variant", "mocha")
      if idx == 3 then
        M.set_day_theme(theme, variant)
      else
        M.set_night_theme(theme, variant)
      end
    elseif idx == 5 then
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
  vim.defer_fn(function()
    if configured_mode() == "auto" then
      M.apply_current_mode()
      M.start_watching()
    end
  end, 100)

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

    local theme = config.get("core.theme", "catppuccin")
    local variant = config.get("core.variant", "mocha")

    if mode == "day" then
      M.set_day_theme(theme, variant)
    else
      M.set_night_theme(theme, variant)
    end
    vim.notify(
      string.format("%s theme set to: %s (%s)", mode:gsub("^%l", string.upper), theme, variant or "default"),
      vim.log.levels.INFO
    )
  end, {
    nargs = 1,
    complete = function()
      return { "day", "night" }
    end,
    desc = "Set current theme as day or night theme",
  })
end

return M
