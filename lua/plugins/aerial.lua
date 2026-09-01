-- Override AstroNvim's aerial.nvim pin (^2.2) to get the iter_matches fix
-- from 3.0.0+, required for Neovim's changed treesitter query API.
---@type LazySpec
return {
  "stevearc/aerial.nvim",
  version = "v4.0.0",
}
