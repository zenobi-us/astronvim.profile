local M = {}

-- Dark alternating bands scroll slowly to mimic CRT scan lines.
M.colors = {
  "#0d4d26",
  "#16802d",
  "#2dcc4b",
  "#0d4d26",
  "#0d4d26",
  "#0d4d26",
  "#0d4d26",
  "#0d4d26",
  "#0d4d26",
  "#176b35",
}
M.burn_colors = {
  "#b6ffbf",
  "#2dcc4b",
  "#16802d",
  "#0d4a1c",
  "#082b12",
}
M.interval = 90

local function glitch_line(line, offset)
  if offset > 0 then return (" "):rep(offset) .. line end
  if offset < 0 then return line:sub(math.min(-offset + 1, #line)) end
  return line
end

local function block_at(blocks, line)
  for _, block in ipairs(blocks) do
    if line >= block.first and line <= block.last then return block end
  end
end

local function burn_at(waves, line)
  local brightest
  for _, wave in ipairs(waves) do
    local rank
    if wave.age == 0 and line >= wave.first and line <= wave.last then
      rank = 1
    elseif line < wave.first then
      local head = wave.first - wave.age
      local distance = line - head
      if distance >= 0 and distance < #M.burn_colors then rank = distance + 1 end
    end
    if rank and (not brightest or rank < brightest) then brightest = rank end
  end
  return brightest and M.burn_colors[brightest]
end

function M.apply(frame, state)
  state.color_offset = state.color_offset or 0
  local blocks = state.glitch_blocks or {}
  local waves = state.burn_waves or {}
  local effected = {}

  for i, item in ipairs(frame) do
    local block = block_at(blocks, i)
    local offset = block and block.offset or (state.glitch_offsets and state.glitch_offsets[i]) or 0
    local burn_color = burn_at(waves, i)
    effected[i] = {
      line = glitch_line(item.line, offset),
      color = burn_color or M.colors[((i - 1 + state.color_offset) % #M.colors) + 1],
      glitch = offset ~= 0,
      glow = burn_color ~= nil,
    }
  end
  return effected
end

function M.advance(state, frame)
  state.color_offset = ((state.color_offset or 0) + 1) % #M.colors

  local blocks = {}
  for _, block in ipairs(state.glitch_blocks or {}) do
    block.ttl = block.ttl - 1
    if block.ttl > 0 then blocks[#blocks + 1] = block end
  end

  for slot = 1, 3 do
    if #blocks < 3 and math.random() < (0.1 / slot) then
      local first = math.random(1, math.max(1, #frame - 1))
      local block = {
        first = first,
        last = math.min(#frame, first + math.random(1, 4)),
        offset = math.random(-4, 4),
        ttl = math.random(1, 3),
        burn = math.random() < 0.35,
      }
      if block.offset == 0 then block.offset = math.random() < 0.5 and -1 or 1 end
      blocks[#blocks + 1] = block
    end
  end
  state.glitch_blocks = blocks

  local waves = {}
  for _, wave in ipairs(state.burn_waves or {}) do
    wave.age = wave.age + 1
    if wave.first - wave.age + #M.burn_colors > 0 then waves[#waves + 1] = wave end
  end
  for _, block in ipairs(blocks) do
    if block.burn and not block.wave_started then
      waves[#waves + 1] = { first = block.first, last = block.last, age = 0 }
      block.wave_started = true
    end
  end
  state.burn_waves = waves
end

return M
