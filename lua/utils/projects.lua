-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/projects.lua
-- @brief: Machine-specific project configuration loader.
-- Reads project settings from ~/.meowvim.yaml

local M = {}

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
        -- Check for new project entry (starts with -)
        local path = line:match("^%s*%-%s*path:%s*[\"']?([^\"']+)[\"']?%s*$")
        if path then
          current_project = { path = vim.fn.expand(path) }
          table.insert(result.projects, current_project)
        else
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

  return result
end

-- Load projects config from ~/.meowvim.yaml
function M.load_config()
  local config_path = vim.fn.expand("~/.meowvim.yaml")
  local file = io.open(config_path, "r")

  if not file then
    return { projects = {} }
  end

  local content = file:read("*all")
  file:close()

  local ok, config = pcall(parse_yaml, content)
  if not ok then
    vim.notify("Error parsing ~/.meowvim.yaml: " .. tostring(config), vim.log.levels.WARN)
    return { projects = {} }
  end

  return config
end

-- Get theme for a given directory path
function M.get_theme_for_path(path)
  local config = M.load_config()
  local expanded_path = vim.fn.expand(path)

  for _, project in ipairs(config.projects) do
    local project_path = vim.fn.expand(project.path)
    -- Check if path starts with project path
    if expanded_path:find(project_path, 1, true) == 1 then
      return project.theme
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
      catppuccin.setup({ flavour = theme })
      vim.cmd.colorscheme("catppuccin")
    end
  end
end

-- Apply theme for current working directory
function M.apply_theme_for_cwd()
  M.apply_theme_for_path(vim.fn.getcwd())
end

-- Get project paths for snacks picker integration
function M.get_project_paths()
  local config = M.load_config()
  local paths = {}
  for _, project in ipairs(config.projects) do
    table.insert(paths, vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"))
  end
  return paths
end

-- Get project config for a given path
function M.get_project_for_path(path)
  local config = M.load_config()
  local expanded_path = vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")

  for _, project in ipairs(config.projects) do
    local project_path = vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"):gsub("/$", "")
    if expanded_path == project_path or expanded_path:find(project_path, 1, true) == 1 then
      return project
    end
  end

  return nil
end

-- Run command for a given project path (e.g., "Roslyn start")
function M.run_command_for_path(path)
  local project = M.get_project_for_path(path)
  if project and project.command then
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
