-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/colorscheme_switcher.lua
-- @brief: Interactive colorscheme switcher with live preview

local M = {}

-- Available themes and their variants
local themes = {
  -- Modern & Popular
  catppuccin = { "mocha", "latte", "frappe", "macchiato" },
  tokyonight = { "storm", "night", "moon", "day" },
  ["rose-pine"] = { "main", "moon", "dawn" },
  
  -- Warm & Natural
  everforest = { "dark_hard", "dark_medium", "dark_soft", "light_hard", "light_medium", "light_soft" },
  gruvbox = { "medium", "hard", "soft" },
  
  -- Clean & Professional
  kanagawa = { "wave", "dragon", "lotus" },
  ["solarized-osaka"] = { "night", "storm", "moon", "day" },
  
  -- Tech & High Contrast
  nightfox = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" },
  
  -- Minimal & Focused
  zenbones = { "zenbones", "zenwritten", "neobones", "tokyobones", "seoulbones", "forestbones", "nordbones", "kanagawabones", "rosebones" },
  ayu = { "dark", "light", "mirage" },
  
  -- Classic
  nord = {},
}

-- Get base themes without variants (for main theme picker)
local function get_base_theme_options()
  local options = {}
  for theme, _ in pairs(themes) do
    table.insert(options, { theme = theme, display = theme })
  end
  -- Sort options for consistent ordering
  table.sort(options, function(a, b)
    return a.display < b.display
  end)
  return options
end

-- Get all theme options with variants (for day/night setup)
local function get_all_theme_options()
  local options = {}
  for theme, variants in pairs(themes) do
    if #variants == 0 then
      table.insert(options, { theme = theme, variant = nil, display = theme })
    else
      for _, variant in ipairs(variants) do
        table.insert(options, {
          theme = theme,
          variant = variant,
          display = string.format("%s (%s)", theme, variant),
        })
      end
    end
  end
  -- Sort options for consistent ordering
  table.sort(options, function(a, b)
    return a.display < b.display
  end)
  return options
end

local function apply_theme(theme, variant)
  -- Update config if available
  local config_ok, config = pcall(require, "meowvim.config")
  if config_ok then
    config.set("core.theme", theme)
    if variant then
      config.set("core.variant", variant)
    end
  end
  
  -- Apply theme-specific configuration
  if theme == "catppuccin" then
    require("catppuccin").setup({
      flavour = variant or "mocha",
      transparent_background = false,
    })
    vim.cmd.colorscheme("catppuccin")
  elseif theme == "tokyonight" then
    require("tokyonight").setup({
      style = variant or "storm",
      transparent = false,
    })
    vim.cmd.colorscheme("tokyonight")
  elseif theme == "rose-pine" then
    require("rose-pine").setup({
      variant = variant or "main",
      styles = {
        transparency = false,
      },
    })
    vim.cmd.colorscheme("rose-pine")
  elseif theme == "gruvbox" then
    require("gruvbox").setup({
      contrast = variant or "medium",
      transparent_mode = false,
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  elseif theme == "nord" then
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.cmd.colorscheme("nord")
  elseif theme == "kanagawa" then
    require("kanagawa").setup({
      theme = variant or "wave",
      transparent = false,
    })
    vim.cmd.colorscheme("kanagawa")
  elseif theme == "everforest" then
    -- Parse variant: format is "background_style" (e.g., "dark_hard", "light_soft")
    local background = "dark"
    local style = "medium"
    
    if variant then
      if variant:match("^light") then
        background = "light"
        style = variant:gsub("^light_", "")
      elseif variant:match("^dark") then
        background = "dark"
        style = variant:gsub("^dark_", "")
      else
        -- If just "hard", "medium", or "soft", use dark background
        style = variant
      end
    end
    
    require("everforest").setup({
      background = background,
      transparent_background_level = 0,
      italics = true,
      disable_italic_comments = false,
      sign_column_background = "none",
      ui_contrast = style,
      dim_inactive_windows = false,
      diagnostic_text_highlight = false,
      diagnostic_virtual_text = "coloured",
      diagnostic_line_highlight = false,
      spell_foreground = false,
      show_eob = true,
      float_style = "bright",
    })
    
    vim.o.background = background
    vim.cmd.colorscheme("everforest")
  elseif theme == "nightfox" then
    require("nightfox").setup({
      options = {
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    })
    -- Variants: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
    vim.cmd.colorscheme(variant or "nightfox")
  elseif theme == "zenbones" then
    vim.g.zenbones_compat = 1
    vim.g.zenbones_transparent_background = false
    -- Variants: zenbones, zenwritten, neobones, tokyobones, seoulbones, 
    --           forestbones, nordbones, kanagawabones, rosebones
    vim.cmd.colorscheme(variant or "zenbones")
  elseif theme == "solarized-osaka" then
    require("solarized-osaka").setup({
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      style = variant or "night", -- storm, night, moon, day
    })
    vim.cmd.colorscheme("solarized-osaka")
  elseif theme == "ayu" then
    require("ayu").setup({
      mirage = variant == "mirage",
      terminal = true,
      overrides = {},
    })
    -- Set background before applying colorscheme
    if variant == "light" then
      vim.o.background = "light"
    else
      vim.o.background = "dark"
    end
    vim.cmd.colorscheme("ayu")
  end
end

function M.select()
  local options = get_base_theme_options()
  
  -- Save current theme for cancel/restore
  local config_ok, config = pcall(require, "meowvim.config")
  local original_theme = config_ok and config.get("core.theme", "catppuccin") or "catppuccin"
  
  -- Use vim.ui.select for colorscheme selection
  local displays = vim.tbl_map(function(opt)
    return opt.display
  end, options)
  
  vim.ui.select(displays, {
    prompt = "Select theme:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if choice and idx then
      local selected = options[idx]
      local theme = selected.theme
      
      -- Get smart default variant based on current system appearance
      local variant = M.get_smart_variant(theme)
      
      apply_theme(theme, variant)
      
      -- Persist to config file (as main theme, NOT day/night)
      if config_ok then
        config.set("core.theme", theme)
        config.set("core.variant", variant)
        config.persist()
        
        vim.notify(
          string.format("Theme set to %s (%s) and saved to config.", theme, variant or "default"),
          vim.log.levels.INFO
        )
      else
        vim.notify(
          string.format("Theme set to %s (not persisted).", theme),
          vim.log.levels.WARN
        )
      end
    end
  end)
end

-- Get smart default variant based on system appearance
function M.get_smart_variant(theme)
  local theme_variants = themes[theme] or {}
  
  if #theme_variants == 0 then
    return nil
  end
  
  -- Try to detect system appearance
  local day_night_ok, day_night = pcall(require, "meowvim.day_night")
  local system_mode = nil
  
  if day_night_ok then
    system_mode = day_night.get_effective_mode()
  end
  
  -- If we can detect system mode, choose appropriate variant
  if system_mode == "day" then
    -- Find light variant
    for _, variant in ipairs(theme_variants) do
      if is_light_variant(theme, variant) then
        return variant
      end
    end
  end
  
  -- Default to first dark variant or just first variant
  for _, variant in ipairs(theme_variants) do
    if not is_light_variant(theme, variant) then
      return variant
    end
  end
  
  return theme_variants[1]
end

-- Preview on cursor move (for telescope integration)
function M.preview_theme(theme, variant)
  apply_theme(theme, variant)
end

-- Expose apply_theme for external use (e.g., day/night mode)
function M.apply_theme(theme, variant)
  apply_theme(theme, variant)
end

-- Get list of all themes
function M.get_themes()
  return themes
end

-- Get all theme options with variants (for day/night setup)
function M.get_all_theme_options()
  return get_all_theme_options()
end

-- Helper to check if a variant is light or dark
local function is_light_variant(theme, variant)
  -- Themes with explicit light variants
  local light_patterns = {
    latte = true,
    day = true,
    dawn = true,
    lotus = true,
    light = true,
    dayfox = true,
    dawnfox = true,
    zenwritten = true, -- light variant of zenbones
  }
  
  if not variant then
    return false
  end
  
  -- Check if variant name contains light indicators
  for pattern, _ in pairs(light_patterns) do
    if variant:match(pattern) then
      return true
    end
  end
  
  return false
end

-- Get default light/dark variants for a theme
function M.get_default_variants(theme)
  local theme_variants = themes[theme] or {}
  
  if #theme_variants == 0 then
    return nil, nil -- No variants
  end
  
  local light_variant = nil
  local dark_variant = nil
  
  for _, variant in ipairs(theme_variants) do
    if is_light_variant(theme, variant) then
      if not light_variant then
        light_variant = variant
      end
    else
      if not dark_variant then
        dark_variant = variant
      end
    end
  end
  
  -- Defaults if not found
  dark_variant = dark_variant or theme_variants[1]
  light_variant = light_variant or theme_variants[1]
  
  return dark_variant, light_variant
end

-- Register command
vim.api.nvim_create_user_command("ColorschemeSelect", function()
  M.select()
end, { desc = "Select colorscheme with live preview" })

-- Note: Main keymap is now in theme_manager (<leader>ok)
-- This is kept for backward compatibility

return M
