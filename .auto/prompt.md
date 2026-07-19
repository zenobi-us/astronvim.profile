# Autoresearch: Reduce dashboard-logo animation load

## Objective

Reduce CPU load and transient allocation caused by the animated `dashboard-logo.nvim` Snacks dashboard integration. Preserve the visible default `grudge_axe` + `glitch` animation, its 90 ms cadence, and normal dashboard lifecycle.

The dominant runtime path is:

```text
90 ms timer -> animation.tick() -> section serialization -> Snacks.dashboard.update()
             -> whole dashboard layout/buffer/extmark rebuild
```

Do not optimize only synthetic core math while regressing the real Snacks dashboard workload.

## Metrics

- **Primary**: `cpu_percent` (lower is better) — median process CPU percentage across three real-config 3-second dashboard soaks after 1-second warmup.
- **Secondary**:
  - `update_p95_ms` — median p95 full Snacks redraw duration.
  - `section_mean_us` — default grudge-axe/glitch section serialization mean.
  - `section_alloc_kib` — section serialization allocation per call.
  - `core_mean_us` — default grudge-axe/glitch core tick mean.
  - `delivered_fps` — timer delivery guard; MUST remain between 10 and 13 FPS.
  - `max_rss_kib` — median peak resident memory.

## How to Run

```sh
./.auto/measure.sh
```

It emits `METRIC name=value` lines consumed by autoresearch.

Correctness checks run automatically from `.auto/checks.sh` after a passing measurement.

## Files in Scope

- `lua/custom/dashboard-logo.nvim/lua/dashboard-logo/init.lua` — core render/animation composition.
- `lua/custom/dashboard-logo.nvim/lua/dashboard-logo/snacks.lua` — timer, section serialization, highlights, Snacks integration.
- `lua/custom/dashboard-logo.nvim/lua/dashboard-logo/effects/glitch.lua` — default animation effect.
- `lua/custom/dashboard-logo.nvim/lua/dashboard-logo/logos/init.lua` — ANSI logo loading/parsing, only for cold-load experiments.

Prefer changes in `snacks.lua`; measured evidence says full redraw and per-segment serialization dominate.

## Off Limits

- `lua/custom/dashboard-logo.nvim/tests/perf.lua` — benchmark implementation is locked after baseline.
- `.auto/measure.sh` and `.auto/checks.sh` — locked after baseline unless a proven measurement defect exists and is documented before editing.
- `lua/plugins/snacks.lua` — user-facing integration and cadence contract.
- ANSI/GIF assets.
- Installed `snacks.nvim` source.
- Tests may not be weakened or removed.
- No benchmark-specific branches in production code.

## Constraints

- MUST preserve default visible animation output and 90 ms interval.
- MUST sustain 10–13 delivered updates/second in each soak. Lower FPS is not an optimization.
- MUST keep one global timer maximum and stop it after dashboard closure.
- MUST pass generation and lifecycle tests.
- MUST NOT add dependencies.
- MUST NOT skip Snacks redraws merely to improve the primary metric unless equivalent visible output is updated through a cheaper real rendering path.
- MUST change one performance variable per experiment.
- MUST treat microbenchmarks as diagnostics, not the optimization target.
- SHOULD prefer deletion, caching immutable work, and narrower redraw boundaries over new abstraction.
- SHOULD discard gains within noise unless repeated.

## What's Been Tried

- Baseline instrumentation created. No optimization experiments yet.
- Prior reconnaissance measured core tick as cheap, section serialization as material, and whole Snacks redraw as dominant.
