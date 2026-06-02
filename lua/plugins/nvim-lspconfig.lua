-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-lspconfig.lua
-- @brief: Language Server Protocol (LSP) client configuration and setup.
-- @requires: Neovim >= 0.11 (uses vim.lsp.config() and vim.lsp.enable() APIs)

return {
  "neovim/nvim-lspconfig",
  version = "v1.*", -- Pin to stable 1.x releases
  lazy = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    local ok_lspkind, lspkind = pcall(require, "lspkind")
    if ok_lspkind then
      lspkind.init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end

    local is_ci = vim.env.CI or vim.env.DOCKER or vim.fn.filereadable("/.dockerenv") == 1
    if is_ci then
      vim.notify("Skipping LSP setup in CI/container environment", vim.log.levels.INFO)
      return
    end

    vim.diagnostic.config({
      virtual_text = { prefix = "", spacing = 2 },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })

    local catppuccin_lsp_ok, catppuccin_lsp = pcall(require, "catppuccin.integrations.lsp")
    if catppuccin_lsp_ok then
      if type(catppuccin_lsp) == "table" and type(catppuccin_lsp.setup) == "function" then
        catppuccin_lsp.setup()
      elseif type(catppuccin_lsp) == "function" then
        catppuccin_lsp()
      end
    end

    local icons = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋼" }
    for type, icon in pairs(icons) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    local caps = require("cmp_nvim_lsp").default_capabilities()
    caps.textDocument.semanticTokens =
      vim.tbl_deep_extend("force", caps.textDocument.semanticTokens or {}, { dynamicRegistration = true })

    local on_attach = function(client, bufnr)
      if client.server_capabilities.inlayHintProvider then
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
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.keymap.set("n", "<leader>co", "<cmd>LspOrganize<CR>", { buffer = bufnr, desc = "Organize Imports" })
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

    local lspconfig = require("lspconfig")

    local function setup_server(server_name)
      local server = lspconfig[server_name]
      if not server or not server.document_config then
        vim.notify(string.format("LSP server '%s' not found in lspconfig", server_name), vim.log.levels.WARN)
        return
      end

      local default_config = server.document_config.default_config or {}
      local server_opts = vim.tbl_deep_extend("force", {}, server_settings[server_name] or {})
      local custom_on_attach = server_opts.on_attach

      server_opts.capabilities = vim.tbl_deep_extend("force", {}, caps, server_opts.capabilities or {})

      server_opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if custom_on_attach then
          custom_on_attach(client, bufnr)
        end
      end

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

      local final_config = vim.tbl_deep_extend("force", {
        cmd = default_config.cmd,
        filetypes = default_config.filetypes,
        root_markers = common_root_markers,
      }, server_opts)

      vim.lsp.config(server_name, final_config)
      vim.lsp.enable(server_name)
    end

    for server_name, _ in pairs(server_settings) do
      setup_server(server_name)
    end

    do
      if lspconfig.gdscript and lspconfig.gdscript.document_config then
        local default_config = lspconfig.gdscript.document_config.default_config or {}
        vim.lsp.config("gdscript", {
          cmd = default_config.cmd,
          filetypes = default_config.filetypes,
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { "project.godot", ".git" })
            on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
          end,
          capabilities = caps,
          on_attach = on_attach,
        })
        vim.lsp.enable("gdscript")
      end
    end
  end,
}
