local M = {}

M.colors = {
  "#00ff66",
  "#00993d",
  "#008033",
  "#006629",
  "#004d1f",
  "#003314",
  "#001a0a",
  "#003314",
}
M.glitch_color = "#7cff9b"
M.interval = 120

local function glitch_line(line, offset)
  if offset > 0 then return (" "):rep(offset) .. line end
  if offset < 0 then return line:sub(math.min(-offset + 1, #line)) end
  return line
end

function M.apply(frame, state)
  state.color_offset = state.color_offset or 0
  state.glitch_offsets = state.glitch_offsets or {}

  local effected = {}
  for i, item in ipairs(frame) do
    local offset = state.glitch_offsets[i] or 0
    local color_index
    if i <= #M.colors then color_index = ((i - 1 + state.color_offset) % #M.colors) + 1 end
    effected[i] = {
      line = glitch_line(item.line, offset),
      color = offset ~= 0 and M.glitch_color or (color_index and M.colors[color_index]),
      glitch = offset ~= 0,
    }
  end
  return effected
end

function M.advance(state, frame)
  state.color_offset = ((state.color_offset or 0) + 1) % #M.colors
  state.glitch_offsets = state.glitch_offsets or {}
  for i = 1, #frame do
    state.glitch_offsets[i] = math.random() < 0.07 and math.random(-2, 2) or 0
  end
end

return M
