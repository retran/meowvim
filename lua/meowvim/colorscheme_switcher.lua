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
  
  -- Apply the theme
  if theme == "catppuccin" then
    vim.g.catppuccin_flavour = variant or "mocha"
    vim.cmd.colorscheme("catppuccin")
  elseif theme == "tokyonight" then
    vim.cmd.colorscheme("tokyonight")
  elseif theme == "rose-pine" then
    vim.cmd.colorscheme("rose-pine")
  elseif theme == "gruvbox" then
    vim.cmd.colorscheme("gruvbox")
  elseif theme == "nord" then
    vim.cmd.colorscheme("nord")
  elseif theme == "kanagawa" then
    vim.cmd.colorscheme("kanagawa")
  end
end

function M.select()
  local options = get_all_theme_options()
  local displays = vim.tbl_map(function(opt)
    return opt.display
  end, options)
  
  -- Save current theme
  local config_ok, config = pcall(require, "meowvim.config")
  local original_theme = config_ok and config.get("core.theme", "catppuccin") or "catppuccin"
  local original_variant = config_ok and config.get("core.variant", "mocha") or "mocha"
  
  -- Use vim.ui.select with live preview
  vim.ui.select(displays, {
    prompt = "Select colorscheme:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if choice and idx then
      local selected = options[idx]
      apply_theme(selected.theme, selected.variant)
      
      -- Persist the choice
      if config_ok then
        local user_config_path = vim.fn.expand("~/.config/meowvim/config.lua")
        vim.notify(
          string.format("Colorscheme set to %s. Update %s to persist.", choice, user_config_path),
          vim.log.levels.INFO
        )
      end
    else
      -- Restore original theme if cancelled
      apply_theme(original_theme, original_variant)
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
