-- SPDX-License-Identifier: MIT
-- Helpers for managing workspace sessions with improved error handling.

local M = {}

local function close_floating_windows()
  local ok, err = pcall(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative and cfg.relative ~= "" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end)
  
  if not ok then
    vim.notify("Error closing floating windows: " .. tostring(err), vim.log.levels.WARN)
  end
end

local function wipe_listed_buffers()
  local ok, err = pcall(function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
  end)
  
  if not ok then
    vim.notify("Error wiping buffers: " .. tostring(err), vim.log.levels.WARN)
  end
end

function M.save()
  local ok, persistence = pcall(require, "persistence")
  if ok then
    local save_ok, err = pcall(persistence.save)
    if not save_ok then
      vim.notify("Failed to save session: " .. tostring(err), vim.log.levels.ERROR)
      return false
    end
    return true
  else
    vim.notify("persistence.nvim not loaded", vim.log.levels.WARN)
    return false
  end
end

function M.load(opts)
  opts = opts or {}
  local ok, persistence = pcall(require, "persistence")
  if ok then
    local load_ok, err = pcall(persistence.load, opts)
    if not load_ok then
      vim.notify("Failed to load session: " .. tostring(err), vim.log.levels.ERROR)
      return false
    end
    return true
  else
    vim.notify("persistence.nvim not loaded", vim.log.levels.WARN)
    return false
  end
end

function M.reset()
  local ok, err = pcall(function()
    close_floating_windows()
    wipe_listed_buffers()

    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd("silent! tabonly")
    end

    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins > 1 then
      vim.cmd("silent! only")
    end

    if #vim.api.nvim_list_bufs() == 0 or not vim.bo.buflisted then
      vim.cmd("enew")
    end
  end)
  
  if not ok then
    vim.notify("Error resetting session: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  return true
end

return M
