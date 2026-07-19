local script = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local root = script:match "^(.*)/tests/[^/]+$"
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local frames, redraws = 0, 0
local logo = require("dashboard-logo.snacks").setup {
  on_frame = function() frames = frames + 1 end,
  update = function() redraws = redraws + 1 end,
}

local section = logo.section()
assert(_G.snacks_dashboard_logo_timer)
assert(vim.wait(500, function() return _G.snacks_dashboard_logo_timer == nil end), "timer stayed active without dashboard")

local lines = vim.split(section.text[1][1], "\n", { plain = true })
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
section.render({ buf = 0, lines = lines, panes = { {} }, opts = { width = 80 }, col = 0 }, { 1, 0 })
assert(vim.wait(100, function()
  local ns = vim.api.nvim_get_namespaces()["dashboard-logo"]
  return ns and #vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {}) > 0
end), "custom logo highlights were not rendered")

vim.bo.filetype = "snacks_dashboard"
logo.section()
assert(_G.snacks_dashboard_logo_timer)
local random = math.random
local chance = 0
math.random = function(first)
  if first then return first end
  chance = chance + 1
  return chance == 1 and 0 or 1
end
vim.wait(120)
assert(_G.snacks_dashboard_logo_timer, "timer stopped while dashboard was visible")
assert(frames > 0, "frame callback did not run")
assert(redraws == 0, "single-pane geometry used full Snacks update")

local current = vim.split(logo.section().text[1][1], "\n", { plain = true })
local actual = vim.api.nvim_buf_get_lines(0, 0, #current, false)
for i, line in ipairs(current) do
  local width = vim.api.nvim_strwidth(line)
  local padding = math.max(80 - width, 0)
  local expected = (" "):rep(math.floor(padding / 2)) .. line .. (" "):rep(padding - math.floor(padding / 2))
  assert(actual[i] == expected, "direct geometry row mismatch at line " .. i)
end
math.random = random

vim.bo.filetype = ""
assert(vim.wait(500, function() return _G.snacks_dashboard_logo_timer == nil end), "timer stayed active after dashboard closed")

print "dashboard logo lifecycle: ok"
