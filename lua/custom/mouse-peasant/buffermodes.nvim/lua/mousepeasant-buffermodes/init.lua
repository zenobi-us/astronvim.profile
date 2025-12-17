---@type LazySpec
local M = {
  setup = function() end,
  config = function() end,
  on_enter_buffer = function() end,
}

---@class BufferModeProps
---@field buftype string
---@field filetype string

local setup_done = false

local has_astrocore, astrocore = pcall(require, "astrocore")

-- Store mode state for non-managed buffers
local buffer_mode_cache = {}

M.opts = {
  -- Default buffer mode configuration
  buffer_modes = {},
}

local function set_insert_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
end

local function set_normal_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end
local function set_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", false)
end

-- This mapping allows users to be a bit lazy in how they specify modes
local MODE_FUNC = {
  insert = set_insert_mode,
  i = set_insert_mode,
  normal = set_normal_mode,
  n = set_normal_mode,
  visual = set_visual_mode,
  v = set_visual_mode,
}

---@type fun(conf: table)
local function configure(conf)
  if setup_done then return end

  M.opts = conf

  if not has_astrocore then
    vim.notify("BufferModes: astrocore not found, please install astrocore for notifications", vim.log.levels.WARN)
    return
  end

  local group = vim.api.nvim_create_augroup("BufferModes", { clear = true })

  -- Save mode when leaving a buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local current_mode = vim.fn.mode()
      buffer_mode_cache[bufnr] = current_mode
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermEnter" }, {
    group = group,
    callback = function()
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype
      local props = {
        buftype = buftype,
        filetype = filetype,
      }

      local bufnr = vim.api.nvim_get_current_buf()

      -- Debug output
      if M.opts.debug then
        astrocore.notify(
          "BufferModes Debug: buftype='" .. props.buftype .. "' filetype='" .. props.filetype .. "'",
          vim.log.levels.DEBUG
        )
      end

      -- Try to find mode from opts, then from saved cache
      local target_mode = M.opts.buffer_modes[props.filetype]
      local target_match = "buffertype"

      if not target_mode then
        target_mode = M.opts.buffer_modes[props.buftype]
        target_match = "buftype"
      end

      if not target_mode then
        target_mode = buffer_mode_cache[bufnr]
        target_match = "cache"
      end

      if M.opts.debug then
        astrocore.notify(
          "BufferModes \n"
            .. "  Target match: "
            .. target_match
            .. "\n"
            .. "  BuferNo: "
            .. bufnr
            .. "\n"
            .. "  Buftype: '"
            .. props.buftype
            .. "'\n"
            .. "  Target mode: '"
            .. (target_mode or "nil"),
          vim.log.levels.DEBUG,
          {}
        )
      end

      -- set the mode
      -- vim.schedule(function() vim.api.nvim_feedkeys(mapped_mode, "n", false) end)
      --
      vim.schedule(function()
        local mode_func = MODE_FUNC[target_mode]
        if mode_func then
          mode_func()
        else
          astrocore.notify("BufferModes: No function mapped for target mode", vim.log.levels.WARN)
        end
      end)
    end,
  })

  setup_done = true
end

---@type fun(conf: table)
M.config = function(conf) configure(conf) end

---@type fun(conf: table)
M.setup = function(conf) configure(conf) end

return M
