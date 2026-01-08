-- Automatic buffer mode switching (insert/normal)
---@type LazySpec
return {
  "mouse-peasant/buffermodes.nvim",
  dir = vim.env.HOME .. "/.config/nvim/lua/custom/mouse-peasant/buffermodes.nvim",
  opts = {
    debug = false,
    buffer_modes = {
      terminal = "insert",
      toggleterm = "insert",
      sidekick_terminal = "insert",
      ["neo-tree"] = "normal",
    },
  },
}
