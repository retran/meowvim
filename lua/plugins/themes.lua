-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/themes.lua
-- @brief: Colorscheme configurations for Meowvim

local function get_config_theme()
  local ok, config = pcall(require, "meowvim.config")
  if ok then
    return config.get("core.theme", "catppuccin"), config.get("core.variant", "mocha")
  end
  return "catppuccin", "mocha"
end

-- Catppuccin theme
local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant = get_config_theme()
    
    if theme ~= "catppuccin" then
      return
    end

    require("catppuccin").setup({
      flavour = variant, -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      default_integrations = true,
      auto_integrations = true,
      integrations = {
        lualine = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        which_key = true,
        snacks = true,
        treesitter = true,
        telescope = true,
        mason = true,
        cmp = true,
        gitsigns = true,
      },
    })
    
    vim.g.catppuccin_flavour = variant
    vim.cmd.colorscheme("catppuccin")
  end,
}

-- TokyoNight theme
local tokyonight = {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant = get_config_theme()
    
    if theme ~= "tokyonight" then
      return
    end

    require("tokyonight").setup({
      style = variant, -- storm, night, moon, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    })
    
    vim.cmd.colorscheme("tokyonight")
  end,
}

-- Rose Pine theme
local rose_pine = {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant = get_config_theme()
    
    if theme ~= "rose-pine" then
      return
    end

    require("rose-pine").setup({
      variant = variant, -- main, moon, dawn
      dark_variant = "main",
      enable = {
        terminal = true,
        migrations = true,
      },
      styles = {
        italic = true,
        transparency = false,
      },
    })
    
    vim.cmd.colorscheme("rose-pine")
  end,
}

-- Gruvbox theme
local gruvbox = {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant = get_config_theme()
    
    if theme ~= "gruvbox" then
      return
    end

    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      contrast = variant or "medium", -- hard, medium, soft
      transparent_mode = false,
    })
    
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}

-- Nord theme
local nord = {
  "shaunsingh/nord.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme = get_config_theme()
    
    if theme ~= "nord" then
      return
    end

    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = true
    vim.g.nord_bold = true
    
    vim.cmd.colorscheme("nord")
  end,
}

-- Kanagawa theme
local kanagawa = {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant = get_config_theme()
    
    if theme ~= "kanagawa" then
      return
    end

    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = variant or "wave", -- wave, dragon, lotus
    })
    
    vim.cmd.colorscheme("kanagawa")
  end,
}

-- Return all themes
return {
  catppuccin,
  tokyonight,
  rose_pine,
  gruvbox,
  nord,
  kanagawa,
}
