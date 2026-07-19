-- Dashboard logo performance harness.
--
-- Isolated core + adapter benchmark:
--   nvim --headless -u NONE -l lua/custom/dashboard-logo.nvim/tests/perf.lua micro
--
-- Real-config Snacks redraw soak (run from this repository root):
--   nvim --headless -u init.lua -l lua/custom/dashboard-logo.nvim/tests/perf.lua soak --duration=10000
--
-- Append JSONL records with:
--   --output=/tmp/dashboard-logo-perf.jsonl

local script = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p"):gsub("\\", "/")
local plugin_root = script:match "^(.*)/tests/[^/]+$"
package.path = plugin_root .. "/lua/?.lua;" .. plugin_root .. "/lua/?/init.lua;" .. package.path

local opts = {
  mode = arg[1] or "micro",
  iterations = 1000,
  warmup = 100,
  duration = 5000,
  interval = 90,
}

for i = 2, #arg do
  local key, value = arg[i]:match "^%-%-([%w-]+)=(.+)$"
  assert(key, "invalid argument: " .. arg[i])
  key = key:gsub("-", "_")
  opts[key] = tonumber(value) or value
end

local output
if opts.output then
  vim.fn.mkdir(vim.fn.fnamemodify(opts.output, ":h"), "p")
  output = assert(io.open(opts.output, "a"))
end

local function emit(record)
  record.mode = opts.mode
  record.label = opts.label
  record.source = plugin_root
  record.timestamp = os.date "!%Y-%m-%dT%H:%M:%SZ"
  local line = vim.json.encode(record)
  print(line)
  if output then
    output:write(line, "\n")
    output:flush()
  end
end

local function percentile(sorted, fraction)
  if #sorted == 0 then return 0 end
  return sorted[math.max(1, math.ceil(#sorted * fraction))]
end

local function stats(samples, scale)
  scale = scale or 1
  if #samples == 0 then return { count = 0, mean = 0, p50 = 0, p95 = 0, max = 0 } end
  table.sort(samples)
  local total = 0
  for _, value in ipairs(samples) do
    total = total + value
  end
  return {
    count = #samples,
    mean = total / #samples / scale,
    p50 = percentile(samples, 0.50) / scale,
    p95 = percentile(samples, 0.95) / scale,
    max = samples[#samples] / scale,
  }
end

local function benchmark(name, case, fn, cleanup)
  for _ = 1, opts.warmup do
    fn()
  end

  collectgarbage "collect"
  collectgarbage "stop"
  local samples = {}
  for i = 1, opts.iterations do
    local started = vim.uv.hrtime()
    fn()
    samples[i] = vim.uv.hrtime() - started
  end
  collectgarbage "restart"
  collectgarbage "collect"

  collectgarbage "stop"
  local before_kib = collectgarbage "count"
  for _ = 1, opts.iterations do
    fn()
  end
  local allocated_kib = collectgarbage "count" - before_kib
  collectgarbage "restart"
  collectgarbage "collect"

  if cleanup then cleanup() end

  emit {
    kind = "benchmark",
    benchmark = name,
    case = case,
    iterations = opts.iterations,
    warmup = opts.warmup,
    timing_us = stats(samples, 1e3),
    allocated_kib_per_call = allocated_kib / opts.iterations,
  }
end

local function clear_logo_modules()
  for name in pairs(package.loaded) do
    if name == "dashboard-logo" or name:find("^dashboard%-logo%.") then
      package.loaded[name] = nil
    end
  end
end

local function micro()
  clear_logo_modules()
  math.randomseed(1)
  local logo = require "dashboard-logo"

  for _, logo_name in ipairs { "neovim", "grudge_axe" } do
    for _, effect_name in ipairs { "none", "glitch" } do
      math.randomseed(1)
      local animation = logo.new { logo = logo_name, effect = effect_name }
      benchmark("core_tick", { logo = logo_name, effect = effect_name }, animation.tick)

      math.randomseed(1)
      local integration = require("dashboard-logo.snacks").setup {
        logo = logo_name,
        effect = effect_name,
      }
      benchmark("snacks_section", { logo = logo_name, effect = effect_name }, integration.section, integration.stop)
    end
  end
end

local function timeval_ms(value)
  return value.sec * 1000 + value.usec / 1000
end

local function soak()
  local Snacks = rawget(_G, "Snacks")
  assert(Snacks and Snacks.dashboard, "soak mode requires `nvim --headless -u init.lua -l ...`")

  clear_logo_modules()
  math.randomseed(1)

  local measuring = false
  local update_started
  local previous_update
  local update_samples = {}
  local interval_samples = {}

  local group = vim.api.nvim_create_augroup("dashboard_logo_perf", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "SnacksDashboardUpdatePre",
    callback = function()
      if not measuring then return end
      local now = vim.uv.hrtime()
      if previous_update then interval_samples[#interval_samples + 1] = now - previous_update end
      previous_update = now
      update_started = now
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "SnacksDashboardUpdatePost",
    callback = function()
      if measuring and update_started then
        update_samples[#update_samples + 1] = vim.uv.hrtime() - update_started
        update_started = nil
      end
    end,
  })

  local integration = require("dashboard-logo.snacks").setup {
    update = function()
      Snacks.dashboard.update()
    end,
  }
  local dashboard = Snacks.dashboard.open {
    buf = 0,
    win = 0,
    sections = {
      integration.section,
      { section = "startup" },
    },
  }

  vim.wait(opts.warmup)
  collectgarbage "collect"
  local heap_before_kib = collectgarbage "count"
  local usage_before = vim.uv.getrusage()
  local started = vim.uv.hrtime()
  measuring = true
  vim.wait(opts.duration)
  measuring = false
  local elapsed_ns = vim.uv.hrtime() - started
  local usage_after = vim.uv.getrusage()
  local heap_after_kib = collectgarbage "count"

  vim.api.nvim_buf_delete(dashboard.buf, { force = true })
  local timer_stopped = vim.wait(opts.interval * 2 + 100, function()
    return _G.snacks_dashboard_logo_timer == nil
  end)
  integration.stop()
  vim.api.nvim_del_augroup_by_id(group)

  local interval_ms = stats(interval_samples, 1e6)
  local late_updates = 0
  for _, value in ipairs(interval_samples) do
    if value > opts.interval * 1.5 * 1e6 then late_updates = late_updates + 1 end
  end

  local elapsed_ms = elapsed_ns / 1e6
  local cpu_user_ms = timeval_ms(usage_after.utime) - timeval_ms(usage_before.utime)
  local cpu_system_ms = timeval_ms(usage_after.stime) - timeval_ms(usage_before.stime)
  emit {
    kind = "soak",
    warmup_ms = opts.warmup,
    duration_ms = elapsed_ms,
    expected_interval_ms = opts.interval,
    updates = #update_samples,
    delivered_fps = #update_samples / (elapsed_ms / 1000),
    update_ms = stats(update_samples, 1e6),
    delivered_interval_ms = interval_ms,
    late_updates = late_updates,
    cpu_user_ms = cpu_user_ms,
    cpu_system_ms = cpu_system_ms,
    cpu_percent = (cpu_user_ms + cpu_system_ms) / elapsed_ms * 100,
    max_rss_kib = usage_after.maxrss,
    heap_delta_kib = heap_after_kib - heap_before_kib,
    timer_stopped = timer_stopped,
  }
end

if opts.mode == "micro" then
  micro()
elseif opts.mode == "soak" then
  soak()
else
  error("mode must be 'micro' or 'soak'")
end

if output then output:close() end
