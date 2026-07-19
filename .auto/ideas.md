# Deferred ideas

- Replace global whole-dashboard update with a dedicated incremental extmark/highlight rendering path if local caching cannot reduce real CPU enough.
- Lazy-load only the selected ANSI logo to reduce cold startup cost; separate target from steady-state animation CPU.
- Add direct dashboard close event cleanup instead of visibility polling; reliability improvement, probably minor CPU impact.
