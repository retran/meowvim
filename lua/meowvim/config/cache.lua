-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/cache.lua
-- @brief: Configuration caching system.

local M = {}

local cache_dir = vim.fn.stdpath("state") .. "/meowvim"
local cache_file = cache_dir .. "/config_cache.lua"

-- Get cache file modification time
local function get_cache_mtime()
  local stat = vim.loop.fs_stat(cache_file)
  return stat and stat.mtime.sec or 0
end

-- Get source file modification time
local function get_source_mtime(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.mtime.sec or 0
end

-- Check if cache is valid
function M.is_valid(source_path)
  local cache_time = get_cache_mtime()
  local source_time = get_source_mtime(source_path)
  return cache_time > 0 and cache_time >= source_time
end

-- Load from cache
function M.load()
  if vim.fn.filereadable(cache_file) == 0 then
    return nil
  end

  local ok, cached = pcall(dofile, cache_file)
  if not ok then
    return nil
  end

  return cached
end

-- Save to cache
function M.save(config)
  -- Create cache directory
  vim.fn.mkdir(cache_dir, "p")

  -- Serialize config
  local serialized = "return " .. vim.inspect(config)

  -- Write to file
  local file = io.open(cache_file, "w")
  if file then
    file:write(serialized)
    file:close()
    return true
  end

  return false
end

-- Clear cache
function M.clear()
  if vim.fn.filereadable(cache_file) == 1 then
    vim.fn.delete(cache_file)
  end
end

return M
