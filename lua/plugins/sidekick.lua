return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim", -- for better prompt/tool selection
  },
  opts = {
    cli = {
      -- Enable terminal multiplexer for persistent sessions
      mux = {
        backend = vim.env.ZELLIJ and "zellij" or "tmux",
        enabled = true,
      },
      win = {
        layout = "right",
        split = {
          width = 80,
        },
      },
    },
  },
  keys = {
    -- NES (Next Edit Suggestions) keymaps
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    -- CLI toggle keymaps
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    -- Context sending keymaps
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Direct tool access
    {
      "<leader>ao",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
