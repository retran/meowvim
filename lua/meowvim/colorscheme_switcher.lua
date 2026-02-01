-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/colorscheme_switcher.lua
-- @brief: Interactive colorscheme switcher with live preview

local M = {}

-- Available themes and their variants
local themes = {
  catppuccin = { "mocha", "latte", "frappe", "macchiato" },
  tokyonight = { "storm", "night", "moon", "day" },
  ["rose-pine"] = { "main", "moon", "dawn" },
  gruvbox = { "medium", "hard", "soft" },
  nord = {},
  kanagawa = { "wave", "dragon", "lotus" },
}

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
  end
end

function M.select()
  local options = get_all_theme_options()
  
  -- Save current theme for cancel/restore
  local config_ok, config = pcall(require, "meowvim.config")
  local original_theme = config_ok and config.get("core.theme", "catppuccin") or "catppuccin"
  local original_variant = config_ok and config.get("core.variant", "mocha") or "mocha"
  
  -- Use vim.ui.select for colorscheme selection
  local displays = vim.tbl_map(function(opt)
    return opt.display
  end, options)
  
  vim.ui.select(displays, {
    prompt = "Select colorscheme:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if choice and idx then
      local selected = options[idx]
      apply_theme(selected.theme, selected.variant)
      
      -- Persist to config file
      if config_ok then
        config.set("core.theme", selected.theme)
        if selected.variant then
          config.set("core.variant", selected.variant)
        end
        config.persist()
        
        vim.notify(
          string.format("Colorscheme set to %s and saved to config.", choice),
          vim.log.levels.INFO
        )
      else
        vim.notify(
          string.format("Colorscheme set to %s (not persisted).", choice),
          vim.log.levels.WARN
        )
      end
    end
  end)
end

-- Preview on cursor move (for telescope integration)
function M.preview_theme(theme, variant)
  apply_theme(theme, variant)
end

-- Register command
vim.api.nvim_create_user_command("ColorschemeSelect", function()
  M.select()
end, { desc = "Select colorscheme with live preview" })

-- Keymap
vim.keymap.set("n", "<leader>ok", M.select, { desc = "Select Colorscheme" })

return M
