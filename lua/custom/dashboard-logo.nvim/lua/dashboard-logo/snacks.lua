local logo = require "dashboard-logo"

local M = {}
local highlights = {}
local namespace = vim.api.nvim_create_namespace "dashboard-logo"

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
  local dashboard
  local start_row
  local plain = {}
  local text = { { "" } }

  local function geometry_changed(previous, next_frame)
    if not previous or #previous ~= #next_frame then return true end
    for i, item in ipairs(next_frame) do
      if previous[i].line ~= item.line then return true end
    end
    return false
  end

  local function apply_highlights()
    if not dashboard or not start_row or not vim.api.nvim_buf_is_valid(dashboard.buf) then return end
    vim.api.nvim_buf_clear_namespace(dashboard.buf, namespace, start_row - 1, start_row - 1 + #frame)
    for i, item in ipairs(frame) do
      local row = start_row + i - 1
      local rendered = dashboard.lines and dashboard.lines[row]
        or vim.api.nvim_buf_get_lines(dashboard.buf, row - 1, row, false)[1]
        or ""
      local first = rendered:find(item.line, 1, true) or 1
      local col = first - 1
      for _, segment in ipairs(item.segments) do
        local next_col = col + #segment.text
        local hl = highlight(logo.filter_color(segment.color, item.filter), item.glow)
        if hl and next_col > col and segment.text:find("%S") then
          vim.api.nvim_buf_set_extmark(dashboard.buf, namespace, row - 1, col, {
            end_col = next_col,
            hl_group = hl,
          })
        end
        col = next_col
      end
    end
  end

  local animation = logo.new {
    logo = opts.logo,
    effect = opts.effect,
    color = color(opts.color),
    update = function(next_frame)
      local redraw = geometry_changed(frame, next_frame)
      frame = next_frame
      if redraw and opts.update then opts.update(next_frame) end
      apply_highlights()
      if opts.on_frame then opts.on_frame(next_frame) end
    end,
  }
  frame = animation.frame()
  local section_item = {
    text = text,
    pane = 1,
    align = "center",
    indent = 0,
    padding = 4,
    render = function(next_dashboard, pos)
      dashboard, start_row = next_dashboard, pos[1]
      vim.schedule(apply_highlights)
    end,
  }

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
    for i, item in ipairs(frame) do
      plain[i] = item.line
    end
    for i = #frame + 1, #plain do plain[i] = nil end
    text[1][1] = table.concat(plain, "\n")
    return section_item
  end

  M.stop()
  return { section = section, stop = M.stop }
end

return M
