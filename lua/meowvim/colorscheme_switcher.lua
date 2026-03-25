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
  zenbones = {
    "zenbones",
    "zenwritten",
    "neobones",
    "tokyobones",
    "seoulbones",
    "forestbones",
    "nordbones",
    "kanagawabones",
    "rosebones",
  },
  ayu = { "dark", "light", "mirage" },

  -- Classic Dark
  nord = {},
  dracula = {},
  melange = {},

  -- Professional Studio
  ["monokai-pro"] = { "pro", "octagon", "machine", "ristretto", "spectrum", "classic" },

  -- Developer Standard
  onedark = { "onedark", "onelight", "onedark_vivid", "onedark_dark" },

  -- Material Design
  material = { "darker", "lighter", "oceanic", "palenight", "deep ocean" },

  -- GitHub Official
  github = {
    "github_dark",
    "github_dark_dimmed",
    "github_dark_high_contrast",
    "github_light",
    "github_light_high_contrast",
  },
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

local theme_appliers = {
  catppuccin = function(variant)
    require("catppuccin").setup({ flavour = variant or "mocha", transparent_background = false })
    vim.cmd.colorscheme("catppuccin")
  end,
  tokyonight = function(variant)
    require("tokyonight").setup({ style = variant or "storm", transparent = false })
    vim.cmd.colorscheme("tokyonight")
  end,
  ["rose-pine"] = function(variant)
    require("rose-pine").setup({ variant = variant or "main", styles = { transparency = false } })
    vim.cmd.colorscheme("rose-pine")
  end,
  gruvbox = function(variant)
    require("gruvbox").setup({ contrast = variant or "medium", transparent_mode = false })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
  nord = function(_)
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.cmd.colorscheme("nord")
  end,
  kanagawa = function(variant)
    require("kanagawa").setup({ theme = variant or "wave", transparent = false })
    vim.cmd.colorscheme("kanagawa")
  end,
  everforest = function(variant)
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
  end,
  nightfox = function(variant)
    require("nightfox").setup({
      options = {
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        styles = { comments = "italic", keywords = "bold", types = "italic,bold" },
      },
    })
    vim.cmd.colorscheme(variant or "nightfox")
  end,
  zenbones = function(variant)
    vim.g.zenbones_compat = 1
    vim.g.zenbones_transparent_background = false
    vim.cmd.colorscheme(variant or "zenbones")
  end,
  ["solarized-osaka"] = function(variant)
    require("solarized-osaka").setup({
      transparent = false,
      terminal_colors = true,
      styles = { comments = { italic = true }, keywords = { italic = true }, functions = {}, variables = {}, sidebars = "dark", floats = "dark" },
      style = variant or "night",
    })
    vim.cmd.colorscheme("solarized-osaka")
  end,
  ayu = function(variant)
    require("ayu").setup({ mirage = variant == "mirage", terminal = true, overrides = {} })
    vim.o.background = variant == "light" and "light" or "dark"
    vim.cmd.colorscheme("ayu")
  end,
  dracula = function(_)
    require("dracula").setup({ transparent_bg = false, italic_comment = true })
    vim.cmd.colorscheme("dracula")
  end,
  ["monokai-pro"] = function(variant)
    require("monokai-pro").setup({
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      styles = {
        comment = { italic = true },
        keyword = { italic = true },
        type = { italic = true },
        storageclass = { italic = true },
        structure = { italic = true },
        parameter = { italic = true },
        annotation = { italic = true },
        tag_attribute = { italic = true },
      },
      filter = variant or "pro",
    })
    vim.cmd.colorscheme("monokai-pro")
  end,
  onedark = function(variant)
    require("onedarkpro").setup({
      options = { transparency = false, terminal_colors = true, cursorline = true, highlight_inactive_windows = false },
      styles = { comments = "italic", keywords = "bold", functions = "NONE", strings = "NONE", variables = "NONE" },
    })
    vim.cmd.colorscheme(variant or "onedark")
  end,
  material = function(variant)
    require("material").setup({
      contrast = { terminal = false, sidebars = false, floating_windows = false, cursor_line = false, non_current_windows = false, filetypes = {} },
      styles = { comments = { italic = true }, strings = {}, keywords = { italic = true }, functions = {}, variables = {}, operators = {}, types = {} },
      plugins = { "gitsigns", "telescope", "nvim-cmp", "nvim-web-devicons", "which-key", "mini", "snacks" },
      disable = { colored_cursor = false, borders = false, background = false, term_colors = false, eob_lines = false },
      lualine_style = "default",
      async_loading = true,
    })
    vim.g.material_style = variant or "darker"
    vim.cmd.colorscheme("material")
  end,
  melange = function(_)
    vim.cmd.colorscheme("melange")
  end,
  github = function(variant)
    require("github-theme").setup({
      options = {
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        styles = { comments = "italic", keywords = "bold", types = "italic,bold" },
      },
    })
    vim.cmd.colorscheme(variant or "github_dark")
  end,
}

local function apply_theme(theme, variant)
  -- Update config if available
  local config_ok, config = pcall(require, "meowvim.config")
  if config_ok then
    config.set("core.theme", theme)
    if variant then
      config.set("core.variant", variant)
    end
  end

  local applier = theme_appliers[theme]
  if applier then
    applier(variant)
  end
end

function M.select()
  local options = get_base_theme_options()

  -- Save current theme for cancel/restore
  local config_ok, config = pcall(require, "meowvim.config")
  local _ = config_ok and config.get("core.theme", "catppuccin") or "catppuccin"

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
        vim.notify(string.format("Theme set to %s (not persisted).", theme), vim.log.levels.WARN)
      end
    end
  end)
end

-- Helper to check if a variant is light or dark
local function is_light_variant(_, variant)
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
    onelight = true,
    lighter = true,
    classic = true, -- monokai-pro classic (lighter)
    github_light = true,
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
