-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: init.lua
-- @brief: Main Neovim configuration entry point and plugin setup.

vim.loader.enable()

-- Add Mason bin to PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 and not (vim.env.PATH or ""):find(mason_bin, 1, true) then
  local separator = vim.uv.os_uname().sysname:find("Windows") and ";" or ":"
  vim.env.PATH = mason_bin .. separator .. (vim.env.PATH or "")
end

-- Load meowvim configuration system
local config_ok, config = pcall(require, "meowvim.config")
if config_ok then
  config.init()
  config.apply_early_settings()
else
  vim.notify(
    "Failed to load meowvim config: " .. tostring(config),
    vim.log.levels.ERROR,
    { title = "Meowvim" }
  )
  -- Fallback to default leader
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
end

require("config/options")
require("utils.toggles").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },

  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "compiler",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "matchparen",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "optwin",
        "rrhelper",
        "spellfile_plugin",
        "synmenu",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
})

require("utils.hooks").setup()
require("utils.patches").setup()
require("config/keymaps").setup()

-- Setup meowvim commands and file watcher
if config_ok then
  require("meowvim.commands").setup()
  config.setup_watcher()
  
  -- Load meowvim utilities
  require("meowvim.colorscheme_switcher")
  require("meowvim.keymap_checker")
  require("meowvim.profiler")
  require("meowvim.startup_tracker")
  require("meowvim.day_night").setup()
  require("meowvim.day_night_presets").setup()
  require("meowvim.theme_manager").setup()
end
