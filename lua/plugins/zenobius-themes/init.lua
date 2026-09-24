-- Local colorscheme plugin: zenobius-themes.
--
-- lazy.nvim imports this directory because it holds an `init.lua`. The spec
-- below points `dir` back at the same directory, so lazy puts it on the
-- runtimepath. That makes two things reachable:
--
--   colors/<name>.lua            -> `:colorscheme <name>`
--   lua/zenobius-themes/*.lua    -> `require "zenobius-themes"`
--
-- Themes in here:
--
--   mono-slate       dark, greyscale, two hues (hrdx "mono slate")
--   rose-pine-main   dark,  vendored from rose-pine/neovim
--   rose-pine-moon   dark,  vendored from rose-pine/neovim
--   rose-pine-dawn   light, vendored from rose-pine/neovim
--   rose-pine        alias: dawn when `background` is light, else main
--
-- The default theme is set by `colorscheme` in `lua/plugins/astroui.lua`.
-- `lua/zenobius-themes/init.lua` holds the list of names `:colorscheme`
-- accepts. Keep that list and `colors/` in step.

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

---@type LazySpec
return {
  {
    dir = root,
    name = "zenobius-themes",
    lazy = false,
    priority = 1000,
  },
}
