-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/meow-review.lua
-- @brief: lazy.nvim spec for meow.review.nvim — AI code review annotations.
--
-- Keymaps (all managed in keymaps.lua under <leader>r):
--   <leader>ra  Add Comment         [n, v] — modal: Tab cycles type, <C-s> confirms
--   <leader>rd  Delete Comment      [n, v]
--   <leader>rE  Edit Comment        [n]    — pre-filled modal
--   <leader>rv  View Comment        [n]
--   <leader>re  Export Review       [n]    — exports to clipboard (default)
--   <leader>rf  Export to File      [n]    — prompts for filename
--   <leader>rc  Clear All           [n]
--   <leader>rg  Go to Comment       [n]    — picker; jump to any annotation
--   <leader>rr  Reload              [n]    — reload from .meow-review.json
--   ]r          Next Review Comment  [n]
--   [r          Previous Review Comment [n]

return {
    -- dir = "/Users/retran/workspace/meow.review.nvim", -- local dev override
    "retran/meow.review.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    config = function()
        require("meow.review").setup({
            -- Number of source lines to show before and after each annotated range
            -- in the exported markdown. Set to 0 to disable snippet capture.
            context_lines = 3,

            -- Exporter used by <Plug>(MeowReviewExport) / :MeowReview export.
            default_exporter = "clipboard",

            -- Filename written by :MeowReview export file (and file_prompt).
            export_filename = ".meow-review.md",
        })
    end,
}
