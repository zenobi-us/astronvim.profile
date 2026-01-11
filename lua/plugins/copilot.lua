---@type LazySpec
return {
  -- Configure Copilot to use a specific Node.js version from mise
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.fn.system("mise which --tool node@latest node"):gsub("\n", ""),
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-Right>",
          accept_word = false,
          accept_line = false,
          next = "<C-Down>",
          prev = "<C-Up>",
          dismiss = "<C-Backspace>",
        },
      },
      filetypes = {
        yaml = true,
        yml = true,
        markdown = true,
      },
    },
  },

  -- Integrate Copilot with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("copilot_cmp").setup() end,
  },
}
