-- Display symbol usage in code
---@type LazySpec
return {
  "Wansmer/symbol-usage.nvim",
  event = "BufReadPre",
  config = function() require("symbol-usage").setup() end,
}
