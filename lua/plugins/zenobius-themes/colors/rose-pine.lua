-- Entry point for `:colorscheme rose-pine`.
--
-- Upstream treats the bare name as "pick by background": dawn when
-- `background` is light, main when it is dark. It never changes `background`
-- itself. This file keeps that rule.
--
-- The resolved variant sets `g:colors_name`, so after `:colorscheme rose-pine`
-- the name reads `rose-pine-main` or `rose-pine-dawn`. Neovim does not
-- overwrite `g:colors_name`, and naming the variant says which one is live.
require("zenobius-themes").load(vim.o.background == "light" and "rose-pine-dawn" or "rose-pine-main")
