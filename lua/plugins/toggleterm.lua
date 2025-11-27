return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup()

    -- Auto-enter insert mode when focusing toggleterm buffer
    local group = vim.api.nvim_create_augroup("ToggletermInsertMode", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      group = group,
      callback = function()
        if vim.bo.buftype == "terminal" or vim.bo.filetype == "toggleterm" then
          -- Use vim.schedule to defer the startinsert call
          vim.schedule(function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>i", true, true, true), "n", false)
          end)
        end
      end,
    })
  end,
}
