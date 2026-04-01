-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/quickfix-review.lua
-- @brief: Quickfix-based code review with comment types, signs, and export.
--
-- Keymaps (all managed in keymaps.lua under <leader>r):
--   <leader>ra   add comment (cycle type)       [n]
--   <leader>ri   add ISSUE comment              [n, v]
--   <leader>rs   add SUGGESTION comment         [n, v]
--   <leader>rn   add NOTE comment               [n, v]
--   <leader>rp   add PRAISE comment             [n, v]
--   <leader>rq   add QUESTION comment           [n, v]
--   <leader>rk   add INSIGHT comment            [n, v]
--   <leader>rd   delete comment at cursor       [n, v]
--   <leader>rv   view comment at cursor
--   <leader>re   export review to markdown
--   <leader>rc   clear all comments
--   <leader>rS   review summary
--   <leader>rw   save review to disk
--   <leader>rl   load review from disk
--   <leader>ro   open review quickfix list
--   <leader>rg   goto real file (diff buffers)
--   <leader>rj   cycle to next comment type
--   <leader>rh   cycle to previous comment type
--   ]r / [r      next / previous review comment

return {
  "MMesch/quickfix-review-nvim",
  event = "VeryLazy",
  opts = {
    -- All keymaps managed centrally in keymaps.lua.
    keymaps = {
      add_issue         = false,
      add_suggestion    = false,
      add_note          = false,
      add_praise        = false,
      add_question      = false,
      add_insight       = false,
      add_comment_cycle = false,
      cycle_next        = false,
      cycle_previous    = false,
      delete_comment    = false,
      view              = false,
      export            = false,
      clear             = false,
      summary           = false,
      save              = false,
      load              = false,
      open_list         = false,
      next_comment      = false,
      prev_comment      = false,
      goto_real_file    = false,
    },
  },
}
