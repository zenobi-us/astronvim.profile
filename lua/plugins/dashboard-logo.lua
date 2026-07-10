-- Plugin: dashboard-logo.nvim
-- Description: Animated dashboard logo shared by Snacks and a standalone terminal CLI
-- URL: local
---@type LazySpec
return {
  "custom/dashboard-logo.nvim",
  dir = vim.env.HOME .. "/.config/nvim/lua/custom/dashboard-logo.nvim",
  lazy = true,
}
