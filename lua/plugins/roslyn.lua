-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/roslyn.lua
-- @brief: Plugin for C# development using Roslyn

return {
  "seblyng/roslyn.nvim",
  init = function()
    require("config.mason").ensure_servers({ "roslyn" })
  end,
  -- Use Mason's roslyn wrapper script
  opts = {
    exe = "roslyn",
  },
  config = function(_, opts)
    -- Resolve the Roslyn executable, preferring Mason's installation if available.
    local exe = opts.exe or "roslyn"

    -- Try to locate Roslyn via Mason's package registry.
    local has_mason, mason_registry = pcall(require, "mason-registry")
    if has_mason then
      local ok, pkg = pcall(mason_registry.get_package, "roslyn")
      if ok and pkg:is_installed() then
        local install_path = pkg:get_install_path()
        if install_path and install_path ~= "" then
          local mason_exe = install_path .. "/bin/" .. exe
          -- Check for executable. On Windows, also check common extensions.
          local candidates = { mason_exe }
          if vim.loop and vim.loop.os_uname and vim.loop.os_uname().sysname == "Windows_NT" then
            table.insert(candidates, mason_exe .. ".exe")
            table.insert(candidates, mason_exe .. ".cmd")
          end
          for _, candidate in ipairs(candidates) do
            if vim.fn.executable(candidate) == 1 then
              exe = candidate
              break
            end
          end
        end
      end
    end

    if vim.fn.executable(exe) ~= 1 then
      vim.notify(
        string.format(
          "[roslyn.nvim] Executable '%s' not found. Install Roslyn via Mason with ':MasonInstall roslyn' or ensure it is on PATH.",
          exe
        ),
        vim.log.levels.ERROR
      )
      return
    end

    -- Update opts so roslyn.nvim uses the resolved executable path.
    opts.exe = exe
    require("roslyn").setup(opts)
  end,
}
