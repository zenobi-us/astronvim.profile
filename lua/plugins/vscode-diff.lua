return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("vscode-diff").setup({
      -- Highlight configuration
      highlights = {
        -- Line-level: accepts highlight group names or hex colors
        line_insert = "DiffAdd",
        line_delete = "DiffDelete",

        -- Character-level: auto-adjusted based on colorscheme
        char_insert = nil, -- nil = auto-derive from line_insert
        char_delete = nil, -- nil = auto-derive from line_delete

        -- Brightness multiplier (nil = auto-detect: 1.4 for dark, 0.92 for light)
        char_brightness = nil,
      },

      -- Diff view behavior
      diff = {
        disable_inlay_hints = true, -- Cleaner diff view
        max_computation_time_ms = 5000,
      },

      -- Keymaps in diff view
      keymaps = {
        view = {
          quit = "q",
          toggle_explorer = "<leader>b",
          next_hunk = "]c",
          prev_hunk = "[c",
          next_file = "]f",
          prev_file = "[f",
        },
        explorer = {
          select = "<CR>",
          hover = "K",
          refresh = "R",
        },
      },
    })
  end,
}
