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

      -- Keymaps
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find in files" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find help tags" })
      vim.keymap.set("n", "<leader>f/", fzf.search_history, { desc = "Search history" })
      
      -- Command palette keymaps using Snacks picker
      vim.keymap.set("n", "<leader>fc", function() require("snacks").picker.commands() end, { desc = "Find commands" })
      vim.keymap.set("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fa", function() require("snacks").picker.autocmds() end, { desc = "Find autocmds" })
    end,
  },
}
