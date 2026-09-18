-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/themes.lua
-- @brief: Single source of truth for colorscheme plugins and their setup.
--
-- Both the lazy.nvim specs (lua/plugins/themes.lua) and the interactive
-- switcher (lua/meowvim/colorscheme_switcher.lua) are generated from this
-- table, so a theme is described exactly once.
--
-- Each entry provides:
--   repo         lazy.nvim plugin spec name
--   name         optional lazy.nvim alias (when the repo name is ambiguous)
--   dependencies optional extra plugins the theme needs
--   variants     selectable variants; empty when the theme has none
--   apply        fun(variant: string?, transparency: number) applies the theme

local M = {}

M.themes = {
  catppuccin = {
    repo = "catppuccin/nvim",
    name = "catppuccin",
    variants = { "mocha", "latte", "frappe", "macchiato" },
    apply = function(variant, transparency)
      require("catppuccin").setup({
        flavour = variant or "mocha",
        background = { light = "latte", dark = "mocha" },
        transparent_background = transparency > 0,
        default_integrations = true,
        auto_integrations = true,
        integrations = {
          blink_cmp = true,
          dap = true,
          dap_ui = true,
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
          treesitter = true,
          treesitter_context = true,
          ufo = true,
          which_key = true,
        },
      })
      vim.g.catppuccin_flavour = variant or "mocha"
      vim.cmd.colorscheme("catppuccin")
      if transparency > 0 then
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      end
    end,
  },

  tokyonight = {
    repo = "folke/tokyonight.nvim",
    variants = { "storm", "night", "moon", "day" },
    apply = function(variant, transparency)
      require("tokyonight").setup({
        style = variant or "storm",
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
  },

  ["rose-pine"] = {
    repo = "rose-pine/neovim",
    name = "rose-pine",
    variants = { "main", "moon", "dawn" },
    apply = function(variant, transparency)
      require("rose-pine").setup({
        variant = variant or "main",
        dark_variant = "main",
        enable = { terminal = true, migrations = true },
        styles = { italic = true, transparency = transparency > 0 },
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  gruvbox = {
    repo = "ellisonleao/gruvbox.nvim",
    variants = { "medium", "hard", "soft" },
    apply = function(variant, transparency)
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
  },

  nord = {
    repo = "shaunsingh/nord.nvim",
    variants = {},
    apply = function(_, transparency)
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = transparency > 0
      vim.g.nord_italic = true
      vim.g.nord_bold = true
      vim.cmd.colorscheme("nord")
    end,
  },

  kanagawa = {
    repo = "rebelot/kanagawa.nvim",
    variants = { "wave", "dragon", "lotus" },
    apply = function(variant, transparency)
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
  },

  everforest = {
    repo = "neanias/everforest-nvim",
    variants = {
      "dark_hard",
      "dark_medium",
      "dark_soft",
      "light_hard",
      "light_medium",
      "light_soft",
    },
    apply = function(variant, transparency)
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
  },

  nightfox = {
    repo = "EdenEast/nightfox.nvim",
    variants = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" },
    apply = function(variant, transparency)
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
      vim.cmd.colorscheme(variant or "nightfox")
    end,
  },

  zenbones = {
    repo = "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    variants = {
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
    apply = function(variant, transparency)
      vim.g.zenbones_compat = 1
      vim.g.zenbones_transparent_background = transparency > 0
      vim.cmd.colorscheme(variant or "zenbones")
    end,
  },

  ["solarized-osaka"] = {
    repo = "craftzdog/solarized-osaka.nvim",
    variants = { "night", "storm", "moon", "day" },
    apply = function(variant, transparency)
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
        style = variant or "night",
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },

  ayu = {
    repo = "Shatur/neovim-ayu",
    variants = { "dark", "light", "mirage" },
    apply = function(variant, transparency)
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
      vim.o.background = variant == "light" and "light" or "dark"
      vim.cmd.colorscheme("ayu")
    end,
  },

  dracula = {
    repo = "Mofiqul/dracula.nvim",
    variants = {},
    apply = function(_, transparency)
      require("dracula").setup({
        transparent_bg = transparency > 0,
        italic_comment = true,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },

  ["monokai-pro"] = {
    repo = "loctvl842/monokai-pro.nvim",
    variants = { "pro", "octagon", "machine", "ristretto", "spectrum", "classic" },
    apply = function(variant, transparency)
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
        filter = variant or "pro",
      })
      vim.cmd.colorscheme("monokai-pro")
    end,
  },

  onedark = {
    repo = "olimorris/onedarkpro.nvim",
    variants = { "onedark", "onelight", "onedark_vivid", "onedark_dark" },
    apply = function(variant, transparency)
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
      vim.cmd.colorscheme(variant or "onedark")
    end,
  },

  material = {
    repo = "marko-cerovac/material.nvim",
    variants = { "darker", "lighter", "oceanic", "palenight", "deep ocean" },
    apply = function(variant, transparency)
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
      vim.g.material_style = variant or "darker"
      vim.cmd.colorscheme("material")
    end,
  },

  melange = {
    repo = "savq/melange-nvim",
    variants = {},
    apply = function(_, transparency)
      if transparency > 0 then
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = vim.api.nvim_create_augroup("meowvim-melange-transparency", { clear = true }),
          pattern = "melange",
          callback = function()
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
          end,
        })
      end
      vim.cmd.colorscheme("melange")
    end,
  },

  github = {
    repo = "projekt0n/github-nvim-theme",
    variants = {
      "github_dark",
      "github_dark_dimmed",
      "github_dark_high_contrast",
      "github_light",
      "github_light_high_contrast",
    },
    apply = function(variant, transparency)
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
      vim.cmd.colorscheme(variant or "github_dark")
    end,
  },
}

-- Current transparency level from the user config (0 when unavailable).
function M.transparency()
  local ok, config = pcall(require, "meowvim.config")
  return ok and config.get("ui.transparency", 0) or 0
end

-- lazy.nvim plugin name for a theme (used to load it on demand).
function M.plugin_name(name)
  local theme = M.themes[name]
  if not theme then
    return nil
  end
  return theme.name or theme.repo:match("[^/]+$")
end

-- Apply a theme by name. Inactive themes are installed but not loaded, so pull
-- the plugin in first: several themes are plain colorschemes with no Lua module
-- for lazy.nvim's `require` hook to trigger on.
function M.apply(name, variant)
  local theme = M.themes[name]
  if not theme then
    return false
  end

  local plugin = M.plugin_name(name)
  if plugin then
    pcall(function()
      require("lazy").load({ plugins = { plugin } })
    end)
  end

  local ok, err = pcall(theme.apply, variant, M.transparency())
  if not ok then
    vim.notify(
      string.format("Failed to apply theme %s: %s", name, tostring(err)),
      vim.log.levels.ERROR,
      { title = "Meowvim" }
    )
    return false
  end
  return true
end

-- Variant list for a theme (empty table when the theme has no variants).
function M.variants(name)
  local theme = M.themes[name]
  return theme and theme.variants or {}
end

-- Theme names, sorted.
function M.names()
  local names = vim.tbl_keys(M.themes)
  table.sort(names)
  return names
end

return M
