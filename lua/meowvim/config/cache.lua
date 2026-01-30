-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/cache.lua
-- @brief: Configuration caching system.

local M = {}

local function get_cache_dir()
  return vim.fn.stdpath("state") .. "/meowvim"
end

local function get_cache_file()
  return get_cache_dir() .. "/config_cache.lua"
end

local function get_cache_mtime()
  local stat = vim.loop.fs_stat(get_cache_file())
  return stat and stat.mtime.sec or 0
end

local function get_source_mtime(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.mtime.sec or 0
end

function M.is_valid(source_path)
  local cache_time = get_cache_mtime()
  local source_time = get_source_mtime(source_path)
  return cache_time > 0 and cache_time >= source_time
end

function M.load()
  local cache_file = get_cache_file()
  if vim.fn.filereadable(cache_file) == 0 then
    return nil
  end

  local ok, cached = pcall(dofile, cache_file)
  if not ok then
    return nil
  end

  return cached
end

function M.save(config)
  local cache_dir = get_cache_dir()
  local cache_file = get_cache_file()
  
  vim.fn.mkdir(cache_dir, "p")

  local serialized = "return " .. vim.inspect(config)

  local file = io.open(cache_file, "w")
  if file then
    file:write(serialized)
    file:close()
    return true
  end

  return false
end

function M.clear()
  local cache_file = get_cache_file()
  if vim.fn.filereadable(cache_file) == 1 then
    vim.fn.delete(cache_file)
  end
end

return M
