-- Dashboard, picker, and UI enhancements
---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      local logo_lines = {
        "      ,l;             c,      ",
        "   .:ooool'           loo:.   ",
        " .,oooooooo:.         looooc, ",
        "ll:,loooooool,        looooool",
        "llll,;ooooooooc.      looooooo",
        "lllllc,coooooooo;     looooooo",
        "lllllll;,loooooool'   looooooo",
        "lllllllc .:oooooooo:. looooooo",
        "lllllllc   'loooooool,:ooooooo",
        "lllllllc     ;ooooooooc,cooooo",
        "lllllllc      .coooooooo;;looo",
        "lllllllc        ,loooooool,:ol",
        " 'cllllc         .:oooooooo;. ",
        "   .;llc           .loooo:.   ",
        "      ,;             ;l;      ",
      }

      local function lerp(from, to, amount) return from + (to - from) * amount end

      local function hex(rgb) return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3]) end

      local function gradient(from, to, steps)
        local out = {}
        for i = 0, steps do
          local amount = i / steps
          out[#out + 1] = hex({
            math.floor(lerp(from[1], to[1], amount)),
            math.floor(lerp(from[2], to[2], amount)),
            math.floor(lerp(from[3], to[3], amount)),
          })
        end
        for i = 1, steps - 1 do
          local amount = i / steps
          out[#out + 1] = hex({
            math.floor(lerp(to[1], from[1], amount)),
            math.floor(lerp(to[2], from[2], amount)),
            math.floor(lerp(to[3], from[3], amount)),
          })
        end
        return out
      end

      local logo_hls = {}
      for i, color in ipairs(gradient({ 67, 206, 162 }, { 24, 90, 157 }, #logo_lines)) do
        local hl = "SnacksDashboardLogo" .. i
        logo_hls[i] = hl
        vim.api.nvim_set_hl(0, hl, { fg = color })
      end

      local function animate(arr)
        arr[#arr + 1] = table.remove(arr, 1)
        return arr
      end

      if _G.snacks_dashboard_logo_timer then
        _G.snacks_dashboard_logo_timer:stop()
        _G.snacks_dashboard_logo_timer:close()
      end
      _G.snacks_dashboard_logo_timer = vim.uv.new_timer()
      _G.snacks_dashboard_logo_timer:start(
        120,
        120,
        vim.schedule_wrap(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then
              animate(logo_hls)
              local snacks = rawget(_G, "Snacks")
              if snacks and snacks.dashboard then snacks.dashboard.update() end
              return
            end
          end
        end)
      )

      local function logo_section()
        local text = {}
        for i, line in ipairs(logo_lines) do
          text[#text + 1] = { line .. (i == #logo_lines and "" or "\n"), hl = logo_hls[i] }
        end
        return {
          text = text,
          pane = 1,
          align = "center",
          indent = 0,
          padding = 1,
        }
      end

      opts = opts or {}
      opts.input = { enabled = true }
      opts.select = { enabled = true }
      opts.dashboard = {
        sections = {
          logo_section,
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
