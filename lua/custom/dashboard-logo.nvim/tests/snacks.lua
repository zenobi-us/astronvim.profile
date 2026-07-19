local script = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local root = script:match "^(.*)/tests/[^/]+$"
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local frames = 0
local logo = require("dashboard-logo.snacks").setup {
  on_frame = function() frames = frames + 1 end,
}

local section = logo.section()
assert(_G.snacks_dashboard_logo_timer)
assert(vim.wait(500, function() return _G.snacks_dashboard_logo_timer == nil end), "timer stayed active without dashboard")

local lines = vim.split(section.text[1][1], "\n", { plain = true })
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
section.render({ buf = 0, lines = lines }, { 1, 0 })
assert(vim.wait(100, function()
  local ns = vim.api.nvim_get_namespaces()["dashboard-logo"]
  return ns and #vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {}) > 0
end), "custom logo highlights were not rendered")

vim.bo.filetype = "snacks_dashboard"
logo.section()
assert(_G.snacks_dashboard_logo_timer)
vim.wait(200)
assert(_G.snacks_dashboard_logo_timer, "timer stopped while dashboard was visible")
assert(frames > 0, "frame callback did not run")

vim.bo.filetype = ""
assert(vim.wait(500, function() return _G.snacks_dashboard_logo_timer == nil end), "timer stayed active after dashboard closed")

print "dashboard logo lifecycle: ok"
