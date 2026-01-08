-- Fuzzy finder using FZF
---@type LazySpec
return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require "fzf-lua"

      fzf.setup {
        defaults = {
          formatter = "path.filename_first",
        },
        files = {
          cmd = "fd --type f --hidden --exclude .git",
        },
        grep = {
          cmd = "rg --vimgrep --max-count=0",
        },
      }

      -- Keymaps (use <leader>sf instead of <leader>ff to avoid conflict with 'f' find-char motion)
      -- vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Search files" })
      -- vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Search grep" })
      -- vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search buffers" })
      -- vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search help tags" })
      -- vim.keymap.set("n", "<leader>s/", fzf.search_history, { desc = "Search history" })

      -- Command palette keymaps using Snacks picker
      vim.keymap.set("n", "<leader>fc", function() require("snacks").picker.commands() end, { desc = "Find commands" })
      vim.keymap.set("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fa", function() require("snacks").picker.autocmds() end, { desc = "Find autocmds" })
    end,
  },
}
