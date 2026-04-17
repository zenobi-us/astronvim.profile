-- Dashboard, picker, and UI enhancements
---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      local dotfile_root = vim.env.DOTFILE_ROOT
      local pokemon_section

      if dotfile_root and dotfile_root ~= "" then
        local pokemon_cmd = string.format("%s/modules/pokemon__config.zsh", dotfile_root)
        pokemon_section = {
          section = "terminal",
          cmd = pokemon_cmd,
          random = 10,
          pane = 1,
          indent = 19,
          height = 20,
        }
      else
        pokemon_section = {
          header = [[
           ⢀⡴⠑⡄
          ⠸⡇⠀⠿⡀
          ⠀⠀⠀⠀⠙⢦⡀
          ⠀⠀⠀⠀⠀⠀⠈⠳⣄
          ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡄
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠦⣀
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⢄
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠃
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠞
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠁
          ]],
          pane = 1,
          indent = 19,
          padding = 1,
        }
      end
      opts = opts or {}
      opts.input = { enabled = true }
      opts.select = { enabled = true }
      opts.dashboard = {
        sections = {
          pokemon_section,
          { section = "keys", gap = 1, padding = 1 },
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
