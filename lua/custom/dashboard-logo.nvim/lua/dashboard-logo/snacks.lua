local logo = require "dashboard-logo"

local M = {}

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
      local hl
      if item.color then
        hl = "DashboardLogoLine" .. i
        vim.api.nvim_set_hl(0, hl, { fg = item.color, ctermfg = item.glitch and 120 or 37 })
      end
      text[i] = { item.line .. (i == #frame and "" or "\n"), hl = hl }
    end
    return { text = text, pane = 1, align = "center", indent = 0, padding = 4 }
  end

  M.stop()
  _G.snacks_dashboard_logo_timer = vim.uv.new_timer()
  _G.snacks_dashboard_logo_timer:start(animation.interval, animation.interval, vim.schedule_wrap(animation.tick))

  return { section = section, stop = M.stop }
end

return M
