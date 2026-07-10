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
assert(frame[#logo.effects.glitch.colors + 1].color == nil)

local updated
local animation = logo.new { update = function(next_frame) updated = next_frame end }
assert(#animation.frame() == #lines)
animation.tick()
assert(updated and #updated == #lines)

local no_effect = logo.new { effect = "none" }
assert(no_effect.frame()[1].color == nil)

print "dashboard logo generation: ok"
