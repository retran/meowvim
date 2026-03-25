-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/startup_tracker.lua
-- @brief: Track and analyze Neovim startup times

local M = {}

local metrics_file = vim.fn.stdpath("data") .. "/startup_metrics.json"

-- Record current startup time
function M.record()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    return
  end

  local stats = lazy.stats()
  local metric = {
    timestamp = os.time(),
    startuptime = stats.startuptime,
    plugin_count = stats.count,
    loaded_count = stats.loaded,
  }

  -- Load existing metrics
  local metrics = M.load_metrics()
  table.insert(metrics, metric)

  -- Keep only last 100 entries
  if #metrics > 100 then
    metrics = vim.list_slice(metrics, #metrics - 99, #metrics)
  end

  -- Save metrics
  local ok, json = pcall(vim.json.encode, metrics)
  if ok then
    local file = io.open(metrics_file, "w")
    if file then
      file:write(json)
      file:close()
    end
  end
end

-- Load metrics from file
function M.load_metrics()
  local file = io.open(metrics_file, "r")
  if not file then
    return {}
  end

  local content = file:read("*all")
  file:close()

  local ok, metrics = pcall(vim.json.decode, content)
  if not ok or type(metrics) ~= "table" then
    return {}
  end

  return metrics
end

-- Show startup time trends
function M.show_trends()
  local metrics = M.load_metrics()

  if #metrics == 0 then
    vim.notify("No startup metrics recorded yet", vim.log.levels.INFO)
    return
  end

  -- Calculate statistics
  local times = {}
  for _, m in ipairs(metrics) do
    table.insert(times, m.startuptime)
  end

  table.sort(times)
  local total = 0
  for _, t in ipairs(times) do
    total = total + t
  end

  local avg = total / #times
  local min = times[1]
  local max = times[#times]
  local median = times[math.floor(#times / 2)]
  local latest = metrics[#metrics].startuptime

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, "Startup Trends")

  -- Build content
  local lines = {
    "# Startup Time Trends",
    "",
    string.format("Samples: %d", #metrics),
    "",
    "## Statistics",
    "",
    string.format("Latest:  %.2fms", latest),
    string.format("Average: %.2fms", avg),
    string.format("Median:  %.2fms", median),
    string.format("Min:     %.2fms", min),
    string.format("Max:     %.2fms", max),
    "",
    "## Recent History (last 20)",
    "",
  }

  -- Show last 20 entries
  local start_idx = math.max(1, #metrics - 19)
  for i = #metrics, start_idx, -1 do
    local m = metrics[i]
    local date = os.date("%Y-%m-%d %H:%M:%S", m.timestamp)
    local status = ""
    if m.startuptime < avg then
      status = "✓"
    elseif m.startuptime > avg * 1.5 then
      status = "⚠"
    end
    table.insert(
      lines,
      string.format("%s %s  %.2fms  (%d/%d plugins)", status, date, m.startuptime, m.loaded_count, m.plugin_count)
    )
  end

  -- Set content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  -- Open in split
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

-- Auto-record on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Defer recording to ensure lazy.nvim stats are ready
    vim.defer_fn(function()
      M.record()
    end, 100)
  end,
})

-- Register command
vim.api.nvim_create_user_command("StartupTrends", function()
  M.show_trends()
end, { desc = "Show startup time trends" })

return M
