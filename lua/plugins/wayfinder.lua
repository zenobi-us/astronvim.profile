-- Plugin: wayfinder.nvim
-- Description: Guided code exploration for current symbol/file
-- URL: https://github.com/error311/wayfinder.nvim
---@type LazySpec
return {
  "error311/wayfinder.nvim",
  cmd = { "Wayfinder" },
  opts = {
    layout = {
      width = 0.88,
      height = 0.72,
    },
  },
}
