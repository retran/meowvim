-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-lint.lua
-- @brief: Asynchronous linting engine with multiple linter support.

-- Linters are declared in full and filtered when linting actually runs, not at
-- startup: several nvim-lint names differ from the binary they invoke
-- (`golangcilint` runs `golangci-lint`, `clippy` runs `cargo`), and with
-- project-local mise toolchains a startup snapshot goes stale as soon as the
-- working directory changes.
local linters_by_ft = {
  lua = { "luacheck" },
  python = { "pylint", "mypy" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  go = { "golangcilint" },
  rust = { "clippy" },
  markdown = { "markdownlint" },
  yaml = { "yamllint" },
  json = { "jsonlint" },
  sql = { "sqlfluff" },
  plpgsql = { "sqlfluff" },
  dockerfile = { "hadolint" },
  vim = { "vint" },
  gdscript = { "gdlint" },
}

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local toggles = require("utils.toggles")
    local lint = require("lint")

    local config_ok, config = pcall(require, "meowvim.config")
    local auto_lint = true
    if config_ok then
      auto_lint = config.get("linting.auto_lint", true)
      -- `linting.linters` in the user config replaces the entry for a filetype.
      local user_linters = config.get("linting.linters", nil)
      if type(user_linters) == "table" and not vim.tbl_isempty(user_linters) then
        linters_by_ft = vim.tbl_extend("force", linters_by_ft, user_linters)
      end
    end

    lint.linters_by_ft = linters_by_ft

    -- Only the deltas from nvim-lint's own definitions. Overriding `args`
    -- replaces them wholesale, which is why pylint (`--from-stdin <file>`) and
    -- golangcilint (version-dependent flags) are deliberately left alone.
    lint.linters.markdownlint = vim.tbl_deep_extend("force", lint.linters.markdownlint, {
      args = function()
        local markdownlint_config = vim.fn.expand("~/.markdownlint.json")
        if vim.fn.filereadable(markdownlint_config) == 1 then
          return { "--stdin", "--config", markdownlint_config }
        end
        return { "--stdin" }
      end,
    })

    lint.linters.sqlfluff = vim.tbl_deep_extend("force", lint.linters.sqlfluff, {
      args = { "lint", "--format=json", "--dialect", "postgres", "-" },
    })

    -- A linter is runnable only when its resolved command exists. `cmd` can be
    -- a function (eslint_d looks for a project-local binary), so resolve it
    -- every time rather than caching the answer.
    local function is_runnable(name)
      local ok, linter = pcall(function()
        return lint.linters[name]
      end)
      if not ok or type(linter) ~= "table" then
        return false
      end

      local cmd = linter.cmd
      if type(cmd) == "function" then
        local resolved_ok, resolved = pcall(cmd)
        cmd = resolved_ok and resolved or nil
      end

      return type(cmd) == "string" and vim.fn.executable(cmd) == 1
    end

    local function lint_buffer()
      if vim.g.lint_enabled == false then
        return
      end

      local names = lint.linters_by_ft[vim.bo.filetype]
      if not names then
        return
      end

      local runnable = vim.tbl_filter(is_runnable, names)
      if #runnable > 0 then
        lint.try_lint(runnable)
      end
    end

    if auto_lint then
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = vim.schedule_wrap(lint_buffer),
      })
    end

    toggles.ensure("lint_enabled")

    vim.api.nvim_create_user_command("LintInfo", function()
      local ft = vim.bo.filetype
      local names = lint.linters_by_ft[ft] or {}
      if #names == 0 then
        vim.notify("No linters configured for filetype: " .. ft, vim.log.levels.INFO)
        return
      end

      local lines = { "Linters for " .. ft .. ":" }
      for _, name in ipairs(names) do
        table.insert(lines, string.format("  %s %s", is_runnable(name) and "✓" or "✗", name))
      end
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end, { desc = "Show Linters for Current Filetype" })

    vim.api.nvim_create_user_command("LintToggle", function()
      vim.g.lint_enabled = not vim.g.lint_enabled
      toggles.update("lint_enabled")
      vim.notify("Linting " .. (vim.g.lint_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
    end, { desc = "Toggle Linting" })
  end,
}
