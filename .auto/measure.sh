#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

perf_script="lua/custom/dashboard-logo.nvim/tests/perf.lua"
results="$(mktemp)"
trap 'rm -f "$results"' EXIT

luajit -e "assert(loadfile('$perf_script'))"

nvim --headless -u NONE -l "$perf_script" micro \
  --iterations=500 --warmup=100 --label=measure --output="$results" \
  >/dev/null 2>&1

for run in 1 2 3; do
  nvim --headless -u init.lua -l "$perf_script" soak \
    --duration=3000 --warmup=1000 --interval=90 \
    --label="soak-$run" --output="$results" \
    >/dev/null 2>&1
done

jq -e '
  [ .[] | select(.kind == "soak") ] as $soaks
  | ($soaks | length == 3)
    and ($soaks | all(.timer_stopped == true))
    and ($soaks | all(.delivered_fps >= 10 and .delivered_fps <= 13))
' < <(jq -s '.' "$results") >/dev/null

median() {
  jq -s -r "[.[] | $1] | sort | .[length / 2 | floor]" "$results"
}

cpu_percent="$(median 'select(.kind == "soak") | .cpu_percent')"
update_p95_ms="$(median 'select(.kind == "soak") | .update_ms.p95')"
delivered_fps="$(median 'select(.kind == "soak") | .delivered_fps')"
max_rss_kib="$(median 'select(.kind == "soak") | .max_rss_kib')"
section_mean_us="$(median 'select(.benchmark == "snacks_section" and .case.logo == "grudge_axe" and .case.effect == "glitch") | .timing_us.mean')"
section_alloc_kib="$(median 'select(.benchmark == "snacks_section" and .case.logo == "grudge_axe" and .case.effect == "glitch") | .allocated_kib_per_call')"
core_mean_us="$(median 'select(.benchmark == "core_tick" and .case.logo == "grudge_axe" and .case.effect == "glitch") | .timing_us.mean')"

printf 'METRIC cpu_percent=%s\n' "$cpu_percent"
printf 'METRIC update_p95_ms=%s\n' "$update_p95_ms"
printf 'METRIC section_mean_us=%s\n' "$section_mean_us"
printf 'METRIC section_alloc_kib=%s\n' "$section_alloc_kib"
printf 'METRIC core_mean_us=%s\n' "$core_mean_us"
printf 'METRIC delivered_fps=%s\n' "$delivered_fps"
printf 'METRIC max_rss_kib=%s\n' "$max_rss_kib"
