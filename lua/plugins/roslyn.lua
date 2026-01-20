-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

return {
  "seblyng/roslyn.nvim",
  init = function()
    require("config.mason").ensure_servers({ "roslyn" })
  end,
  opts = {
    exe = "roslyn",
  },
  config = function(_, opts)
    local exe = opts.exe or "roslyn"

    local ok, mason_registry = pcall(require, "mason-registry")
    if ok then
      local ok_pkg, pkg = pcall(mason_registry.get_package, "roslyn")
      if ok_pkg and pkg:is_installed() then
        local install_path = pkg:get_install_path()
        if install_path and install_path ~= "" then
          local mason_exe = install_path .. "/bin/" .. exe
          local candidates = { mason_exe }
          local is_windows = vim.loop and vim.loop.os_uname and vim.loop.os_uname().sysname == "Windows_NT"
          if is_windows then
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

    opts.exe = exe
    require("roslyn").setup(opts)
  end,
}
