-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- FINAL CTRL-BASED KEYMAPS (Conflict-checked ✅)
--
-- COMPLETION POPUP (hjkl-based navigation):
--   <C-j>      - Select next item (shows cmp ghost text, dismisses Copilot)
--   <C-k>      - Select prev item (shows cmp ghost text, dismisses Copilot)
--   <C-l>      - Smart accept: Copilot if visible, else selected cmp item
--   <C-b>      - Scroll docs up
--   <C-f>      - Scroll docs down
--   <C-Space>  - Trigger completion manually
--
-- COPILOT (inline gray text, visible only when nothing is selected in cmp):
--   <C-l>      - Accept Copilot suggestion if visible
--   <C-g>      - Accept next word of Copilot suggestion
--   <C-n>      - Next Copilot suggestion
--   <C-p>      - Previous Copilot suggestion
--
-- DISMISS (universal):
--   <Esc>      - Dismiss Copilot suggestion (stay in insert); else dismiss popup + exit insert
--
-- NORMAL BEHAVIOR PRESERVED:
--   <Tab>      - Indent / Expand snippet / Jump placeholder
--   <S-Tab>    - Dedent / Jump back in snippet
--   <CR>       - New line (always)
--
-- Sources (in priority order):
--   1. LSP (language server)
--   2. LuaSnip (snippets)
--   3. Path (file paths)
--   4. Spell (spelling)
--   5. Buffer (current buffer words)

local function get_dependencies()
  local deps = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "saecki/crates.nvim",
  }
  return deps
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = get_dependencies(),
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local format_kinds = function(entry, vim_item)
      vim_item = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
      })(entry, vim_item)

      local kind = vim_item.kind
      local source_name = entry.source.name
      local source_icons = {
        nvim_lsp = " LSP",
        luasnip = " Snip",
        buffer = " Buffer",
        path = " Path",
        lazydev = " LazyDev",
        spell = " Spell",
        nvim_lua = "NVIM API",
        cmdline = " Command",
      }

      if source_icons[source_name] then
        vim_item.kind = string.format("%s %s", source_icons[source_name], kind)
      end

      return vim_item
    end

    local comparators = {
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    }

    local global_sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "spell" },
      { name = "buffer", keyword_length = 3 },
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- Do not preselect any item; user must explicitly navigate to select
      preselect = cmp.PreselectMode.None,
      sources = cmp.config.sources(global_sources),
      formatting = {
        format = format_kinds,
      },
      mapping = cmp.mapping.preset.insert({
        -- Navigate items; when an item is selected, show cmp ghost text and
        -- dismiss Copilot so only one ghost text is visible at a time.
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.dismiss()
            end
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.dismiss()
            end
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Reserved for Copilot
        ["<C-n>"] = cmp.mapping(function(fallback)
          fallback()
        end, { "i", "s" }),

        ["<C-p>"] = cmp.mapping(function(fallback)
          fallback()
        end, { "i", "s" }),

        -- <C-l> single smart accept: Copilot if visible, else selected cmp item
        ["<C-l>"] = cmp.mapping(function(fallback)
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok and suggestion.is_visible() then
            suggestion.accept()
          elseif cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Esc: if Copilot suggestion visible, dismiss it and stay in insert mode.
        -- Otherwise abort cmp (if open) and fall through to normal <Esc>.
        ["<Esc>"] = cmp.mapping(function(fallback)
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok and suggestion.is_visible() then
            suggestion.dismiss()
            -- do NOT call fallback — stay in insert mode
            return
          end
          if cmp.visible() then
            cmp.abort()
          end
          fallback()
        end, { "i", "s" }),

        -- Tab/Enter remain normal (snippet handling only)
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Enter always creates newline
        ["<CR>"] = cmp.mapping(function(fallback)
          fallback()
        end, { "i", "s" }),

        -- Other
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sorting = {
        priority_weight = 2,
        comparators = comparators,
      },
      experimental = {
        ghost_text = true,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    cmp.setup.filetype("lua", {
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
      }),
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "Cargo.toml",
      callback = function(_event)
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "crates" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 3 },
          }),
        })
      end,
    })

    -- Patch ghost_text_view.show on the cmp view instance to only show ghost
    -- text when an entry is explicitly selected. By default cmp falls back to
    -- showing the first entry even when nothing is selected, which conflicts
    -- with Copilot's ghost text.
    vim.schedule(function()
      local cmp_view = require("cmp").core.view
      local orig_show = cmp_view.ghost_text_view.show
      cmp_view.ghost_text_view.show = function(self, e)
        if cmp_view:get_selected_entry() then
          orig_show(self, e)
        else
          self:hide()
        end
      end
    end)

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" }, { name = "cmdline" } }),
    })
  end,
}
