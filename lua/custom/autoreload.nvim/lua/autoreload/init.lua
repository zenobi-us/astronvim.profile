---@class AutoReloadOptions
---@field events string[]
---@field notify_on_reload boolean

---@type LazySpec
local M = {
  opts = {
    events = { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" },
    notify_on_reload = true,
  },
}

local setup_done = false

---@param opts? AutoReloadOptions
function M.setup(opts)
  if setup_done then return end

  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.o.autoread = true

  local group = vim.api.nvim_create_augroup("CustomAutoReload", { clear = true })

  vim.api.nvim_create_autocmd(M.opts.events, {
    group = group,
    pattern = "*",
    callback = function()
      if vim.fn.mode() == "c" then return end
      vim.cmd "checktime"
    end,
  })

  if M.opts.notify_on_reload then
    vim.api.nvim_create_autocmd("FileChangedShellPost", {
      group = group,
      pattern = "*",
      callback = function()
        vim.notify("File reloaded from disk: " .. vim.fn.expand "<afile>", vim.log.levels.INFO)
      end,
    })
  end

  setup_done = true
end

M.config = M.setup

return M
