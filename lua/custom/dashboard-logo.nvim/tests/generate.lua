local root = arg[0]:gsub("\\", "/"):match "^(.*)/tests/[^/]+$"
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local logo = dofile(root .. "/lua/dashboard-logo/init.lua")
local lines = logo.logos[logo.logos.default]
local frame = logo.generate { color_offset = 0, glitch_offsets = {} }
local rendered = logo.render()
local plain = logo.generate({}, nil, "none")

assert(logo.logos.default == "votann")
assert(#frame == #lines)
assert(rendered[1].line == lines[1] and rendered[1].color == nil)
assert(plain[1].line == lines[1] and plain[1].color == nil)
assert(frame[1].line == lines[1])
assert(frame[1].color == logo.effects.glitch.colors[1])
assert(frame[#logo.effects.glitch.colors + 1].color == logo.effects.glitch.colors[1])

local block_frame = logo.generate({
  color_offset = 0,
  glitch_blocks = { { first = 4, last = 8, offset = 2, ttl = 2 } },
  burn_waves = {},
})
assert(block_frame[3].line == lines[3])
assert(block_frame[4].line == "  " .. lines[4])
assert(block_frame[8].line == "  " .. lines[8])
assert(block_frame[9].line == lines[9])

local burn_frame = logo.generate({
  color_offset = 0,
  glitch_blocks = { { first = 4, last = 8, offset = -1, ttl = 2, burn = true } },
  burn_waves = { { first = 4, last = 8, age = 0 } },
})
assert(burn_frame[4].color == logo.effects.glitch.burn_colors[1])
assert(burn_frame[8].color == logo.effects.glitch.burn_colors[1])

local wave_frame = logo.generate({
  color_offset = 0,
  glitch_blocks = {},
  burn_waves = { { first = 4, last = 8, age = 2 } },
})
assert(wave_frame[2].color == logo.effects.glitch.burn_colors[1])
assert(wave_frame[3].color == logo.effects.glitch.burn_colors[2])
assert(wave_frame[4].color == logo.effects.glitch.colors[((4 - 1) % #logo.effects.glitch.colors) + 1])

local random = math.random
math.random = function() return 1 end
local wave_state = {
  glitch_blocks = { { first = 4, last = 8, offset = 1, ttl = 2, burn = true, wave_started = true } },
  burn_waves = { { first = 4, last = 8, age = 0 } },
}
logo.advance(wave_state)
math.random = random
assert(wave_state.burn_waves[1].age == 1)
assert(wave_state.glitch_blocks[1].ttl == 1)

local updated
local animation = logo.new { update = function(next_frame) updated = next_frame end }
assert(#animation.frame() == #lines)
animation.tick()
assert(updated and #updated == #lines)

local no_effect = logo.new { effect = "none" }
assert(no_effect.frame()[1].color == nil)

print "dashboard logo generation: ok"
