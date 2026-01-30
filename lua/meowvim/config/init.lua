-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/init.lua
-- @brief: Configuration loader and manager.

local M = {}

-- Internal state
local _config = nil
local _projects = nil
local _current_project = nil

-- Helper to expand environment variables
local function expand_env(str)
  if type(str) ~= "string" then
    return str
  end
  return str:gsub("%$([%w_]+)", function(var)
    return vim.env[var] or ""
  end):gsub("%${([%w_]+)}", function(var)
    return vim.env[var] or ""
  end)
end

-- Deep merge with env expansion
local function deep_merge(target, source)
  for k, v in pairs(source) do
    if type(v) == "table" and type(target[k]) == "table" then
      deep_merge(target[k], v)
    else
      target[k] = type(v) == "string" and expand_env(v) or v
    end
  end
  return target
end

-- Load user configuration
local function load_user_config()
  local config_path = vim.fn.expand("~/.config/meowvim/config.lua")

  -- Check cache first
  local cache = require("meowvim.config.cache")
  if cache.is_valid(config_path) then
    local cached = cache.load()
    if cached then
      return cached
    end
  end

  -- Load from file
  if vim.fn.filereadable(config_path) == 1 then
    local ok, user_config = pcall(dofile, config_path)
    if ok and type(user_config) == "table" then
      -- Save to cache
      cache.save(user_config)
      return user_config
    elseif not ok then
      vim.notify(
        "Error loading config: " .. tostring(user_config),
        vim.log.levels.ERROR,
        { title = "Meowvim" }
      )
    end
  end

  return nil
end

-- Load projects configuration
local function load_projects_config()
  local projects_path = vim.fn.expand("~/.config/meowvim/projects.lua")

  if vim.fn.filereadable(projects_path) == 1 then
    local ok, projects = pcall(dofile, projects_path)
    if ok and type(projects) == "table" then
      return projects
    elseif not ok then
      vim.notify(
        "Error loading projects: " .. tostring(projects),
        vim.log.levels.WARN,
        { title = "Meowvim" }
      )
    end
  end

  return {}
end

-- Initialize configuration
function M.init()
  local defaults = require("meowvim.config.defaults").defaults
  local user_config = load_user_config()

  -- Merge user config with defaults
  _config = vim.deepcopy(defaults)
  if user_config then
    deep_merge(_config, user_config)
  end

  -- Validate configuration
  local schema = require("meowvim.config.schema")
  local ok, errors = schema.validate(_config)
  if not ok then
    vim.notify(
      "Config validation warnings:\n" .. table.concat(errors, "\n"),
      vim.log.levels.WARN,
      { title = "Meowvim" }
    )
  end

  -- Load projects
  _projects = load_projects_config()

  -- Detect current project
  M.detect_current_project()

  return _config
end

-- Get configuration value
function M.get(key, default)
  if not _config then
    M.init()
  end

  if not key then
    return _config
  end

  -- Handle nested keys (e.g., "core.theme")
  local keys = vim.split(key, ".", { plain = true })
  local value = _config

  for _, k in ipairs(keys) do
    if type(value) == "table" then
      value = value[k]
    else
      return default
    end
  end

  return value ~= nil and value or default
end

-- Set configuration value (runtime only, doesn't persist)
function M.set(key, value)
  if not _config then
    M.init()
  end

  local keys = vim.split(key, ".", { plain = true })
  local target = _config

  for i = 1, #keys - 1 do
    local k = keys[i]
    if type(target[k]) ~= "table" then
      target[k] = {}
    end
    target = target[k]
  end

  target[keys[#keys]] = value
end

-- Apply early settings (before plugins load)
function M.apply_early_settings()
  if not _config then
    M.init()
  end

  -- Apply leader key
  vim.g.mapleader = _config.core.leader_key or " "

  -- Apply editor settings
  if _config.editor then
    vim.opt.tabstop = _config.editor.tabstop
    vim.opt.shiftwidth = _config.editor.indent
    vim.opt.expandtab = _config.editor.expand_tabs
    vim.opt.number = _config.editor.line_numbers
    vim.opt.relativenumber = _config.editor.relative_numbers
    vim.opt.wrap = _config.editor.wrap
  end

  -- Apply UI settings
  if _config.ui then
    vim.opt.cmdheight = _config.ui.cmdheight
    vim.opt.pumheight = _config.ui.pumheight
    if _config.ui.transparency > 0 then
      vim.opt.winblend = _config.ui.transparency
      vim.opt.pumblend = _config.ui.transparency
    end
  end
end

-- Reload configuration
function M.reload()
  -- Clear cache
  require("meowvim.config.cache").clear()

  -- Reload
  _config = nil
  _projects = nil
  M.init()
  M.apply_early_settings()

  return true
end

-- Validate configuration
function M.validate()
  if not _config then
    M.init()
  end

  local schema = require("meowvim.config.schema")
  return schema.validate(_config)
end

-- Get projects
function M.get_projects()
  if not _projects then
    _projects = load_projects_config()
  end
  return _projects
end

-- Get project names
function M.get_project_names()
  local projects = M.get_projects()
  local names = {}
  for name, _ in pairs(projects) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

-- Get current project
function M.current_project()
  return _current_project
end

-- Detect current project based on cwd
function M.detect_current_project()
  local cwd = vim.fn.getcwd()
  local projects = M.get_projects()

  for name, project in pairs(projects) do
    local project_path = expand_env(project.path)
    local expanded_path = vim.fn.expand(project_path)

    if cwd == expanded_path or cwd:find("^" .. vim.pesc(expanded_path)) then
      _current_project = vim.tbl_extend("force", project, { name = name })

      -- Apply project-specific settings (with inheritance)
      if project.inherit ~= false then
        -- Project settings override main config
        if project.theme then
          M.set("core.theme", project.theme)
        end
        if project.variant then
          M.set("core.variant", project.variant)
        end
      end

      return _current_project
    end
  end

  _current_project = nil
  return nil
end

-- Switch to project
function M.switch_project(name)
  local projects = M.get_projects()
  local project = projects[name]

  if not project then
    vim.notify("Project not found: " .. name, vim.log.levels.ERROR, { title = "Meowvim" })
    return false
  end

  local project_path = expand_env(project.path)
  local expanded_path = vim.fn.expand(project_path)

  -- Change directory
  vim.cmd("cd " .. vim.fn.fnameescape(expanded_path))

  -- Detect and apply project settings
  M.detect_current_project()

  -- Run on_open command if specified
  if project.on_open then
    vim.defer_fn(function()
      vim.cmd(expand_env(project.on_open))
    end, 100)
  end

  vim.notify("Switched to project: " .. name, vim.log.levels.INFO, { title = "Meowvim" })
  return true
end

-- Setup file watcher for auto-reload
function M.setup_watcher()
  local watcher = require("meowvim.config.watcher")
  watcher.setup()

  -- Watch config file
  watcher.watch("~/.config/meowvim/config.lua")

  -- Watch projects file
  watcher.watch("~/.config/meowvim/projects.lua")
end

return M
