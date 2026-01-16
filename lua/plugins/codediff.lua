-- Plugin: codediff.nvim
-- Description: VSCode-style side-by-side diff rendering with two-tier highlighting
-- URL: https://github.com/esmuellert/codediff.nvim
---@type LazySpec
return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  config = function()
    require("codediff").setup({
      -- Highlight configuration
      highlights = {
        -- Line-level: accepts highlight group names or hex colors
        line_insert = "DiffAdd",    -- Line-level insertions
        line_delete = "DiffDelete", -- Line-level deletions

        -- Character-level: auto-derive from line-level highlights
        char_insert = nil, -- nil = auto-derive with brightness adjustment
        char_delete = nil, -- nil = auto-derive with brightness adjustment

        -- Brightness multiplier for character-level highlights
        -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
        char_brightness = nil,

        -- Conflict sign highlights (for merge conflict views)
        conflict_sign = nil,          -- Unresolved: DiagnosticSignWarn
        conflict_sign_resolved = nil, -- Resolved: Comment
        conflict_sign_accepted = nil, -- Accepted: GitSignsAdd
        conflict_sign_rejected = nil, -- Rejected: GitSignsDelete
      },

      -- Diff view behavior
      diff = {
        disable_inlay_hints = true,     -- Disable inlay hints for cleaner diff view
        max_computation_time_ms = 5000, -- Maximum time for diff computation
        hide_merge_artifacts = false,   -- Hide merge tool temp files
        original_position = "left",     -- Position of original content: "left" or "right"
        conflict_ours_position = "right", -- Position of ours in conflict view
      },

      -- Explorer panel configuration
      explorer = {
        position = "left", -- "left" or "bottom"
        width = 40,        -- Width when position is "left" (columns)
        height = 15,       -- Height when position is "bottom" (rows)
      },

      -- Git configuration
      git = {
        default_branch = "main", -- Fallback if unable to determine default branch
      },
    })
  end,
}
