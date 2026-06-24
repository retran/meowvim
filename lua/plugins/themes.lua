-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/themes.lua
-- @brief: Colorscheme configurations for Meowvim

local function get_config_theme()
  local ok, config = pcall(require, "meowvim.config")
  if ok then
    return config.get("core.theme", "catppuccin"), config.get("core.variant", "mocha"), config.get("ui.transparency", 0)
  end
  return "catppuccin", "mocha", 0
end

-- Read active theme once at module-load time so inactive themes are marked
-- enabled=false and never installed or loaded at startup.
local active_theme = (function()
  local ok, cfg = pcall(require, "meowvim.config")
  return ok and cfg.get("core.theme", "catppuccin") or "catppuccin"
end)()

local function theme_spec(name, spec)
  spec.priority = 1000
  if name == active_theme then
    spec.lazy = false
  else
    spec.lazy = true
    spec.enabled = false
  end
  return spec
end

local catppuccin = theme_spec("catppuccin", {
  "catppuccin/nvim",
  name = "catppuccin",
  config = function()
    local theme, variant, transparency = get_config_theme()
    if theme ~= "catppuccin" then
      return
    end
    require("catppuccin").setup({
      flavour = variant,
      background = { light = "latte", dark = "mocha" },
      transparent_background = transparency > 0,
      default_integrations = true,
      auto_integrations = true,
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        lualine = true,
        mini = { enabled = true, indentscope_color = "" },
        neogit = true,
        neotest = true,
        noice = true,
        overseer = true,
        rainbow_delimiters = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,
      },
    })
    vim.g.catppuccin_flavour = variant
    vim.cmd.colorscheme("catppuccin")
    if transparency > 0 then
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    end
  end,
})

local tokyonight = theme_spec("tokyonight", {
  "folke/tokyonight.nvim",
  config = function()
    local theme, variant, transparency = get_config_theme()
    if theme ~= "tokyonight" then
      return
    end
    require("tokyonight").setup({
      style = variant,
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
})

local rose_pine = theme_spec("rose-pine", {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    local theme, variant, transparency = get_config_theme()
    if theme ~= "rose-pine" then
      return
    end
    require("rose-pine").setup({
      variant = variant,
      dark_variant = "main",
      enable = { terminal = true, migrations = true },
      styles = { italic = true, transparency = transparency > 0 },
    })
    vim.cmd.colorscheme("rose-pine")
  end,
})

local gruvbox = theme_spec("gruvbox", {
  "ellisonleao/gruvbox.nvim",
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
      contrast = variant or "medium",
      transparent_mode = transparency > 0,
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
})

local nord = theme_spec("nord", {
  "shaunsingh/nord.nvim",
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
})

local kanagawa = theme_spec("kanagawa", {
  "rebelot/kanagawa.nvim",
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
      theme = variant or "wave",
    })
    vim.cmd.colorscheme("kanagawa")
  end,
})

local everforest = theme_spec("everforest", {
  "neanias/everforest-nvim",
  config = function()
    local theme, variant, transparency = get_config_theme()
    if theme ~= "everforest" then
      return
    end
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
      transparent_background_level = transparency > 0 and 2 or 0,
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
})

local nightfox = theme_spec("nightfox", {
  "EdenEast/nightfox.nvim",
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
})

local zenbones = theme_spec("zenbones", {
  "mcchrish/zenbones.nvim",
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
})

local solarized_osaka = theme_spec("solarized-osaka", {
  "craftzdog/solarized-osaka.nvim",
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
})

local ayu = theme_spec("ayu", {
  "Shatur/neovim-ayu",
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
    -- Variants: dark, light, mirage
    vim.o.background = variant == "light" and "light" or "dark"
    vim.cmd.colorscheme("ayu")
  end,
})

local dracula = theme_spec("dracula", {
  "Mofiqul/dracula.nvim",
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
})

local monokai_pro = theme_spec("monokai-pro", {
  "loctvl842/monokai-pro.nvim",
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
})

local onedark = theme_spec("onedark", {
  "olimorris/onedarkpro.nvim",
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
})

local material = theme_spec("material", {
  "marko-cerovac/material.nvim",
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
        "blink",
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
})

local melange = theme_spec("melange", {
  "savq/melange-nvim",
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
})

local github = theme_spec("github", {
  "projekt0n/github-nvim-theme",
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
})

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
