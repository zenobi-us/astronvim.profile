-- Git worktrees management
---@type LazySpec
return {
  "Juksuu/worktrees.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    require("worktrees").setup()
    local Snacks = require "snacks"

    -- Set up keymaps
    local keymap = vim.keymap.set
    keymap("n", "<leader>gws", function() Snacks.picker.worktrees() end, { desc = "Switch worktree" })
    keymap("n", "<leader>gwn", function() Snacks.picker.worktrees_new() end, { desc = "New worktree" })
    keymap(
      "n",
      "<leader>gwc",
      function() Snacks.picker.worktrees_new { create = true } end,
      { desc = "Create worktree from existing branch" }
    )
    keymap("n", "<leader>gwr", function() Snacks.picker.worktrees_remove() end, { desc = "Remove worktree" })
  end,
}
