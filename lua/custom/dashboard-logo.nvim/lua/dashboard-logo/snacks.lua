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
  local virtual_lines = {}
  local virtual_opts = {}
  local chunk_cache = {}

  local function geometry_changed(previous, next_frame)
    if not previous or #previous ~= #next_frame then return true end
    for i, item in ipairs(next_frame) do
      if previous[i].line ~= item.line then return true end
    end
    return false
  end

  local function update_geometry()
    if not dashboard
      or not start_row
      or not vim.api.nvim_buf_is_valid(dashboard.buf)
      or not dashboard.panes
      or #dashboard.panes ~= 1
    then
      return false
    end

    local rows = {}
    for i, item in ipairs(frame) do
      local width = vim.api.nvim_strwidth(item.line)
      local before, after
      if width > dashboard.opts.width then
        before = math.max(dashboard.col - math.floor((width - dashboard.opts.width) / 2), 0)
        after = 0
      else
        local padding = dashboard.opts.width - width
        before = dashboard.col + math.floor(padding / 2)
        after = padding - math.floor(padding / 2)
      end
      rows[i] = (" "):rep(before) .. item.line .. (" "):rep(after)
      dashboard.lines[start_row + i - 1] = rows[i]
    end

    vim.bo[dashboard.buf].modifiable = true
    vim.api.nvim_buf_set_lines(dashboard.buf, start_row - 1, start_row - 1 + #rows, false, rows)
    vim.bo[dashboard.buf].modifiable = false
    return true
  end

  local function display_segments(line, item)
    local lines = chunk_cache[line]
    if not lines then
      lines = {}
      chunk_cache[line] = lines
    end
    if lines[item.line] then return lines[item.line] end

    local result = {}
    local leading = ""
    for _, segment in ipairs(item.segments) do
      if segment.visible then
        result[#result + 1] = {
          text = leading .. segment.text,
          color = segment.color,
          visible = true,
        }
        leading = ""
      elseif #result > 0 then
        result[#result].text = result[#result].text .. segment.text
      else
        leading = leading .. segment.text
      end
    end
    if leading ~= "" then
      if #result > 0 then
        result[#result].text = result[#result].text .. leading
      else
        result[1] = { text = leading, visible = false }
      end
    end
    lines[item.line] = result
    return result
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
      local chunks = virtual_lines[i] or {}
      virtual_lines[i] = chunks
      local length = 0
      for _, segment in ipairs(display_segments(i, item)) do
        local hl = highlight(logo.filter_color(segment.color, item.filter), item.glow)
        local previous = chunks[length]
        if previous and previous[2] == hl then
          previous[1] = previous[1] .. segment.text
        else
          length = length + 1
          local chunk = chunks[length] or {}
          chunk[1], chunk[2] = segment.text, segment.visible and hl or nil
          chunks[length] = chunk
        end
      end
      for j = length + 1, #chunks do chunks[j] = nil end
      local extmark = virtual_opts[i] or { virt_text_pos = "overlay", hl_mode = "replace" }
      extmark.virt_text = chunks
      virtual_opts[i] = extmark
      vim.api.nvim_buf_set_extmark(dashboard.buf, namespace, row - 1, col, extmark)
    end
  end

  local animation = logo.new {
    logo = opts.logo,
    effect = opts.effect,
    color = color(opts.color),
    update = function(next_frame)
      local redraw = geometry_changed(frame, next_frame)
      frame = next_frame
      if redraw and not update_geometry() and opts.update then opts.update(next_frame) end
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
