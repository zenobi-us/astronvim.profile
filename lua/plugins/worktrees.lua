return {
  "Juksuu/worktrees.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("worktrees").setup()
  end,
  keys = {
    { "<leader>gws", function() Snacks.picker.worktrees() end, desc = "Switch worktree" },
    { "<leader>gwn", function() Snacks.picker.worktrees_new() end, desc = "New worktree" },
    { "<leader>gwc", function() Snacks.picker.worktrees_new(true) end, desc = "Create worktree from existing branch" },
    { "<leader>gwr", function() Snacks.picker.worktrees_remove() end, desc = "Remove worktree" },
  },
}
