-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/profiler.lua
-- @brief: Performance profiling and analysis tools

local M = {}

-- Profile a function execution
function M.profile_function(fn, iterations)
  iterations = iterations or 100
  local times = {}

  for i = 1, iterations do
    local start = vim.loop.hrtime()
    fn()
    local elapsed = (vim.loop.hrtime() - start) / 1000000 -- Convert to ms
    table.insert(times, elapsed)
  end

  -- Calculate statistics
  table.sort(times)
  local total = 0
  for _, t in ipairs(times) do
    total = total + t
  end

  local stats = {
    min = times[1],
    max = times[#times],
    avg = total / #times,
    median = times[math.floor(#times / 2)],
    p95 = times[math.floor(#times * 0.95)],
    p99 = times[math.floor(#times * 0.99)],
  }

  return stats
end

-- Start profiling
function M.start()
  vim.cmd("profile start /tmp/nvim-profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
  vim.notify("Profiling started. Output: /tmp/nvim-profile.log", vim.log.levels.INFO)
end

-- Stop profiling
function M.stop()
  vim.cmd("profile stop")
  vim.notify("Profiling stopped. View results: :edit /tmp/nvim-profile.log", vim.log.levels.INFO)
end

-- Show plugin load times
function M.show_plugin_times()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    vim.notify("lazy.nvim not loaded", vim.log.levels.ERROR)
    return
  end

  local stats = lazy.stats()
  local plugins = lazy.plugins()

  -- Collect load times
  local plugin_times = {}
  for _, plugin in ipairs(plugins) do
    if plugin._.loaded then
      local time = plugin._.loaded.time or 0
      table.insert(plugin_times, {
        name = plugin.name,
        time = time,
      })
    end
  end

  -- Sort by time
  table.sort(plugin_times, function(a, b)
    return a.time > b.time
  end)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, "Plugin Load Times")

  -- Build content
  local lines = {
    "# Plugin Load Times",
    "",
    string.format("Total plugins: %d", stats.count),
    string.format("Loaded plugins: %d", stats.loaded),
    string.format("Total startup time: %.2fms", stats.startuptime),
    "",
    "## Top 20 Slowest Plugins",
    "",
  }

  for i = 1, math.min(20, #plugin_times) do
    local p = plugin_times[i]
    table.insert(lines, string.format("%2d. %-40s %6.2fms", i, p.name, p.time))
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

-- Measure current buffer rendering performance
function M.measure_buffer_render()
  local start = vim.loop.hrtime()
  vim.cmd("redraw!")
  local elapsed = (vim.loop.hrtime() - start) / 1000000

  vim.notify(string.format("Buffer render time: %.2fms", elapsed), vim.log.levels.INFO)
  return elapsed
end

-- Register commands
vim.api.nvim_create_user_command("ProfileStart", function()
  M.start()
end, { desc = "Start profiling" })

vim.api.nvim_create_user_command("ProfileStop", function()
  M.stop()
end, { desc = "Stop profiling" })

vim.api.nvim_create_user_command("MeowvimProfile", function()
  M.show_plugin_times()
end, { desc = "Show plugin load times" })

vim.api.nvim_create_user_command("MeasureRender", function()
  M.measure_buffer_render()
end, { desc = "Measure buffer render time" })

-- Keymaps
vim.keymap.set("n", "<leader>oPs", M.start, { desc = "Start Profiling" })
vim.keymap.set("n", "<leader>oPe", M.stop, { desc = "Stop Profiling" })
vim.keymap.set("n", "<leader>oPl", M.show_plugin_times, { desc = "Plugin Load Times" })
vim.keymap.set("n", "<leader>oPr", M.measure_buffer_render, { desc = "Measure Render Time" })

return M
