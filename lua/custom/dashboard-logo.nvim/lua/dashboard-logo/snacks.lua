local logo = require "dashboard-logo"

local M = {}
local highlights = {}

local function highlight(color, glow)
  if not color then return nil end
  local name = "DashboardLogo" .. color:sub(2) .. (glow and "Glow" or "")
  if not highlights[name] then
    vim.api.nvim_set_hl(0, name, { fg = color, ctermfg = glow and 120 or 37 })
    highlights[name] = true
  end
  return name
end

function M.stop()
  if not _G.snacks_dashboard_logo_timer then return end
  _G.snacks_dashboard_logo_timer:stop()
  _G.snacks_dashboard_logo_timer:close()
  _G.snacks_dashboard_logo_timer = nil
end

---@param opts? { logo?: string, effect?: string, update?: fun(frame: table[]) }
---@return { section: fun(): table, stop: fun() }
function M.setup(opts)
  opts = opts or {}
  local frame
  local animation = logo.new {
    logo = opts.logo,
    effect = opts.effect,
    update = function(next_frame)
      frame = next_frame
      if opts.update then opts.update(next_frame) end
    end,
  }
  frame = animation.frame()

  local function section()
    local text = {}
    for i, item in ipairs(frame) do
      for _, segment in ipairs(item.segments) do
        local hl = highlight(logo.filter_color(segment.color, item.filter), item.glow)
        local previous = text[#text]
        if previous and previous.hl == hl and not previous[1]:find("\n", 1, true) then
          previous[1] = previous[1] .. segment.text
        else
          text[#text + 1] = { segment.text, hl = hl }
        end
      end
      if i < #frame then text[#text][1] = text[#text][1] .. "\n" end
    end
    return { text = text, pane = 1, align = "center", indent = 0, padding = 4 }
  end

  M.stop()
  _G.snacks_dashboard_logo_timer = vim.uv.new_timer()
  _G.snacks_dashboard_logo_timer:start(animation.interval, animation.interval, vim.schedule_wrap(animation.tick))

  return { section = section, stop = M.stop }
end

return M
