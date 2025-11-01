-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: lua/config/mason.lua
-- @brief: Shared registry for tooling managed by Mason.
-- @author: Andrew Vasilyev
-- @license: MIT
--

local M = {
  servers = {},
  formatters = {},
  linters = {},
  debuggers = {},
}

local function extend(target, items)
  if not items then
    return
  end

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

