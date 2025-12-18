---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "marilari88/neotest-vitest",
    },
    config = function()
      local neotest = require "neotest"

      neotest.setup {
        adapters = {
          require "neotest-vitest",
        },
      }

      -- Keymaps for vitest
      local keymap = vim.keymap.set

      keymap("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run nearest test", noremap = true, silent = true })
      keymap("n", "<leader>tf", function() neotest.run.run(vim.fn.expand "%") end, { desc = "Run file", noremap = true, silent = true })
      keymap("n", "<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run all tests", noremap = true, silent = true })
      keymap("n", "<leader>ts", function() neotest.run.stop() end, { desc = "Stop test", noremap = true, silent = true })
      keymap("n", "<leader>td", function() neotest.run.run { strategy = "dap" } end, { desc = "Debug test", noremap = true, silent = true })
      keymap("n", "<leader>to", function() neotest.output.open { enter = true } end, { desc = "Open test output", noremap = true, silent = true })
      keymap("n", "<leader>tS", function() neotest.summary.toggle() end, { desc = "Toggle test summary", noremap = true, silent = true })
      keymap("n", "<leader>tn", function() neotest.jump.next() end, { desc = "Next test", noremap = true, silent = true })
      keymap("n", "<leader>tp", function() neotest.jump.prev() end, { desc = "Previous test", noremap = true, silent = true })
    end,
  },
}
