---@type LazySpec
local M = {}

local setup_done = false

local has_astrocore, astrocore = pcall(require, "astrocore")

-- Store mode state for non-managed buffers
local buffer_mode_cache = {}

M.opts = {
  -- Default buffer mode configuration
  buffer_modes = {},
}

local LOGICAL_MODE_MAPPING = {
  insert = "i",
  i = "i",
  normal = "n",
  n = "n",
  visual = "v",
  v = "v",
}

---@type fun(conf: table)
M.config = function(conf)
  if setup_done then return end

  -- merge defaults with user config
  M.opts = vim.tbl_deep_extend("force", M.opts, conf or {})

  if not has_astrocore then
    vim.notify("BufferModes: astrocore not found, please install astrocore for notifications", vim.log.levels.WARN)
    return
  end

  astrocore.notify("BufferModes: Initializing with:", vim.inspect(conf))

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
   
   vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
     group = group,
     callback = function()
       local buftype = vim.bo.buftype
       local filetype = vim.bo.filetype
       M.on_enter_buffer { buftype = buftype, filetype = filetype }
     end,
   })
end

M.setup = function(conf)
  astrocore.notify "BufferModes: Setup called"
  astrocore.notify("BufferModes: Conf:", vim.inspect(conf))
  astrocore.notify("BufferModes: ", vim.inspect(M))
  M.config(conf)
  setup_done = true
end

---@class BufferModeProps
---@field buftype string
---@field filetype string

---@type fun(props: BufferModeProps)
M.on_enter_buffer = function(props)
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Try to find mode from opts, then from saved cache
  local target_mode = M.opts.buffer_modes[props.filetype] or M.opts.buffer_modes[props.buftype]
    or buffer_mode_cache[bufnr]
  
  -- Return early if no mode found
  if not target_mode then return end
  
  -- Map logical mode names to mode codes
  local mapped_mode = LOGICAL_MODE_MAPPING[target_mode]
  if not mapped_mode then
    astrocore.notify(
      "BufferModes: Unknown target mode '" .. target_mode .. "'. Valid modes: insert, normal, visual",
      vim.log.levels.WARN
    )
    return
  end
  
  -- Apply the mode
  if mapped_mode == "i" then
    vim.cmd("startinsert")
  else
    vim.cmd("stopinsert")
  end
end

return M
