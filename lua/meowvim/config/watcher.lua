-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/config/watcher.lua
-- @brief: File watcher with debounced reload.

local M = {}

local debounce_timer = nil
local reload_pending = false
local watchers = {}

-- Check if safe to reload config
local function is_safe_to_reload()
  -- Don't reload in insert mode
  if vim.fn.mode():match("[iR]") then
    return false
  end

  -- Don't reload if command is running
  if vim.fn.getcmdtype() ~= "" then
    return false
  end

  return true
end

-- Perform reload
local function perform_reload()
  local config = require("meowvim.config")
  local ok, err = pcall(config.reload)

  if ok then
    vim.notify("⚙️  Config reloaded", vim.log.levels.INFO, { title = "Meowvim" })
  else
    vim.notify("❌ Config reload failed: " .. err, vim.log.levels.ERROR, { title = "Meowvim" })
  end

  reload_pending = false
end

-- Debounced reload function
local function schedule_reload()
  -- Clear existing timer using uv timer
  if debounce_timer then
    if not debounce_timer:is_closing() then
      debounce_timer:stop()
      debounce_timer:close()
    end
    debounce_timer = nil
  end

  -- Create new uv timer for proper control
  debounce_timer = vim.loop.new_timer()
  if debounce_timer then
    debounce_timer:start(500, 0, vim.schedule_wrap(function()
      if debounce_timer and not debounce_timer:is_closing() then
        debounce_timer:stop()
        debounce_timer:close()
      end
      debounce_timer = nil
      
      if is_safe_to_reload() then
        perform_reload()
      else
        reload_pending = true
      end
    end))
  end
end

-- Watch a file for changes
function M.watch(filepath, callback)
  local fullpath = vim.fn.expand(filepath)

  if watchers[fullpath] then
    return -- Already watching
  end

  -- Create file watcher
  local w = vim.loop.new_fs_event()
  if not w then
    return
  end

  w:start(
    fullpath,
    {},
    vim.schedule_wrap(function(err, filename, events)
      if err then
        return
      end

      if callback then
        callback(filename, events)
      else
        schedule_reload()
      end
    end)
  )

  watchers[fullpath] = w
end

-- Stop watching a file
function M.unwatch(filepath)
  local fullpath = vim.fn.expand(filepath)
  local w = watchers[fullpath]

  if w then
    if not w:is_closing() then
      w:stop()
      w:close()
    end
    watchers[fullpath] = nil
  end
end

-- Stop all watchers
function M.stop_all()
  -- Stop debounce timer first
  if debounce_timer and not debounce_timer:is_closing() then
    debounce_timer:stop()
    debounce_timer:close()
  end
  debounce_timer = nil
  
  -- Stop all file watchers
  for path, w in pairs(watchers) do
    if w and not w:is_closing() then
      w:stop()
      w:close()
    end
  end
  watchers = {}
end

-- Setup auto-reload on InsertLeave if pending
function M.setup()
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("MeowvimConfigReload", { clear = true }),
    callback = function()
      if reload_pending and is_safe_to_reload() then
        perform_reload()
      end
    end,
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = vim.api.nvim_create_augroup("MeowvimConfigReloadCmd", { clear = true }),
    callback = function()
      if reload_pending and is_safe_to_reload() then
        perform_reload()
      end
    end,
  })
  
  -- Clean up watchers on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("MeowvimConfigWatcherCleanup", { clear = true }),
    callback = function()
      M.stop_all()
    end,
  })
end

return M
