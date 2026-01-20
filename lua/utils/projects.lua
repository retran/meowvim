-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

local M = {}

local config_cache = nil
local config_mtime = nil

local path_cache = {}
local path_cache_order = {}
local PATH_CACHE_MAX_SIZE = 100

M.command_execution_delay_ms = 200

local function strip_balanced_quotes(str)
  if not str or #str < 2 then
    return str
  end
  local first_char = str:sub(1, 1)
  local last_char = str:sub(-1)
  if (first_char == last_char) and (first_char == '"' or first_char == "'") then
    return str:sub(2, -2)
  end
  return str
end

local function parse_meowvim_config(content)
  local result = { projects = {} }
  local current_project = nil
  local in_projects = false

  for line in content:gmatch("[^\r\n]+") do
    if not line:match("^%s*#") and not line:match("^%s*$") then
      if line:match("^projects:") then
        in_projects = true
      elseif in_projects then
        if line:match("^%s*%-%s*$") or line:match("^%s*%-%s*path:") then
          local path = line:match("^%s*%-%s*path:%s*(.+)%s*$")
          if path then
            path = strip_balanced_quotes(path)
            current_project = { path = vim.fn.expand(path) }
          else
            current_project = {}
          end
          table.insert(result.projects, current_project)
        else
          local path = line:match("^%s*path:%s*(.+)%s*$")
          if path and current_project then
            path = strip_balanced_quotes(path)
            current_project.path = vim.fn.expand(path)
          end
          local theme = line:match("^%s*theme:%s*(.+)%s*$")
          if theme and current_project then
            theme = strip_balanced_quotes(theme)
            current_project.theme = theme
          end
          local command = line:match("^%s*command:%s*(.+)%s*$")
          if command and current_project then
            command = strip_balanced_quotes(command)
            current_project.command = command
          end
        end
      end
    end
  end

  local valid_projects = {}
  for _, project in ipairs(result.projects) do
    if project.path then
      table.insert(valid_projects, project)
    end
  end
  result.projects = valid_projects

  return result
end

function M.load_config()
  local config_path = vim.fn.expand("~/.meowvim.yaml")

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

  local ok, config = pcall(parse_meowvim_config, content)
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

local function evict_oldest_cache_entry()
  if #path_cache_order > 0 then
    local oldest_key = table.remove(path_cache_order, 1)
    path_cache[oldest_key] = nil
  end
end

local function path_matches_project(expanded_path, project_path)
  local real_expanded_path = path_cache[expanded_path]
  if not real_expanded_path then
    if #path_cache_order >= PATH_CACHE_MAX_SIZE then
      evict_oldest_cache_entry()
    end
    real_expanded_path = vim.loop.fs_realpath(expanded_path) or expanded_path
    path_cache[expanded_path] = real_expanded_path
    table.insert(path_cache_order, expanded_path)
  end

  local real_project_path = path_cache[project_path]
  if not real_project_path then
    if #path_cache_order >= PATH_CACHE_MAX_SIZE then
      evict_oldest_cache_entry()
    end
    real_project_path = vim.loop.fs_realpath(project_path) or project_path
    path_cache[project_path] = real_project_path
    table.insert(path_cache_order, project_path)
  end

  local sep = package.config:sub(1, 1)
  return real_expanded_path == real_project_path or
         (real_expanded_path:find(real_project_path, 1, true) == 1 and
          real_expanded_path:sub(#real_project_path + 1, #real_project_path + 1) == sep)
end

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

  return nil
end

function M.get_theme_for_cwd()
  return M.get_theme_for_path(vim.fn.getcwd())
end

function M.apply_theme_for_path(path)
  local theme = M.get_theme_for_path(path)
  if theme and vim.tbl_contains({ "latte", "frappe", "macchiato", "mocha" }, theme) then
    local ok, catppuccin = pcall(require, "catppuccin")
    if ok then
      vim.g.catppuccin_flavour = theme
      vim.cmd.colorscheme("catppuccin-" .. theme)
    end
  end
end

function M.apply_theme_for_cwd()
  M.apply_theme_for_path(vim.fn.getcwd())
end

function M.get_project_paths()
  local config = M.load_config()
  local paths = {}
  for _, project in ipairs(config.projects) do
    if project.path then
      table.insert(paths, (vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"):gsub("/$", "")))
    end
  end
  return paths
end

function M.get_project_for_path(path)
  local config = M.load_config()
  local expanded_path = vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")

  for _, project in ipairs(config.projects) do
    if project.path then
      local project_path = vim.fn.fnamemodify(vim.fn.expand(project.path), ":p"):gsub("/$", "")
      if path_matches_project(expanded_path, project_path) then
        return project
      end
    end
  end

  return nil
end

local allowed_commands = {
  "Roslyn",
  "cd",
  "lcd",
  "tcd",
  "edit",
  "e",
}

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

  rest = rest or ""
  if rest:match("[|!&`\n\r]") then
    return false, "Command contains unsafe separators ('|', '!', '&', '`', or newlines)"
  end

  return true, cmd_prefix
end

function M.run_command_for_path(path)
  local project = M.get_project_for_path(path)
  if project and project.command then
    local ok, info = is_command_allowed(project.command)
    if not ok then
      local msg
      if info == "Empty or non-string command"
        or info == "Unable to parse command prefix"
        or info == "Command contains unsafe separators ('|', '!', '&', '`', or newlines)" then
        msg = string.format("Project command '%s' rejected: %s.", tostring(project.command), info)
      else
        msg = string.format(
          "Command prefix '%s' is not in the whitelist and was blocked for safety.",
          tostring(info)
        )
      end

      vim.notify(msg, vim.log.levels.WARN)
      return
    end

    vim.defer_fn(function()
      vim.cmd(project.command)
    end, M.command_execution_delay_ms)
  end
end

function M.get_projects()
  local config = M.load_config()
  return config.projects
end

return M
