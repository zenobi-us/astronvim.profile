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

      local logo_colors = {
        "#00ff66",
        "#00e65c",
        "#00cc52",
        "#00b347",
        "#00993d",
        "#008033",
        "#006629",
        "#004d1f",
        "#003314",
        "#001a0a",
        "#003314",
        "#004d1f",
        "#006629",
        "#008033",
        "#00b347",
      }

      local logo_hls = {}
      local logo_glitch_hls = {}
      local function apply_logo_hls()
        for i, color in ipairs(logo_colors) do
          local hl = "SnacksDashboardLogo" .. i
          local glitch_hl = "SnacksDashboardLogoGlitch" .. i
          logo_hls[i] = logo_hls[i] or hl
          logo_glitch_hls[i] = logo_glitch_hls[i] or glitch_hl
          vim.api.nvim_set_hl(0, hl, { fg = color, ctermfg = 37 })
          vim.api.nvim_set_hl(0, glitch_hl, { fg = "#7cff9b", ctermfg = 120 })
        end
      end
      apply_logo_hls()

      local glitch_offsets = {}

      local function animate(arr)
        arr[#arr + 1] = table.remove(arr, 1)
        return arr
      end

      local function glitch_line(line, offset)
        if offset > 0 then return (" "):rep(offset) .. line end
        if offset < 0 then return line:sub(math.min(-offset + 1, #line)) end
        return line
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
              apply_logo_hls()
              animate(logo_hls)
              for i = 1, #logo_lines do
                glitch_offsets[i] = math.random() < 0.07 and math.random(-2, 2) or 0
              end
              local snacks = rawget(_G, "Snacks")
              if snacks and snacks.dashboard then snacks.dashboard.update() end
              return
            end
          end
        end)
      )

      local function logo_section()
        apply_logo_hls()
        local text = {}
        for i, line in ipairs(logo_lines) do
          local offset = glitch_offsets[i] or 0
          line = glitch_line(line, offset)
          text[#text + 1] = { line .. (i == #logo_lines and "" or "\n"), hl = offset ~= 0 and logo_glitch_hls[i] or logo_hls[i] }
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
