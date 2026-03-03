-- Plugin: flatten.nvim
-- Description: Open files from terminal buffers in parent neovim instance
-- URL: https://github.com/willothy/flatten.nvim
---@type LazySpec
return {
  "willothy/flatten.nvim",
  -- Ensure it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
  opts = function()
    ---@type Terminal?
    local saved_terminal

    return {
      window = {
        -- Open files in alternate window (not the terminal)
        open = "alternate",
      },
      hooks = {
        should_block = function(argv)
          -- Block if we find the `-b` flag
          -- Allows `nvim -b file1` for blocking mode
          return vim.tbl_contains(argv, "-b")
        end,
        pre_open = function()
          -- Save the current terminal if using toggleterm
          local ok, term = pcall(require, "toggleterm.terminal")
          if ok then
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end
        end,
        post_open = function(bufnr, winnr, ft, is_blocking)
          if is_blocking and saved_terminal then
            -- Hide the terminal while it's blocking
            saved_terminal:close()
          else
            -- If it's a normal file, just switch to its window
            vim.api.nvim_set_current_win(winnr)
          end

          -- Auto-delete git commit buffer on write
          if ft == "gitcommit" or ft == "gitrebase" then
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = vim.schedule_wrap(function()
                vim.api.nvim_buf_delete(bufnr, {})
              end),
            })
          end
        end,
        block_end = function()
          -- After blocking ends (git commit, etc), reopen the terminal
          vim.schedule(function()
            if saved_terminal then
              saved_terminal:open()
              saved_terminal = nil
            end
          end)
        end,
      },
    }
  end,
}
