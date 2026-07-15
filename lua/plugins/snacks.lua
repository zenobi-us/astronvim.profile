-- Dashboard, picker, and UI enhancements
---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "custom/dashboard-logo.nvim" },
    opts = function(_, opts)
      -- local logo = require("dashboard-logo.snacks").setup {
      --   color = vim.api.nvim_get_hl(0, { name = "Special", link = false }).fg,
      --   update = function()
      --     for _, win in ipairs(vim.api.nvim_list_wins()) do
      --       if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then
      --         local snacks = rawget(_G, "Snacks")
      --         if snacks and snacks.dashboard then snacks.dashboard.update() end
      --         return
      --       end
      --     end
      --   end,
      -- }

      opts = opts or {}
      opts.input = { enabled = true }
      opts.select = { enabled = true }
      opts.dashboard = {
        sections = {
          -- logo.section,
          { section = "startup" },
        },
      }
      opts.picker = {
        layout = {
          preset = "telescope", -- list on left, preview on right
        },
        sources = {
          git_diff = {
            win = {
              input = {
                keys = {
                  ["o"] = { "confirm", mode = { "n", "i" } },
                },
              },
              list = {
                keys = {
                  ["o"] = "confirm",
                },
              },
            },
          },
        },
      }

      return opts
    end,
  },

  -- Disable built-in alpha dashboard
  { "goolord/alpha-nvim", enabled = false },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },
}
