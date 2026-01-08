-- Terminal manager for floating and split terminals
---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup()
  end,
}
