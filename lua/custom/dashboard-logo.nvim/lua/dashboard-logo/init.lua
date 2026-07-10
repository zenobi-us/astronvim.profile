local M = {}

M.logos = require "dashboard-logo.logos"
M.effects = require "dashboard-logo.effects"

local function lines(name)
  name = name or M.logos.default
  assert(M.logos[name], "unknown dashboard logo: " .. name)
  return M.logos[name]
end

local function effect(name)
  name = name or M.effects.default
  assert(M.effects[name], "unknown dashboard logo effect: " .. name)
  return M.effects[name]
end

---@param name? string
---@return table[]
function M.render(name)
  local frame = {}
  for i, line in ipairs(lines(name)) do
    frame[i] = { line = line }
  end
  return frame
end

---@param state? table
---@param name? string
---@param effect_name? string
---@return table[]
function M.generate(state, name, effect_name)
  return effect(effect_name).apply(M.render(name), state or {})
end

---@param state? table
---@param name? string
---@param effect_name? string
---@return table
function M.advance(state, name, effect_name)
  state = state or {}
  local selected = effect(effect_name)
  if selected.advance then selected.advance(state, M.render(name)) end
  return state
end

---@param opts? { logo?: string, effect?: string, update?: fun(frame: table[]) }
---@return table
function M.new(opts)
  opts = opts or {}
  local name = opts.logo or M.logos.default
  local effect_name = opts.effect or M.effects.default
  local selected = effect(effect_name)
  local rendered = M.render(name)
  local state = {}
  local update = opts.update or function() end
  local animation = { interval = selected.interval or 120 }

  function animation.frame() return selected.apply(rendered, state) end

  function animation.tick()
    if selected.advance then selected.advance(state, rendered) end
    local frame = animation.frame()
    update(frame)
    return frame
  end

  return animation
end

return M
