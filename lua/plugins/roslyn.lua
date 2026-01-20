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
          -- Prefer the Mason-managed executable if it exists and is usable.
          if vim.fn.filereadable(mason_exe) == 1 or vim.fn.executable(mason_exe) == 1 then
            exe = mason_exe
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
