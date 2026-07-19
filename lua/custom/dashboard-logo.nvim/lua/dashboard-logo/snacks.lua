local logo = require "dashboard-logo"

local M = {}
local highlights = {}

local function dashboard_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then return true end
  end
  return false
end

local function color(value)
  if type(value) == "number" then return ("#%06x"):format(value) end
  return value
end

local function highlight(color, glow)
  if not color then return nil end
  local key = color .. (glow and "Glow" or "")
  if highlights[key] then return highlights[key] end

  local name = "DashboardLogo" .. color:sub(2) .. (glow and "Glow" or "")
  vim.api.nvim_set_hl(0, name, { fg = color, ctermfg = glow and 120 or 37 })
  highlights[key] = name
  return name
end

function M.stop()
  if not _G.snacks_dashboard_logo_timer then return end
  _G.snacks_dashboard_logo_timer:stop()
  _G.snacks_dashboard_logo_timer:close()
  _G.snacks_dashboard_logo_timer = nil
end

---@param opts? { logo?: string, effect?: string, color?: string|integer, on_frame?: fun(frame: table[]), update?: fun(frame: table[]) }
---@return { section: fun(): table, stop: fun() }
function M.setup(opts)
  opts = opts or {}
  local frame
  local animation = logo.new {
    logo = opts.logo,
    effect = opts.effect,
    color = color(opts.color),
    update = function(next_frame)
      frame = next_frame
      if opts.on_frame then opts.on_frame(next_frame) end
      if opts.update then opts.update(next_frame) end
    end,
  }
  frame = animation.frame()
  local text = {}
  local section_item = { text = text, pane = 1, align = "center", indent = 0, padding = 4 }

  local function start()
    if _G.snacks_dashboard_logo_timer then return end
    _G.snacks_dashboard_logo_timer = vim.uv.new_timer()
    _G.snacks_dashboard_logo_timer:start(animation.interval, animation.interval, vim.schedule_wrap(function()
      if not dashboard_visible() then
        M.stop()
        return
      end
      animation.tick()
    end))
  end

  local function section()
    start()
    local length = 0
    for i, item in ipairs(frame) do
      for _, segment in ipairs(item.segments) do
        local hl = highlight(logo.filter_color(segment.color, item.filter), item.glow)
        local previous = text[length]
        if previous and previous.hl == hl and not previous[1]:find("\n", 1, true) then
          previous[1] = previous[1] .. segment.text
        else
          length = length + 1
          local entry = text[length] or {}
          entry[1], entry.hl = segment.text, hl
          text[length] = entry
        end
      end
      if i < #frame then text[length][1] = text[length][1] .. "\n" end
    end
    for i = length + 1, #text do
      text[i] = nil
    end
    return section_item
  end

  M.stop()
  return { section = section, stop = M.stop }
end

return M
