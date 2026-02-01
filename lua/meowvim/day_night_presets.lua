-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/day_night_presets.lua
-- @brief: Recommended day/night theme pairs

local M = {}

-- Theme-to-preset mapping (each theme has a default preset)
M.theme_defaults = {
  everforest = "everforest",
  catppuccin = "catppuccin",
  tokyonight = "tokyonight",
  kanagawa = "kanagawa",
  ["rose-pine"] = "rosepine",
  nightfox = "nightfox",
  ["solarized-osaka"] = "solarized",
  zenbones = "zenbones",
  ayu = "ayu",
  gruvbox = "gruvbox",
  nord = "gruvbox", -- Nord only has dark, fallback to gruvbox
  dracula = "dracula",
  ["monokai-pro"] = "monokai",
  onedark = "onedark",
  material = "material",
  melange = "melange",
  github = "github",
}

-- Recommended theme pairs optimized for seamless day/night transitions
-- Each preset maintains similar syntax highlighting feel across light/dark modes
M.presets = {
  -- For those seeking minimal eye strain (Recommended for Amsterdam weather)
  everforest = {
    name = "Everforest",
    description = "Organic colors, warm tones, minimal eye strain",
    mood = "Soft & Natural",
    day = { theme = "everforest", variant = "light_soft" },
    night = { theme = "everforest", variant = "dark_medium" },
  },
  
  -- Modern & Popular
  catppuccin = {
    name = "Catppuccin",
    description = "Pastel colors, modern aesthetic, huge ecosystem",
    mood = "Sweet & Modern",
    day = { theme = "catppuccin", variant = "latte" },
    night = { theme = "catppuccin", variant = "mocha" },
  },
  
  tokyonight = {
    name = "Tokyo Night",
    description = "Clean, professional, excellent LSP/Treesitter support",
    mood = "Tech & Future",
    day = { theme = "tokyonight", variant = "day" },
    night = { theme = "tokyonight", variant = "storm" },
  },
  
  -- Artistic & Elegant
  kanagawa = {
    name = "Kanagawa",
    description = "Japanese art-inspired, deep colors, very elegant",
    mood = "Classic & Artistic",
    day = { theme = "kanagawa", variant = "lotus" },
    night = { theme = "kanagawa", variant = "wave" },
  },
  
  rosepine = {
    name = "Rose Pine",
    description = "Minimal palette, mountain sunset vibes, meditative",
    mood = "Calm & Minimal",
    day = { theme = "rose-pine", variant = "dawn" },
    night = { theme = "rose-pine", variant = "main" },
  },
  
  -- High Contrast & Technical
  nightfox = {
    name = "Nightfox",
    description = "High contrast, excellent readability, sharp",
    mood = "Sharp & Technical",
    day = { theme = "nightfox", variant = "dayfox" },
    night = { theme = "nightfox", variant = "nightfox" },
  },
  
  -- Mathematical Precision
  solarized = {
    name = "Solarized Osaka",
    description = "Mathematically precise contrast, legendary scheme",
    mood = "Professional Lab",
    day = { theme = "solarized-osaka", variant = "day" },
    night = { theme = "solarized-osaka", variant = "night" },
  },
  
  -- Pure Minimalism
  zenbones = {
    name = "Zenbones",
    description = "No visual noise, maximum focus, bone/charcoal colors",
    mood = "Pure Focus",
    day = { theme = "zenbones", variant = "zenwritten" },
    night = { theme = "zenbones", variant = "zenbones" },
  },
  
  -- Clean Design Studio
  ayu = {
    name = "Ayu",
    description = "From Sublime Text, very clean and airy",
    mood = "Design Studio",
    day = { theme = "ayu", variant = "light" },
    night = { theme = "ayu", variant = "dark" },
  },
  
  -- Warm Retro (only dark, but listed for completeness)
  gruvbox = {
    name = "Gruvbox",
    description = "Warm retro colors, cozy feel (dark only)",
    mood = "Retro & Cozy",
    day = { theme = "gruvbox", variant = "soft" },
    night = { theme = "gruvbox", variant = "medium" },
  },
  
  -- Classic Dark (dark only, paired with ayu light)
  dracula = {
    name = "Dracula",
    description = "The legendary dark theme, vibrant and professional",
    mood = "Dark Legend",
    day = { theme = "ayu", variant = "light" },
    night = { theme = "dracula", variant = nil },
  },
  
  -- Professional Studio
  monokai = {
    name = "Monokai Pro",
    description = "Professional favorite, high contrast, stylish",
    mood = "Pro Studio",
    day = { theme = "monokai-pro", variant = "classic" },
    night = { theme = "monokai-pro", variant = "pro" },
  },
  
  -- Balanced & Familiar
  onedark = {
    name = "One Dark",
    description = "From Atom/VS Code, balanced and familiar",
    mood = "Developer Standard",
    day = { theme = "onedark", variant = "onelight" },
    night = { theme = "onedark", variant = "onedark" },
  },
  
  -- Material Design
  material = {
    name = "Material",
    description = "Google Material Design, modern and colorful",
    mood = "Material & Modern",
    day = { theme = "material", variant = "lighter" },
    night = { theme = "material", variant = "darker" },
  },
  
  -- Warm Balanced (dark only, paired with everforest)
  melange = {
    name = "Melange",
    description = "Warm balanced colors, unique palette (dark only)",
    mood = "Warm Harmony",
    day = { theme = "everforest", variant = "light_soft" },
    night = { theme = "melange", variant = nil },
  },
  
  -- GitHub Official
  github = {
    name = "GitHub",
    description = "Official GitHub theme, familiar and clean",
    mood = "GitHub Official",
    day = { theme = "github", variant = "github_light" },
    night = { theme = "github", variant = "github_dark" },
  },
}

-- Get preset details
function M.get_preset(preset_name)
  if not preset_name then
    return nil
  end
  
  local preset = M.presets[preset_name]
  if not preset then
    return nil
  end
  
  return {
    day_theme = preset.day.theme,
    day_variant = preset.day.variant,
    night_theme = preset.night.theme,
    night_variant = preset.night.variant,
  }
end

-- Apply a preset
function M.apply_preset(preset_name)
  local preset = M.presets[preset_name]
  if not preset then
    vim.notify(
      string.format("Unknown preset: %s", preset_name),
      vim.log.levels.ERROR
    )
    return false
  end
  
  local day_night = require("meowvim.day_night")
  local config_ok, config = pcall(require, "meowvim.config")
  
  -- Set day theme
  day_night.set_day_theme(preset.day.theme, preset.day.variant)
  
  -- Set night theme
  day_night.set_night_theme(preset.night.theme, preset.night.variant)
  
  -- Save last preset for reset functionality
  if config_ok then
    config.set("core.last_preset", preset_name)
    config.persist()
  end
  
  -- Apply current mode's theme immediately
  local current_mode = day_night.get_effective_mode()
  if current_mode then
    day_night.apply_current_mode()
  end
  
  vim.notify(
    string.format(
      "Applied preset: %s\nDay: %s (%s)\nNight: %s (%s)",
      preset.name,
      preset.day.theme,
      preset.day.variant,
      preset.night.theme,
      preset.night.variant
    ),
    vim.log.levels.INFO
  )
  
  return true
end

-- Interactive preset selector
function M.select_preset()
  -- Get current preset
  local config_ok, config = pcall(require, "meowvim.config")
  local current_preset = config_ok and config.get("core.last_preset", nil) or nil
  
  local preset_names = {}
  local presets_list = {}
  
  for key, preset in pairs(M.presets) do
    table.insert(presets_list, { key = key, preset = preset })
  end
  
  -- Sort by name
  table.sort(presets_list, function(a, b)
    return a.preset.name < b.preset.name
  end)
  
  -- Create display strings
  for _, item in ipairs(presets_list) do
    local indicator = item.key == current_preset and "● " or "  "
    local display = string.format(
      "%s%s - %s",
      indicator,
      item.preset.name,
      item.preset.mood
    )
    table.insert(preset_names, { key = item.key, display = display })
  end
  
  vim.ui.select(preset_names, {
    prompt = string.format("Preset (current: %s)", current_preset or "none"),
    format_item = function(item)
      return "  " .. item.display
    end,
  }, function(choice, _)
    if choice then
      M.apply_preset(choice.key)
    end
  end)
end

-- Setup command
function M.setup()
  vim.api.nvim_create_user_command("DayNightPreset", function(opts)
    if opts.args == "" then
      M.select_preset()
    else
      M.apply_preset(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      local names = {}
      for key, _ in pairs(M.presets) do
        table.insert(names, key)
      end
      table.sort(names)
      return names
    end,
    desc = "Apply or select day/night theme preset",
  })
end

return M
