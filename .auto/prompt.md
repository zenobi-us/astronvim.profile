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
  - `redraw_fps` — full Snacks redraw rate. Baseline matches delivered FPS; highlight-only rendering may reduce this only if frame output remains correct.
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

- `lua/custom/dashboard-logo.nvim/tests/perf.lua` — benchmark implementation is locked after the frame-aware rebaseline.
- `.auto/measure.sh` and `.auto/checks.sh` — locked after the frame-aware rebaseline unless another proven measurement defect exists and is documented before editing.
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

- Baseline: 4.975% CPU, 7.122 ms full-update p95, 798.5 µs / 146.1 KiB section serialization.
- Kept: exact filtered-color result cache. CPU 4.157%; section 203.2 µs.
- Kept: cached highlight names. CPU 4.125%; section 125.1 µs.
- Kept: reused section/text entry tables. CPU 4.010%; section allocation effectively zero.
- Kept: nested source->filter tint cache keys. Current best CPU 3.879%; section 77.4 µs.
- Discarded: serialized row cache. Micro section hit 3.9 µs but CPU regressed and RSS rose; benchmark-local overfit.
- Discarded: cached dashboard buffer, per-segment highlight cache, nested highlight cache, newline-boundary Lua branch, numeric loops. No real CPU win.
- Noise calibration on identical code varied CPU by about 3%; marginal gains need confirmation.
- Measurement defect corrected before structural work: `delivered_fps` counts generated frames through `on_frame`; `redraw_fps` separately counts full Snacks updates.
- Discarded: stable mutable highlight groups. Redraws fell, but hundreds of `nvim_set_hl` calls doubled CPU.
- Kept: Snacks owns plain logo text; custom namespace owns color extmarks. Color frames no longer rebuild dashboard. CPU fell to ~3.0%.
- Kept: skip whitespace-only foreground extmarks, precompute segment visibility, merge adjacent equal-highlight spans. CPU fell to ~2.7% before geometry work.
- Kept: direct single-pane geometry row updates with multi-pane full-update fallback. Full redraw rate reached zero and CPU fell to ~2.0%.
- Kept: reusable extmark options table plus deterministic geometry differential test and README contract.
- Discarded: extmark ID reuse and cached logo columns; both regressed CPU. Namespace clear + recreate and inline position discovery are faster.
- Current best: 2.000% CPU, 11.23 delivered FPS, 0 full redraw FPS, ~39 MiB max RSS. Improvement versus frame-aware baseline: ~51.6% CPU and ~25% RSS.
- Current run-to-run noise around the best is roughly 2–6%; require material gains or repeated confirmation.
