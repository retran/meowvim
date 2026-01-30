-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/builder.lua
-- @brief: DSL builder pattern for configuration.

local M = {}

-- Internal state
local _config = {}

-- Helper to merge tables
local function merge(target, source)
  for k, v in pairs(source) do
    if type(v) == "table" and type(target[k]) == "table" then
      merge(target[k], v)
    else
      target[k] = v
    end
  end
  return target
end

-- Core settings
function M.core(opts)
  _config.core = _config.core or {}
  merge(_config.core, opts)
  return M
end

-- Editor settings
function M.editor(opts)
  _config.editor = _config.editor or {}
  merge(_config.editor, opts)
  return M
end

-- Performance settings
function M.performance(opts)
  _config.performance = _config.performance or {}
  merge(_config.performance, opts)
  return M
end

-- UI settings
function M.ui(opts)
  _config.ui = _config.ui or {}
  merge(_config.ui, opts)
  return M
end

-- LSP settings
function M.lsp(opts)
  _config.lsp = _config.lsp or {}
  merge(_config.lsp, opts)
  return M
end

-- Formatting settings
function M.formatting(opts)
  _config.formatting = _config.formatting or {}
  merge(_config.formatting, opts)
  return M
end

-- Linting settings
function M.linting(opts)
  _config.linting = _config.linting or {}
  merge(_config.linting, opts)
  return M
end

-- Git settings
function M.git(opts)
  _config.git = _config.git or {}
  merge(_config.git, opts)
  return M
end

-- Session settings
function M.sessions(opts)
  _config.sessions = _config.sessions or {}
  merge(_config.sessions, opts)
  return M
end

-- Snacks settings
function M.snacks(opts)
  _config.snacks = _config.snacks or {}
  merge(_config.snacks, opts)
  return M
end

-- Plugin overrides
function M.plugins(opts)
  _config.plugins = _config.plugins or {}
  merge(_config.plugins, opts)
  return M
end

-- Custom settings
function M.custom(opts)
  _config.custom = _config.custom or {}
  merge(_config.custom, opts)
  return M
end

-- Build final configuration
function M.build()
  local result = vim.deepcopy(_config)
  _config = {} -- Reset for next use
  return result
end

-- Reset builder state
function M.reset()
  _config = {}
  return M
end

return M
