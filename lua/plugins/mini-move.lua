-- Move text around with Ctrl+Shift+Arrow keys
---@type LazySpec
return {
  "echasnovski/mini.move",
  opts = {
    mappings = {
      -- Use Ctrl+Shift+Arrow keys for all directions
      left = "<C-S-Left>",
      right = "<C-S-Right>",
      up = "<C-S-Up>",
      down = "<C-S-Down>",
      line_left = "<C-S-Left>",
      line_right = "<C-S-Right>",
      line_up = "<C-S-Up>",
      line_down = "<C-S-Down>",
    },
  },
}
