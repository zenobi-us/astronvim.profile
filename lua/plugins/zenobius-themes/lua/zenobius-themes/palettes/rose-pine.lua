-- Palettes for the vendored `rose-pine` colorschemes.
--
-- Copied verbatim from rose-pine/neovim, `lua/rose-pine/palette.lua`, at the
-- commit pinned in `lazy-lock.json` before that plugin was dropped.
-- Upstream is MIT licensed. Re-copy this file to pick up upstream changes.
--
-- Upstream resolves the variant at runtime from `options.variant` and
-- `vim.o.background`. Here each variant is a plain table and the caller names
-- the one it wants, so there is no runtime lookup.

---@alias RosePineVariant "main" | "moon" | "dawn"

return {
  main = {
    _nc = "#16141f", -- only used when `dim_inactive_windows` is on, which this port does not support
    base = "#191724",
    surface = "#1f1d2e",
    overlay = "#26233a",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ebbcba",
    pine = "#31748f",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    leaf = "#95b1ac",
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
    none = "NONE",
  },
  moon = {
    _nc = "#1f1d30",
    base = "#232136",
    surface = "#2a273f",
    overlay = "#393552",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ea9a97",
    pine = "#3e8fb0",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    leaf = "#95b1ac",
    highlight_low = "#2a283e",
    highlight_med = "#44415a",
    highlight_high = "#56526e",
    none = "NONE",
  },
  dawn = {
    _nc = "#f8f0e7",
    base = "#faf4ed",
    surface = "#fffaf3",
    overlay = "#f2e9e1",
    muted = "#9893a5",
    subtle = "#797593",
    text = "#464261",
    love = "#b4637a",
    gold = "#ea9d34",
    rose = "#d7827e",
    pine = "#286983",
    foam = "#56949f",
    iris = "#907aa9",
    leaf = "#6d8f89",
    highlight_low = "#f4ede8",
    highlight_med = "#dfdad9",
    highlight_high = "#cecacd",
    none = "NONE",
  },
}
