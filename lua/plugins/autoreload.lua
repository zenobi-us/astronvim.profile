-- Built-in safe autoread/checktime integration
---@type LazySpec
return {
  "custom/autoreload.nvim",
  dir = vim.env.HOME .. "/.config/nvim/lua/custom/autoreload.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    notify_on_reload = true,
  },
}
