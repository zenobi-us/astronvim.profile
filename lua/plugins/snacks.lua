---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "mise x -- pokemon-go-colorscripts --name glalie --no-title",
            random = 10,
            pane = 1,
            indent = 19,
            height = 20,
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      keys = {
        -- Default: compare with origin/main
        { "<leader>gb", function() require("snacks").picker.pick "branch_files" end, desc = "Git Branch Files" },

        -- Compare with different base
        {
          "<leader>gB",
          function() require("snacks").picker.pick("branch_files", { base = "origin/master" }) end,
          desc = "Git Branch Files (vs master)",
        },
      },
      -- Enable picker with vim.ui.select override for nice modal prompts
      picker = {
        ui_select = true,
        sources = {
          branch_files = {
            ---@type string base branch to compare against
            base = "origin/main", -- change this to origin/master, main, or any branch

            finder = function(opts, ctx)
              local base = opts.base or "origin/main"
              return require("snacks.picker.source.proc").proc(ctx:opts {
                cmd = "git",
                args = { "diff", "--name-only", base .. "..HEAD" },
                transform = function(item)
                  if item.text ~= "" then return { file = item.text, text = item.text, idx = item.idx } end
                end,
              })
            end,
            format = "file",
            title = function(opts) return "Branch Files (vs " .. (opts.base or "origin/main") .. ")" end,
          },
        },
      },
    },
  },

  -- Disable built-in alpha dashboard
  { "goolord/alpha-nvim", enabled = false },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },
}
