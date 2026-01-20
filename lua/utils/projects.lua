-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/projects.lua
-- @brief: Machine-specific project configuration loader.
-- Reads project settings from ~/.meowvim.yaml

local M = {}

-- Cache for loaded config
local config_cache = nil
local config_mtime = nil

-- Simple YAML parser for our specific format
-- Supports: projects list with path, theme, and command
local function parse_yaml(content)
  local result = { projects = {} }
  local current_project = nil
  local in_projects = false

  for line in content:gmatch("[^\r\n]+") do
    -- Skip comments and empty lines
    if not line:match("^%s*#") and not line:match("^%s*$") then
      -- Check for projects section
      if line:match("^projects:") then
        in_projects = true
      elseif in_projects then
        -- Check for new project entry (starts with - alone or with path)
        if line:match("^%s*%-%s*$") or line:match("^%s*%-%s*path:") then
          local path = line:match("^%s*%-%s*path:%s*[\"']?([^\"']+)[\"']?%s*$")
          if path then
            current_project = { path = vim.fn.expand(path) }
          else
            -- New project entry without path on same line
            current_project = {}
          end
          table.insert(result.projects, current_project)
        else
          -- Check for path property
          local path = line:match("^%s*path:%s*[\"']?([^\"']+)[\"']?%s*$")
          if path and current_project then
            current_project.path = vim.fn.expand(path)
          end
          -- Check for theme property
          local theme = line:match("^%s*theme:%s*[\"']?([^\"']+)[\"']?%s*$")
          if theme and current_project then
            current_project.theme = theme
          end
          -- Check for command property
          local command = line:match("^%s*command:%s*[\"']?([^\"']+)[\"']?%s*$")
          if command and current_project then
            current_project.command = command
          end
        end
      end
    end
  end

  -- Filter out projects without a path (validation requirement)
  local valid_projects = {}
  for _, project in ipairs(result.projects) do
    if project.path then
      table.insert(valid_projects, project)
    end
  end
  result.projects = valid_projects

  return result
end

-- Load projects config from ~/.meowvim.yaml
function M.load_config()
  local config_path = vim.fn.expand("~/.meowvim.yaml")

  -- Check file modification time for cache invalidation
  local mtime = vim.loop.fs_stat(config_path)
  if mtime and config_cache and config_mtime and mtime.mtime.sec == config_mtime then
    return config_cache
  end

  local file = io.open(config_path, "r")

  if not file then
    config_cache = { projects = {} }
    config_mtime = nil
    return config_cache
  end

  local content = file:read("*all")
  file:close()

  local ok, config = pcall(parse_yaml, content)
  if not ok then
    vim.notify("Error parsing ~/.meowvim.yaml: " .. tostring(config), vim.log.levels.WARN)
    config_cache = { projects = {} }
    config_mtime = nil
    return config_cache
  end

  config_cache = config
  config_mtime = mtime and mtime.mtime.sec or nil
  return config
end

-- Helper function to check if a path matches a project path
-- Returns true if the path is within the project directory
local function path_matches_project(expanded_path, project_path)
  local sep = package.config:sub(1, 1)
  return expanded_path == project_path or
         (expanded_path:find(project_path, 1, true) == 1 and
          expanded_path:sub(#project_path + 1, #project_path + 1) == sep)
end

-- Get theme for a given directory path
function M.get_theme_for_path(path)
  local config = M.load_config()
  local expanded_path = vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")

  for _, project in ipairs(config.projects) do
    if project.path then
      local project_path = vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"):gsub("/$", "")
      if path_matches_project(expanded_path, project_path) then
        return project.theme
      end
    end
  end

  return nil -- No matching project, use default
end

-- Get theme for current working directory
function M.get_theme_for_cwd()
  return M.get_theme_for_path(vim.fn.getcwd())
end

-- Apply catppuccin theme for a given path
function M.apply_theme_for_path(path)
  local theme = M.get_theme_for_path(path)
  if theme and vim.tbl_contains({ "latte", "frappe", "macchiato", "mocha" }, theme) then
    local ok, catppuccin = pcall(require, "catppuccin")
    if ok then
      vim.g.catppuccin_flavour = theme
      -- Switch to the desired catppuccin flavor
      vim.cmd.colorscheme("catppuccin-" .. theme)
    end
  end
end

-- Apply theme for current working directory
function M.apply_theme_for_cwd()
  M.apply_theme_for_path(vim.fn.getcwd())
end

-- Get project paths for snacks picker integration
-- Returns absolute normalized paths with trailing slashes for configured projects
function M.get_project_paths()
  local config = M.load_config()
  local paths = {}
  for _, project in ipairs(config.projects) do
    if project.path then
      table.insert(paths, vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"))
    end
  end
  return paths
end

-- Get project config for a given path
function M.get_project_for_path(path)
  local config = M.load_config()
  local expanded_path = vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")

  for _, project in ipairs(config.projects) do
    if not project.path then goto continue end
    local project_path = vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"):gsub("/$", "")
    if path_matches_project(expanded_path, project_path) then
      return project
    end
    ::continue::
  end

  return nil
end

-- Whitelist of allowed command prefixes for security
local allowed_commands = {
  "Roslyn",
  "lua",
  "cd",
  "lcd",
  "tcd",
  "edit",
  "e",
}

-- Validate that a command is allowed and does not chain unsafe extra commands.
-- This checks:
--   1. The first word (command prefix) is in the allowed_commands list.
--   2. The rest of the command does not contain characters like '|' or '!' that
--      can be used to chain additional Vim or shell commands (e.g., "edit | !rm -rf /").
local function is_command_allowed(command)
  if type(command) ~= "string" or command == "" then
    return false, "Empty or non-string command"
  end

  local cmd_prefix, rest = command:match("^(%S+)%s*(.*)$")
  if not cmd_prefix then
    return false, "Unable to parse command prefix"
  end

  local prefix_allowed = false
  for _, allowed in ipairs(allowed_commands) do
    if cmd_prefix == allowed then
      prefix_allowed = true
      break
    end
  end

  if not prefix_allowed then
    return false, cmd_prefix
  end

  -- Disallow chaining additional commands via '|', '!', ';', '&', '`', newlines, or carriage returns.
  -- This prevents constructs like "edit | !rm -rf /" or multiline command injection,
  -- while still allowing arguments like "edit somefile" or "cd /some/path".
  rest = rest or ""
  if rest:match("[|!;&`\n\r]") then
    return false, "Command contains unsafe separators ('|', '!', ';', '&', '`', or newlines)"
  end

  return true, cmd_prefix
end

-- Run command for a given project path (e.g., "Roslyn start")
-- WARNING: Commands from config file should be trusted. Only whitelisted prefixes are allowed.
function M.run_command_for_path(path)
  local project = M.get_project_for_path(path)
  if project and project.command then
    -- Validate command against whitelist and ensure it does not chain extra commands
    local ok, info = is_command_allowed(project.command)
    if not ok then
      local msg
      if info == "Empty or non-string command"
        or info == "Unable to parse command prefix"
        or info == "Command contains unsafe separators ('|', '!', ';', '&', '`', or newlines)" then
        msg = string.format("Project command '%s' rejected: %s.", tostring(project.command), info)
      else
        -- info is treated as the disallowed command prefix
        msg = string.format(
          "Command prefix '%s' is not in the whitelist and was blocked for safety. If you need to allow this command, update your personal Neovim configuration to extend the allowed commands according to how you manage this setup (for example, by forking or customizing this configuration).",
          tostring(info)
        )
      end

      vim.notify(msg, vim.log.levels.WARN)
      return
    end

    -- Defer command execution to ensure it runs after directory change
    -- The 200ms delay allows time for vim to fully process the directory change
    -- and for any autocmds triggered by the change to complete
    vim.defer_fn(function()
      vim.cmd(project.command)
    end, 200)
  end
end

-- Get all configured projects
function M.get_projects()
  local config = M.load_config()
  return config.projects
end

return M
