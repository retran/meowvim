-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/init.lua
-- @brief: Configuration loader and manager.

local M = {}

local _config = nil
local _projects = nil
local _current_project = nil

function M.get_config_dir()
  return vim.env.XDG_CONFIG_HOME and (vim.env.XDG_CONFIG_HOME .. "/meowvim") or vim.fn.expand("~/.config/meowvim")
end

function M.get_config_path()
  return M.get_config_dir() .. "/config.lua"
end

function M.get_projects_path()
  return M.get_config_dir() .. "/projects.lua"
end

local function get_config_dir()
  return M.get_config_dir()
end

local function get_config_path()
  return M.get_config_path()
end

local function get_projects_path()
  return M.get_projects_path()
end

local function create_default_config()
  local config_dir = get_config_dir()
  local config_path = get_config_path()

  if vim.fn.filereadable(config_path) == 1 then
    return
  end

  vim.fn.mkdir(config_dir, "p")

  local default_content = [[-- Meowvim Configuration
-- See :h meowvim-config for full documentation

return {
  core = {
    theme = "catppuccin",
    variant = "mocha",
    enable_copilot = false,
    leader_key = " ",
    update_check = true,
  },

  editor = {
    tabstop = 2,
    indent = 2,
    expand_tabs = true,
    line_numbers = true,
    relative_numbers = true,
    wrap = false,
    auto_save = false,
    format_on_save = true,
  },

  performance = {
    buffer_auto_close = true,
    buffer_threshold = 10,
    startup_dashboard = true,
    lazy_load_plugins = true,
  },

  ui = {
    transparency = 0,
    winbar = true,
    cmdheight = 1,
    pumheight = 10,
    icons = true,
  },
}
]]

  local file = io.open(config_path, "w")
  if file then
    file:write(default_content)
    file:close()
    vim.notify("Created default config at " .. config_path, vim.log.levels.INFO, { title = "Meowvim" })
  end
end

local function expand_env(str)
  if type(str) ~= "string" then
    return str
  end
  return str
    :gsub("%$([%w_]+)", function(var)
      return vim.env[var] or ""
    end)
    :gsub("%${([%w_]+)}", function(var)
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

local function load_user_config()
  create_default_config()

  local config_path = get_config_path()

  local cache = require("meowvim.config.cache")
  if cache.is_valid(config_path) then
    local cached = cache.load()
    if cached then
      return cached
    end
  end

  if vim.fn.filereadable(config_path) == 1 then
    local ok, user_config = pcall(dofile, config_path)
    if ok and type(user_config) == "table" then
      cache.save(user_config)
      return user_config
    elseif not ok then
      vim.notify("Error loading config: " .. tostring(user_config), vim.log.levels.ERROR, { title = "Meowvim" })
    end
  end

  return nil
end

local function validate_project(name, project)
  local issues = {}

  if not project.path then
    table.insert(issues, "missing 'path' field")
  elseif type(project.path) ~= "string" then
    table.insert(issues, "'path' must be a string")
  end

  if project.theme and type(project.theme) ~= "string" then
    table.insert(issues, "'theme' must be a string")
  end

  if project.variant and type(project.variant) ~= "string" then
    table.insert(issues, "'variant' must be a string")
  end

  if project.on_open and type(project.on_open) ~= "string" then
    table.insert(issues, "'on_open' must be a string")
  end

  if project.inherit ~= nil and type(project.inherit) ~= "boolean" then
    table.insert(issues, "'inherit' must be a boolean")
  end

  return #issues == 0, issues
end

local function load_projects_config()
  local projects_path = get_projects_path()

  if vim.fn.filereadable(projects_path) == 1 then
    local ok, projects = pcall(dofile, projects_path)
    if ok and type(projects) == "table" then
      -- Validate each project
      local validated_projects = {}
      for name, project in pairs(projects) do
        if type(project) == "table" then
          local valid, issues = validate_project(name, project)
          if valid then
            validated_projects[name] = project
          else
            vim.notify(
              string.format("Invalid project '%s': %s", name, table.concat(issues, ", ")),
              vim.log.levels.WARN,
              { title = "Meowvim" }
            )
          end
        else
          vim.notify(string.format("Project '%s' must be a table", name), vim.log.levels.WARN, { title = "Meowvim" })
        end
      end
      return validated_projects
    elseif not ok then
      vim.notify("Error loading projects: " .. tostring(projects), vim.log.levels.WARN, { title = "Meowvim" })
    end
  end

  return {}
end

function M.init()
  local defaults = require("meowvim.config.defaults").defaults
  local user_config = load_user_config()

  _config = vim.deepcopy(defaults)
  if user_config then
    deep_merge(_config, user_config)
  end

  -- Validate configuration
  local schema = require("meowvim.config.schema")
  local ok, errors = schema.validate(_config)
  if not ok and #errors > 0 then
    -- Only show critical errors (type mismatches), skip enum warnings
    local critical_errors = {}
    for _, err in ipairs(errors) do
      -- Skip variant enum warnings since variants are theme-specific
      if not err:match("core%..*variant") and not err:match("expected one of") then
        table.insert(critical_errors, err)
      end
    end

    if #critical_errors > 0 then
      vim.schedule(function()
        vim.api.nvim_echo({
          { "⚠ Config validation errors:\n", "WarningMsg" },
          { table.concat(critical_errors, "\n"), "Normal" },
        }, true, {})
      end)
    end
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

-- Get project paths (for snacks picker)
function M.get_project_paths()
  local projects = M.get_projects()
  local paths = {}
  for _, project in pairs(projects) do
    if project.path then
      local project_path = expand_env(project.path)
      local expanded_path = vim.fn.expand(project_path)
      table.insert(paths, expanded_path)
    end
  end
  return paths
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
  watcher.watch(M.get_config_path())

  -- Watch projects file
  watcher.watch(M.get_projects_path())
end

-- Persist current configuration to user config file
function M.persist()
  if not _config then
    M.init()
  end

  local config_path = get_config_path()

  -- Temporarily disable watcher to prevent reload loop
  local watcher_ok, watcher = pcall(require, "meowvim.config.watcher")
  if watcher_ok then
    watcher.unwatch(config_path)
  end

  -- Serialize config to Lua table format
  local function serialize_value(val, indent)
    indent = indent or 0
    local spaces = string.rep("  ", indent)

    if type(val) == "string" then
      return string.format("%q", val)
    elseif type(val) == "number" or type(val) == "boolean" then
      return tostring(val)
    elseif type(val) == "table" then
      local lines = { "{" }
      local keys = vim.tbl_keys(val)
      table.sort(keys, function(a, b)
        -- Sort keys alphabetically, but keep certain keys at top
        local priority = { core = 1, editor = 2, ui = 3, toggles = 4 }
        local pa = priority[a] or 99
        local pb = priority[b] or 99
        if pa ~= pb then
          return pa < pb
        end
        return tostring(a) < tostring(b)
      end)

      for _, k in ipairs(keys) do
        local v = val[k]
        local key_str = type(k) == "string" and k or ("[" .. tostring(k) .. "]")
        table.insert(lines, spaces .. "  " .. key_str .. " = " .. serialize_value(v, indent + 1) .. ",")
      end
      table.insert(lines, spaces .. "}")
      return table.concat(lines, "\n")
    else
      return "nil"
    end
  end

  local content = "-- Meowvim Configuration\n"
  content = content .. "-- See :h meowvim-config for full documentation\n\n"
  content = content .. "return " .. serialize_value(_config, 0) .. "\n"

  -- Write to file
  local file = io.open(config_path, "w")
  if file then
    file:write(content)
    file:close()

    -- Clear cache
    require("meowvim.config.cache").clear()

    -- Re-enable watcher after a short delay
    if watcher_ok then
      vim.defer_fn(function()
        watcher.watch(config_path)
      end, 1000)
    end

    vim.notify("Configuration saved to " .. config_path, vim.log.levels.INFO, { title = "Meowvim" })
    return true
  else
    -- Re-enable watcher on error
    if watcher_ok then
      watcher.watch(config_path)
    end

    vim.notify("Failed to write configuration to " .. config_path, vim.log.levels.ERROR, { title = "Meowvim" })
    return false
  end
end

return M
