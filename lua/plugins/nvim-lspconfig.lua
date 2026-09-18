-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-lspconfig.lua
-- @brief: Language Server Protocol (LSP) client configuration and setup.
-- @requires: Neovim >= 0.12 (uses vim.lsp.config() and vim.lsp.enable() APIs)

return {
  "neovim/nvim-lspconfig",
  version = "v2.*", -- v2 deprecates .setup(); we use vim.lsp.config() + vim.lsp.enable() directly
  lazy = false,
  dependencies = {
    "saghen/blink.cmp",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    local is_ci = vim.env.CI or vim.env.DOCKER or vim.fn.filereadable("/.dockerenv") == 1
    if is_ci then
      vim.notify("Skipping LSP setup in CI/container environment", vim.log.levels.INFO)
      return
    end

    -- Float borders come from `vim.o.winborder` (see lua/config/options.lua);
    -- Neovim 0.12 applies it to every floating window, so hover and signature
    -- help need no per-handler border config of their own.
    local config_ok, config = pcall(require, "meowvim.config")
    local diagnostics = (config_ok and config.get("lsp.diagnostics", nil)) or {}

    vim.diagnostic.config({
      virtual_text = diagnostics.virtual_text ~= false and { prefix = "", spacing = 2 } or false,
      underline = diagnostics.underline ~= false,
      update_in_insert = diagnostics.update_in_insert == true,
      severity_sort = true,
      signs = diagnostics.signs ~= false and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.HINT] = "󰌶",
          [vim.diagnostic.severity.INFO] = "󰋼",
        },
      } or false,
      float = {
        source = "if_many",
        header = "",
        prefix = "",
      },
    })

    local caps = require("blink.cmp").get_lsp_capabilities()
    caps.textDocument.semanticTokens =
      vim.tbl_deep_extend("force", caps.textDocument.semanticTokens or {}, { dynamicRegistration = true })

    -- `vim.g.inlay_hints_enabled` is owned by utils.toggles (<leader>oi) and
    -- seeded from `toggles.inlay_hints` in the user config, so honour it here
    -- instead of switching hints on for every buffer that supports them.
    local on_attach = function(client, bufnr)
      if client.server_capabilities.inlayHintProvider and vim.g.inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    vim.api.nvim_create_user_command("LspOrganize", function()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })
      if #clients == 0 then
        vim.notify("No TypeScript LSP client attached to current buffer", vim.log.levels.WARN)
        return
      end

      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "Organize Imports",
      }

      clients[1]:request("workspace/executeCommand", params, function(err, _)
        if err then
          vim.notify("Error organizing imports: " .. vim.inspect(err), vim.log.levels.ERROR)
        end
      end, 0)
    end, { desc = "Organize Imports (TypeScript/JavaScript)", force = true })

    local server_settings = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      },
      bashls = {
        filetypes = { "sh", "bash", "zsh" },
      },
      gopls = {
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { "go.work", "go.mod", ".git" })
          on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
        end,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticTokens = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = { analysis = { typeCheckingMode = "basic" } },
        },
      },
      ts_ls = {
        -- <leader>co is mapped globally in lua/config/keymaps.lua and checks the
        -- filetype itself, so no buffer-local mapping is needed here.
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      },
      html = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
      cssls = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
      emmet_ls = {},
      marksman = {},
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
            format = { enable = true },
          },
        },
      },
      dockerls = {},
      docker_compose_language_service = {},
      ltex = {
        settings = {
          ltex = {
            language = "en-US",
          },
        },
      },
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = true,
            },
            forwardSearch = {
              executable = "open",
              args = { "-a", "Skim", "%p" },
            },
            chktex = {
              onOpenAndSave = true,
            },
            lint = {
              onChange = true,
            },
          },
        },
      },
      postgres_lsp = {},
    }

    local common_root_markers = {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      "pyproject.toml",
      "setup.py",
      "requirements.txt",
      "go.mod",
      "Cargo.toml",
      "pom.xml",
      "build.gradle",
      ".git",
    }

    -- lspconfig v2 ships server definitions in its own lsp/ directory which
    -- Neovim 0.12 auto-discovers. We only supply overrides; cmd/filetypes come
    -- from lspconfig's bundled defaults automatically.
    local function setup_server(server_name)
      local server_opts = vim.tbl_deep_extend("force", {}, server_settings[server_name] or {})
      -- Resolve binary: prefer explicit cmd override, fall back to lspconfig bundled default.
      -- vim.lsp.config[name] is available in Neovim 0.12 after rtp is set by lazy.nvim.
      local cmd = server_opts.cmd
      if not cmd then
        local default = vim.lsp.config[server_name]
        cmd = default and default.cmd
      end
      -- Skip silently when binary is missing. Function-type cmd (e.g. ts_ls) manages itself.
      if type(cmd) == "table" and cmd[1] and vim.fn.executable(cmd[1]) == 0 then
        return
      end
      local custom_on_attach = server_opts.on_attach

      server_opts.capabilities = vim.tbl_deep_extend("force", {}, caps, server_opts.capabilities or {})
      server_opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if custom_on_attach then
          custom_on_attach(client, bufnr)
        end
      end
      server_opts.root_markers = server_opts.root_markers or common_root_markers

      vim.lsp.config(server_name, server_opts)
      vim.lsp.enable(server_name)
    end

    for server_name, _ in pairs(server_settings) do
      setup_server(server_name)
    end

    -- GDScript uses a TCP server started by Godot rather than a spawned process
    vim.lsp.config("gdscript", {
      root_markers = { "project.godot", ".git" },
      capabilities = caps,
      on_attach = on_attach,
    })
    vim.lsp.enable("gdscript")
  end,
}
