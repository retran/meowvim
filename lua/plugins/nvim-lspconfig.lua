-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @brief: Language Server Protocol (LSP) client configuration and setup.
-- @author: Andrew Vasilyev
-- @license: MIT
--

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
    vim.deprecate = function(...) end

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
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

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
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        })
      end
    end

    vim.api.nvim_create_user_command("LspOrganize", function()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })
      if #clients == 0 then
        vim.notify("No TypeScript LSP client attached to current buffer", vim.log.levels.WARN)
        return
      end

      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
      })
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
        on_attach = function(client, _)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            vulncheck = "Imports",
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
            codelenses = {
              run_govulncheck = true,
              gc_details = false,
              test = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              ignoredError = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              asmdecl = true,
              assign = true,
              atomic = true,
              atomicalign = true,
              bools = true,
              buildtag = true,
              cgocall = true,
              composites = true,
              copylocks = true,
              deepequalerrors = true,
              errorsas = true,
              fieldalignment = true,
              findcall = true,
              framepointer = true,
              httpresponse = true,
              ifaceassert = true,
              infertypeargs = true,
              loopclosure = true,
              lostcancel = true,
              nilfunc = true,
              nilness = true,
              printf = true,
              shadow = true,
              sortslice = true,
              stringintconv = true,
              structtag = true,
              testinggoroutine = true,
              tests = true,
              unmarshal = true,
              unreachable = true,
              unusedparams = true,
              unusedresult = true,
              unusedwrite = true,
              useany = true,
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
          vim.keymap.set("n", "<leader>xo", "<cmd>LspOrganize<CR>", {
            buffer = bufnr,
            noremap = true,
            silent = true,
          })
        end,
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "javascript.jsx",
          "typescript.tsx",
        },
        settings = {
          typescript = {
            diagnostics = { enable = true, workspace = true },
            codeActions = { enable = true },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            updateImportsOnFileMove = { enable = true },
          },
          javascript = {
            diagnostics = { enable = true, workspace = true },
            codeActions = { enable = true },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            updateImportsOnFileMove = { enable = true },
          },
        },
      },
      html = {
        filetypes = { "html" },
        init_options = { provideFormatter = false },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
      cssls = {
        settings = {
          css = { validate = true },
          less = { validate = true },
          scss = { validate = true },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
      emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "svelte",
          "typescriptreact",
          "vue",
        },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        },
      },
      marksman = {
        filetypes = { "markdown", "md", "mdx" },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      dockerls = {
        settings = {
          docker = {
            languageserver = {
              formatter = { ignoreMultilineInstructions = true },
            },
          },
        },
      },
      docker_compose_language_service = {
        filetypes = { "yaml.docker-compose", "docker-compose.yaml", "docker-compose.yml" },
      },
      ltex = {
        filetypes = {
          "bib",
          "gitcommit",
          "markdown",
          "md",
          "mdx",
          "plaintex",
          "rst",
          "rnoweb",
          "tex",
        },
        settings = {
          ltex = {
            checkFrequency = "save",
            language = "en-US",
            additionalRules = {
              enablePickyRules = true,
            },
            dictionary = {
              ["en-US"] = {},
            },
          },
        },
      },
      postgres_lsp = {
        filetypes = { "sql", "plpgsql" },
        single_file_support = true,
        settings = {
          postgres_lsp = {
            enabled = true,
          },
        },
      },
    }

    local ensure_servers = vim.tbl_keys(server_settings)
    mason_registry.ensure_servers(ensure_servers)
    mason_registry.ensure_servers({ "roslyn" })

    mason_lspconfig.setup({
      ensure_installed = ensure_servers,
      automatic_installation = false,
    })

    local function setup_server(server_name)
      local server_opts = vim.tbl_deep_extend("force", {}, server_settings[server_name] or {})
      local custom_on_attach = server_opts.on_attach
      server_opts.capabilities = vim.tbl_deep_extend("force", {}, caps, server_opts.capabilities or {})
      server_opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if custom_on_attach then
          custom_on_attach(client, bufnr)
        end
      end
      if lspconfig[server_name] then
        lspconfig[server_name].setup(server_opts)
      end
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

    if vim.fn.executable("nc") == 1 then
      lspconfig.gdscript.setup({
        capabilities = caps,
        cmd = { "nc", "localhost", "6005" },
        filetypes = { "gd", "gdscript", "gdscript3" },
        root_dir = util.root_pattern("project.godot", ".git"),
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end

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
