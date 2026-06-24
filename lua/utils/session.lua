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

-- True when nvim was launched with no file arguments in an interactive TUI,
-- i.e. exactly the situation where the dashboard would normally appear.
local function fresh_interactive_start()
  if vim.fn.argc(-1) ~= 0 then
    return false
  end
  if vim.api.nvim_buf_get_name(0) ~= "" then
    return false -- started with +cmd or an explicit buffer name
  end
  local uis = vim.api.nvim_list_uis()
  if #uis == 0 then
    return false -- headless
  end
  if uis[1].stdout_tty and not uis[1].stdin_tty then
    return false -- input is piped in
  end
  return true
end

-- Path of an existing session file for the current cwd, or nil. Mirrors
-- persistence.load(): branch-aware name first, branch-less name as fallback.
local function existing_session_file()
  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return nil
  end
  local file = persistence.current()
  if vim.fn.filereadable(file) ~= 0 then
    return file
  end
  file = persistence.current({ branch = false })
  if vim.fn.filereadable(file) ~= 0 then
    return file
  end
  return nil
end

-- The meowvim project (from ~/.config/meowvim/projects.lua) matching the
-- current cwd, if any.
local function current_project()
  local ok, cfg = pcall(require, "meowvim.config")
  if not ok then
    return nil
  end
  return cfg.detect_current_project()
end

-- Whether a saved session exists for the current cwd.
function M.has_session()
  return existing_session_file() ~= nil
end

-- Decide whether, on a fresh start, we should open a saved session / project
-- instead of the dashboard. True only when there is a concrete thing to
-- restore: a saved session, or a configured project with an on_open command.
function M.should_auto_restore()
  if not fresh_interactive_start() then
    return false
  end
  if M.has_session() then
    return true
  end
  local project = current_project()
  if project and project.on_open then
    return true
  end
  return false
end

-- Open the saved session and/or run the project's on_open command. Returns
-- true when something was restored. Intended to run on VimEnter.
function M.auto_restore()
  if not M.should_auto_restore() then
    return false
  end

  local restored = false
  if M.has_session() then
    restored = M.load()
  end

  local project = current_project()
  if project and project.on_open then
    vim.defer_fn(function()
      pcall(vim.cmd, project.on_open)
    end, restored and 150 or 50)
  end

  return true
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
