-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-cmp.lua
-- @brief: Completion engine — blink.cmp v1 (replaces nvim-cmp).
--
-- KEYMAPS (insert mode):
--   <C-j>      select next item
--   <C-k>      select prev item
--   <C-l>      accept Copilot inline suggestion if visible, else selected item
--   <C-b>      scroll docs up
--   <C-f>      scroll docs down
--   <C-Space>  trigger completion
--   <Tab>      jump to next snippet placeholder
--   <S-Tab>    jump to previous snippet placeholder
--   <CR>       newline (never auto-accepts)
--   <Esc>      dismiss Copilot inline suggestion (stay in insert), else hide
--              blink menu and exit insert
--
-- Copilot inline suggestions (copilot.lua) coexist with blink-copilot source:
-- hide_during_completion=true hides the overlay while the menu is open;
-- <C-l> and <Esc> handle the overlay when the menu is closed.

return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
    "onsails/lspkind.nvim",
    "saecki/crates.nvim",
    "ribru17/blink-cmp-spell",
  },
  opts = function()
    local lspkind = require("lspkind")

    return {
      snippets = { preset = "luasnip" },

      keymap = {
        preset = "none",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-l>"] = { function(cmp)
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok and suggestion.is_visible() then
            suggestion.accept()
            return true
          end
          return cmp.accept()
        end },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = { "fallback" },
        ["<Esc>"] = { function(cmp)
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok and suggestion.is_visible() then
            suggestion.dismiss()
            return true  -- stay in insert mode
          end
          cmp.hide()
          return false  -- fall through to exit insert
        end },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "spell", "copilot" },
        per_filetype = {
          lua = { "lazydev", "lsp", "path", "snippets", "buffer", "spell", "copilot" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            opts = { keep_all_entries = false, enable_in_context = function() return vim.opt.spell:get() end },
          },
        },
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = "rounded",
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon, hl = lspkind.symbolic(ctx.kind, { mode = "symbol" })
                  return icon or ctx.kind_icon, hl or ("BlinkCmpKind" .. ctx.kind)
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
      },

      fuzzy = {
        sorts = { "score", "sort_text" },
      },

      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" then
            return { "cmdline", "path" }
          end
          return {}
        end,
      },
    }
  end,

  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}
