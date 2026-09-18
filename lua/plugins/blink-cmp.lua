-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/blink-cmp.lua
-- @brief: Completion engine — blink.cmp v1 (replaces nvim-cmp).
--
-- KEYMAPS (insert mode):
--   <C-j>      select next item
--   <C-k>      select prev item
--   <C-l>      accept Copilot inline suggestion if visible, else selected item
--   <C-u>      scroll docs up
--   <C-d>      scroll docs down
--   <C-Space>  trigger completion
--   <Tab>      jump to next snippet placeholder
--   <S-Tab>    jump to previous snippet placeholder
--   <CR>       newline (never auto-accepts)
--   <Esc>      dismiss Copilot inline suggestion (stay in insert), else hide
--              blink menu and exit insert
--
-- Copilot inline suggestions (copilot.lua) are separate from blink menu:
-- hide_during_completion=true hides the overlay while the menu is open;
-- <C-l> and <Esc> handle the overlay when the menu is closed.

return {
  "saghen/blink.cmp",
  version = "1.*",
  -- Not lazy: nvim-lspconfig needs get_lsp_capabilities() while configuring
  -- servers at startup, so any `event` here would be bypassed anyway. blink
  -- does not register its capabilities through `vim.lsp.config` on its own.
  lazy = false,
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "echasnovski/mini.icons",
    "ribru17/blink-cmp-spell",
  },
  opts = function()
    local mini_icons = require("mini.icons")

    return {
      snippets = { preset = "luasnip" },

      keymap = {
        preset = "none",
        ["<C-j>"] = {
          function()
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.dismiss()
            end
            return false
          end,
          "select_next",
          "fallback",
        },
        ["<C-k>"] = {
          function()
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.dismiss()
            end
            return false
          end,
          "select_prev",
          "fallback",
        },
        ["<C-l>"] = {
          function(cmp)
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.accept()
              return true
            end
            return cmp.accept()
          end,
        },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = { "fallback" },
        ["<Esc>"] = {
          function(cmp)
            local ok, suggestion = pcall(require, "copilot.suggestion")
            local had_inline = ok and suggestion.is_visible()
            if had_inline then
              suggestion.dismiss()
            end
            if cmp.is_visible() then
              cmp.hide()
              return true
            end
            if had_inline then
              return true
            end
            return false
          end,
          "fallback",
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "spell" },
        per_filetype = {
          lua = { "lazydev", "lsp", "path", "snippets", "buffer", "spell" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            opts = {
              keep_all_entries = false,
              enable_in_context = function()
                return vim.opt.spell:get()
              end,
            },
          },
        },
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            components = {
              -- Kind icons come from mini.icons so the completion menu matches
              -- the icons used everywhere else (file explorer, pickers, lualine).
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon, hl = mini_icons.get("lsp", ctx.kind)
                  return icon or ctx.kind_icon, hl or ("BlinkCmpKind" .. ctx.kind)
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },

      -- Window borders come from `vim.o.winborder`; blink falls back to it
      -- whenever `border` is unset (blink/cmp/lib/window/utils.lua).
      signature = {
        enabled = true,
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
