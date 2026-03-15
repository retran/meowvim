-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/themes.lua
-- @brief: Colorscheme configurations for Meowvim

local function get_config_theme()
  local ok, config = pcall(require, "meowvim.config")
  if ok then
    return config.get("core.theme", "catppuccin"), 
           config.get("core.variant", "mocha"),
           config.get("ui.transparency", 0)
  end
  return "catppuccin", "mocha", 0
end

-- Catppuccin theme
local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "catppuccin" then
      return
    end

    require("catppuccin").setup({
      flavour = variant, -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = transparency > 0,
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
    
    -- Apply transparency level if > 0
    if transparency > 0 then
      local alpha = 100 - transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    end
  end,
}

-- TokyoNight theme
local tokyonight = {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "tokyonight" then
      return
    end

    require("tokyonight").setup({
      style = variant, -- storm, night, moon, day
      transparent = transparency > 0,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = transparency > 0 and "transparent" or "dark",
        floats = transparency > 0 and "transparent" or "dark",
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
    local theme, variant, transparency = get_config_theme()
    
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
        transparency = transparency > 0,
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
    local theme, variant, transparency = get_config_theme()
    
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
      transparent_mode = transparency > 0,
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
    local theme, _, transparency = get_config_theme()
    
    if theme ~= "nord" then
      return
    end

    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = transparency > 0
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
    local theme, variant, transparency = get_config_theme()
    
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
      transparent = transparency > 0,
      dimInactive = false,
      terminalColors = true,
      theme = variant or "wave", -- wave, dragon, lotus
    })
    
    vim.cmd.colorscheme("kanagawa")
  end,
}

-- Everforest theme
local everforest = {
  "neanias/everforest-nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "everforest" then
      return
    end

    -- Parse variant: format is "background_style" (e.g., "dark_hard", "light_soft")
    -- Variants: hard, medium, soft for both dark and light backgrounds
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
      background = background, -- "dark" or "light"
      transparent_background_level = transparency > 0 and 2 or 0,
      italics = true,
      disable_italic_comments = false,
      sign_column_background = "none",
      ui_contrast = style, -- "hard", "medium", "soft"
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
}

-- Nightfox theme
local nightfox = {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "nightfox" then
      return
    end

    require("nightfox").setup({
      options = {
        transparent = transparency > 0,
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
  end,
}

-- Zenbones theme
local zenbones = {
  "mcchrish/zenbones.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "rktjmp/lush.nvim" },
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "zenbones" then
      return
    end

    vim.g.zenbones_compat = 1
    if transparency > 0 then
      vim.g.zenbones_transparent_background = true
    end
    
    -- Variants: zenbones, zenwritten, neobones, tokyobones, seoulbones, 
    --           forestbones, nordbones, kanagawabones, rosebones
    vim.cmd.colorscheme(variant or "zenbones")
  end,
}

-- Solarized Osaka theme
local solarized_osaka = {
  "craftzdog/solarized-osaka.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "solarized-osaka" then
      return
    end

    require("solarized-osaka").setup({
      transparent = transparency > 0,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = transparency > 0 and "transparent" or "dark",
        floats = transparency > 0 and "transparent" or "dark",
      },
      -- Variants: storm (dark), night (darker), moon (darkest), day (light)
      style = variant or "night",
    })
    
    vim.cmd.colorscheme("solarized-osaka")
  end,
}

-- Ayu theme
local ayu = {
  "Shatur/neovim-ayu",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "ayu" then
      return
    end

    require("ayu").setup({
      mirage = variant == "mirage",
      terminal = true,
      overrides = transparency > 0 and {
        Normal = { bg = "None" },
        ColorColumn = { bg = "None" },
        SignColumn = { bg = "None" },
        Folded = { bg = "None" },
        FoldColumn = { bg = "None" },
        CursorLine = { bg = "None" },
        CursorColumn = { bg = "None" },
        WhichKeyFloat = { bg = "None" },
        VertSplit = { bg = "None" },
      } or {},
    })
    
    -- Set background before applying colorscheme
    -- Variants: dark, light, mirage
    if variant == "light" then
      vim.o.background = "light"
    else
      vim.o.background = "dark"
    end
    
    vim.cmd.colorscheme("ayu")
  end,
}

-- Dracula theme
local dracula = {
  "Mofiqul/dracula.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, _, transparency = get_config_theme()
    
    if theme ~= "dracula" then
      return
    end

    require("dracula").setup({
      transparent_bg = transparency > 0,
      italic_comment = true,
    })
    
    vim.cmd.colorscheme("dracula")
  end,
}

-- Monokai Pro theme
local monokai_pro = {
  "loctvl842/monokai-pro.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "monokai-pro" then
      return
    end

    require("monokai-pro").setup({
      transparent_background = transparency > 0,
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
      filter = variant or "pro", -- pro, octagon, machine, ristretto, spectrum, classic
    })
    
    vim.cmd.colorscheme("monokai-pro")
  end,
}

-- One Dark/Light theme
local onedark = {
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "onedark" then
      return
    end

    require("onedarkpro").setup({
      options = {
        transparency = transparency > 0,
        terminal_colors = true,
        cursorline = true,
        highlight_inactive_windows = false,
      },
      styles = {
        comments = "italic",
        keywords = "bold",
        functions = "NONE",
        strings = "NONE",
        variables = "NONE",
      },
    })
    
    -- Variants: onedark, onelight, onedark_vivid, onedark_dark
    vim.cmd.colorscheme(variant or "onedark")
  end,
}

-- Material theme
local material = {
  "marko-cerovac/material.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "material" then
      return
    end

    require("material").setup({
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = {},
        keywords = { italic = true },
        functions = {},
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        "gitsigns",
        "telescope",
        "nvim-cmp",
        "nvim-web-devicons",
        "which-key",
        "mini",
        "snacks",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = transparency > 0,
        term_colors = false,
        eob_lines = false,
      },
      lualine_style = "default",
      async_loading = true,
    })
    
    -- Variants: darker, lighter, oceanic, palenight, deep ocean
    vim.g.material_style = variant or "darker"
    vim.cmd.colorscheme("material")
  end,
}

-- Melange theme
local melange = {
  "savq/melange-nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, _, transparency = get_config_theme()
    
    if theme ~= "melange" then
      return
    end

    if transparency > 0 then
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "melange",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
        end,
      })
    end
    
    vim.cmd.colorscheme("melange")
  end,
}

-- GitHub theme
local github = {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  lazy = false,
  config = function()
    local theme, variant, transparency = get_config_theme()
    
    if theme ~= "github" then
      return
    end

    require("github-theme").setup({
      options = {
        transparent = transparency > 0,
        terminal_colors = true,
        dim_inactive = false,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    })
    
    -- Variants: github_dark, github_dark_dimmed, github_dark_high_contrast,
    --           github_light, github_light_high_contrast, github_dark_colorblind,
    --           github_light_colorblind, github_dark_tritanopia, github_light_tritanopia
    vim.cmd.colorscheme(variant or "github_dark")
  end,
}

-- Ensure Copilot ghost text uses the theme's Comment color (muted, visually distinct)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    local fg = comment_hl.fg
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = fg, italic = true })
    vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = fg, italic = true })
  end,
})

-- Return all themes
return {
  catppuccin,
  tokyonight,
  rose_pine,
  gruvbox,
  nord,
  kanagawa,
  everforest,
  nightfox,
  zenbones,
  solarized_osaka,
  ayu,
  dracula,
  monokai_pro,
  onedark,
  material,
  melange,
  github,
}
