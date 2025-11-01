-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/mason.lua
-- @brief: Shared registry for tooling managed by Mason.

local M = {
  servers = {},
  formatters = {},
  linters = {},
  debuggers = {},
}

local function extend(target, items)
  if not items then return end
  for _, item in ipairs(items) do
    if type(item) == "string" and not vim.tbl_contains(target, item) then
      table.insert(target, item)
    end
  end
end

function M.ensure_servers(items)
  extend(M.servers, items)
end

function M.ensure_formatters(items)
  extend(M.formatters, items)
end

function M.ensure_linters(items)
  extend(M.linters, items)
end

function M.ensure_debuggers(items)
  extend(M.debuggers, items)
end

function M.get_all_tools()
  local aggregated = {}
  extend(aggregated, M.servers)
  extend(aggregated, M.formatters)
  extend(aggregated, M.linters)
  extend(aggregated, M.debuggers)
  table.sort(aggregated)
  return aggregated
end

return M
