-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-lspconfig.lua
-- @brief: Language Server Protocol (LSP) client configuration and setup.

local mason_registry = require("config.mason")

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
    "b0o/SchemaStore.nvim",
    "mason-org/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local ok_lspkind, lspkind = pcall(require, "lspkind")
    if ok_lspkind then
      lspkind.init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end

    local mason = require("mason")
    mason.setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "󰄬",
          package_pending = "󰪠",
          package_uninstalled = "󰅘",
        },
      },
    })

    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

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

    local registry_ok, registry = pcall(require, "mason-registry")
    local optional_servers = {
      postgres_lsp = true,
    }

    local function package_supported(name)
      if not registry_ok then
        return true
      end

      if not registry.has_package(name) then
        return false
      end

      local ok_pkg, pkg = pcall(registry.get_package, name)
      if not ok_pkg then
        return false
      end

      if pkg.is_supported then
        local ok_supported, supported = pcall(pkg.is_supported, pkg)
        if ok_supported then
          return supported
        end
      end

      return true
    end

    local icons = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋼" }
    for type, icon in pairs(icons) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    local caps = vim.lsp.protocol.make_client_capabilities()
    caps.textDocument.semanticTokens = { dynamicRegistration = true }
    caps = require("cmp_nvim_lsp").default_capabilities(caps)

    local on_attach = function(client, bufnr)
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- Code lens disabled globally
      -- if client.server_capabilities.codeLensProvider then
      --   vim.lsp.codelens.refresh()
      --   vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      --     buffer = bufnr,
      --     callback = vim.lsp.codelens.refresh,
      --   })
      -- end
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
        title = "",
      }
      vim.lsp.buf_request(0, "workspace/executeCommand", params)
    end, { desc = "Organize Imports", force = true })

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
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = { checkOnSave = { command = "clippy" } },
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
          vim.keymap.set("n", "<leader>co", "<cmd>LspOrganize<CR>", { buffer = bufnr })
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

    local ensure_servers = {}
    for server, _ in pairs(server_settings) do
      if not optional_servers[server] or package_supported(server) then
        table.insert(ensure_servers, server)
      end
    end

    mason_registry.ensure_servers(ensure_servers)

    if package_supported("roslyn") then
      mason_registry.ensure_servers({ "roslyn" })
    end

    mason_lspconfig.setup({
      ensure_installed = ensure_servers,
      automatic_installation = false,
    })

    local function setup_server(server_name)
      if optional_servers[server_name] and not package_supported(server_name) then
        return
      end

      local server_opts = vim.tbl_deep_extend("force", {}, server_settings[server_name] or {})
      local custom_on_attach = server_opts.on_attach

      server_opts.capabilities = vim.tbl_deep_extend("force", {}, caps, server_opts.capabilities or {})
      server_opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if custom_on_attach then
          custom_on_attach(client, bufnr)
        end
      end

      vim.lsp.config(server_name, server_opts)
      vim.lsp.enable(server_name)
    end

    if mason_lspconfig.setup_handlers then
      mason_lspconfig.setup_handlers({
        function(server_name)
          setup_server(server_name)
        end,
      })
    else
      for _, server_name in ipairs(ensure_servers) do
        setup_server(server_name)
      end
    end

    vim.lsp.config("gdscript", {
      capabilities = caps,
      on_attach = on_attach,
    })
    vim.lsp.enable("gdscript")

    if package_supported("roslyn") then
      vim.lsp.config("roslyn", {
        on_attach = on_attach,
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      vim.lsp.enable("roslyn")
    end

    mason_tool_installer.setup({
      ensure_installed = mason_registry.get_all_tools(),
      auto_update = false,
      run_on_start = false,
      start_delay = 0,
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = true,
      },
    })
  end,
}
