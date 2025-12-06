---@type LazySpec
return {
  "mouse-peasant/buffermodes",
  ---@class BufferModesOpts
  ---@field buffer_modes table<string, "insert"|"normal">
  opts = {
    -- Default buffer mode configuration
    buffer_modes = {
      terminal = "insert",
      toggleterm = "insert",
      sidekick = "insert",
    },
  },
  config = function(_, opts)
    local buffer_modes = opts.buffer_modes

    local group = vim.api.nvim_create_augroup("BufferModes", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      group = group,
      callback = function()
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype
        local target_mode = buffer_modes[filetype] or buffer_modes[buftype]

        if target_mode then
          -- vim.schedule defers the mode change to the next redraw cycle.
          -- This ensures the buffer is fully initialized before we attempt mode switching,
          -- preventing race conditions where the feedkeys might execute before Neovim
          -- has finished entering the buffer (particularly important for terminal buffers).
          vim.schedule(function()
            -- Only change mode if we're not already in the target mode.
            -- This avoids unnecessary feedkey calls and visual flickering.
            if target_mode == "insert" and vim.fn.mode() ~= "i" then
              -- Exit any mode (Normal, Visual, etc.) and enter insert mode.
              -- <C-\><C-N> reliably returns to Normal mode from any state,
              -- then 'i' enters insert mode.
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>i", true, true, true), "n", false)
            elseif target_mode == "normal" and vim.fn.mode() == "i" then
              -- Exit insert mode and enter normal mode.
              -- <C-\><C-N> is the standard terminal escape sequence.
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "n", false)
            end
          end)
        end
      end,
    })
  end,
}
