-- Emoji picker plugin configuration for Neovim using lazy.nvim
---@type LazySpec
return {
  "allaman/emoji.nvim",
  version = "1.0.0", -- optionally pin to a tag
  dependencies = {
    -- util for handling paths
    "nvim-lua/plenary.nvim",
    -- optional for nvim-cmp integration
    "hrsh7th/nvim-cmp",
  },
  opts = {
    -- default is false, also needed for blink.cmp integration!
    enable_cmp_integration = true,
  },
  config = function(_, opts)
    require("emoji").setup(opts)
    -- Use vim.ui.select (handled by Snacks picker)
    vim.keymap.set("n", "<leader>fe", function() require("emoji").insert() end, { desc = "[F]ind [E]moji" })
  end,
}
