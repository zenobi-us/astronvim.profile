return {
  "Juksuu/worktrees.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("worktrees").setup()
  end,
  keys = {
    { "<leader>gws", function() require("telescope").extensions.worktrees.list_worktrees() end, desc = "Switch worktree" },
    { "<leader>gwn", function() require("worktrees").create_worktree() end, desc = "New worktree" },
    { "<leader>gwc", function() require("worktrees").create_worktree_from_branch() end, desc = "Create worktree from existing branch" },
    { "<leader>gwr", function() require("worktrees").remove_worktree() end, desc = "Remove worktree" },
  },
}
