*dashboard-logo.txt*  Animated dashboard logo

===============================================================================
USAGE                                                     *dashboard-logo-usage*

Neovim: >lua
  local logo = require("dashboard-logo.snacks").setup {
    effect = "glitch", -- or "none"
    update = function() require("snacks").dashboard.update() end,
  }
  local section = logo.section
<

Standalone preview: >sh
  ./lua/custom/dashboard-logo.nvim/cli.lua --watch
<

The watch preview reloads the logo module every frame, so saved edits appear
without restarting the command. It uses plain Lua and ANSI terminal colours;
Neovim is not loaded. Press CTRL-C to stop it.

Logo line data lives under `lua/dashboard-logo/logos/`. New logos must be
added to `logos/init.lua`; select one with `setup { logo = "name" }`.

Effects live under `lua/dashboard-logo/effects/`. Add an effect to
`effects/init.lua`; select one with `setup { effect = "name" }`.

vim:tw=78:ts=8:noet:ft=help:norl: