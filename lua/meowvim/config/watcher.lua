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
  -- Clear existing timer
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end

  -- Schedule reload after 500ms
  debounce_timer = vim.defer_fn(function()
    if is_safe_to_reload() then
      perform_reload()
    else
      reload_pending = true
    end
  end, 500)
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
    w:stop()
    w:close()
    watchers[fullpath] = nil
  end
end

-- Stop all watchers
function M.stop_all()
  for _, w in pairs(watchers) do
    w:stop()
    w:close()
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
end

return M
