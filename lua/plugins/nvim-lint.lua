-- lua/plugins/nvim-lint.lua

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    linters_by_ft = {
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
      dockerfile = { "hadolint" },
      vim = { "vint" },
      gdscript = { "gdtoolkit" },
    },

    linters = {
      luacheck = {
        args = { "--globals", "vim", "--read-globals", "love", "--formatter", "plain", "--codes", "--ranges", "-" },
      },
      pylint = {
        args = { "-f", "json", "--disable=C0111", "--disable=C0103" },
      },
      golangcilint = {
        args = {
          "run",
          "--out-format",
          "json",
        },
      },
      markdownlint = {
        args = { "--stdin", "--config", vim.fn.expand("~/.markdownlint.json") },
      },
    },
  },

  config = function(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft or {}

    if opts.linters then
      for linter_name, linter_config in pairs(opts.linters) do
        if lint.linters[linter_name] then
          lint.linters[linter_name] = vim.tbl_deep_extend("force", lint.linters[linter_name], linter_config)
        end
      end
    end

    local lint_callback = vim.schedule_wrap(function()
      if vim.g.lint_enabled ~= false then
        lint.try_lint()
      end
    end)

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = lint_callback,
    })

    vim.api.nvim_create_user_command("LintInfo", function()
      local ft = vim.bo.filetype
      local linters_for_ft = lint.linters_by_ft[ft] or {}
      if #linters_for_ft == 0 then
        vim.notify("No linters configured for filetype: " .. ft, vim.log.levels.INFO)
      else
        vim.notify("Linters for " .. ft .. ": " .. table.concat(linters_for_ft, ", "), vim.log.levels.INFO)
      end
    end, { desc = "Show linters for current filetype" })

    vim.api.nvim_create_user_command("LintToggle", function()
      vim.g.lint_enabled = not vim.g.lint_enabled
      vim.notify("Linting " .. (vim.g.lint_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
    end, { desc = "Toggle linting on/off" })

    vim.g.lint_enabled = true
  end,
}
