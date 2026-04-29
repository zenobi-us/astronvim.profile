-- Plugin: copilot.lua
-- Description: GitHub Copilot AI code suggestions
-- URL: https://github.com/zbirenbaum/copilot.lua
---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      -- Resolve node path at runtime when plugin loads (not at parse time)
      local result = vim.system({ "mise", "which", "--tool=node@latest", "node" }, { text = true }):wait()
      local node_path = (result.stdout or ""):gsub("%s+", "")
      if node_path == "" or result.code ~= 0 then
        node_path = vim.fn.exepath "node" -- fallback
      end
      return {
        copilot_node_command = node_path,
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<A-Right>",
            accept_word = false,
            accept_line = false,
            next = "<C-Down>",
            prev = "<C-Up>",
            dismiss = false,
          },
        },
        filetypes = {
          yaml = true,
          yml = true,
          markdown = true,
        },
      }
    end,
  },

  -- Integrate Copilot with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("copilot_cmp").setup() end,
  },
}
