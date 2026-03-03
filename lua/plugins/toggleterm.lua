-- Plugin: toggleterm.nvim
-- Description: Terminal manager for floating and split terminals
-- URL: https://github.com/akinsho/toggleterm.nvim
---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    })

    -- Lazygit floating terminal
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
      close_on_exit = true,
    })

    function _G.lazygit_toggle()
      lazygit:toggle()
    end

    vim.keymap.set("n", "<leader>gg", lazygit_toggle, { desc = "Toggle Lazygit" })
  end,
}
