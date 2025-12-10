local M = {}

-- State: track the cut file/folder
local cut_state = {
  path = nil,
  original_name = nil,
}

local function get_node_under_cursor()
  local neo_tree = require("neo-tree.sources.filesystem")
  local state = neo_tree.state
  if not state or not state.winid or not vim.api.nvim_win_is_valid(state.winid) then
    return nil
  end
  local node = state.tree:get_node()
  return node
end

local function dim_node(node)
  if not node then
    return
  end
  -- Apply extmark with dim highlight group
  local bufnr = vim.fn.winbufnr(require("neo-tree.sources.filesystem").state.winid)
  if bufnr == -1 then
    return
  end

  -- Create dim highlight if it doesn't exist
  local hl_group = "NeotreeCutFile"
  local ok = pcall(vim.api.nvim_get_hl, 0, { name = hl_group })
  if not ok then
    vim.api.nvim_set_hl(0, hl_group, { fg = "#666666", italic = true })
  end

  -- Apply to the node's line
  if node.extra and node.extra.line then
    vim.api.nvim_buf_set_extmark(bufnr, vim.api.nvim_create_namespace("neotree-cut"), node.extra.line - 1, 0, {
      line_hl_group = hl_group,
    })
  end
end

-- Unused for now, but kept for future enhancement
-- local function undim_node(node)
--   if not node then
--     return
--   end
--   -- Clear extmarks for the node's line
--   local bufnr = vim.fn.winbufnr(require("neo-tree.sources.filesystem").state.winid)
--   if bufnr == -1 then
--     return
--   end
--   if node.extra and node.extra.line then
--     vim.api.nvim_buf_clear_namespace(bufnr, vim.api.nvim_create_namespace("neotree-cut"), node.extra.line - 1, node.extra.line)
--   end
-- end

local function cut_file()
  local node = get_node_under_cursor()
  if not node then
    require("astrocore").notify("No file selected", vim.log.levels.WARN)
    return
  end

  -- If there was a previous cut, clear its dim
  if cut_state.path then
    require("astrocore").notify("Previous cut forgotten, now cutting: " .. vim.fn.fnamemodify(node.path, ":t"), vim.log.levels.INFO)
  end

  cut_state.path = node.path
  cut_state.original_name = node.name

  dim_node(node)
  require("astrocore").notify("Cut: " .. node.path, vim.log.levels.INFO)
end

local function paste_file()
  if not cut_state.path then
    require("astrocore").notify("Nothing to paste. Cut a file first.", vim.log.levels.WARN)
    return
  end

  local target_node = get_node_under_cursor()
  if not target_node then
    require("astrocore").notify("No target selected", vim.log.levels.WARN)
    return
  end

  local target_dir
  if target_node.type == "directory" then
    target_dir = target_node.path
  else
    -- File: use parent directory (sibling)
    target_dir = vim.fn.fnamemodify(target_node.path, ":h")
  end

  -- Check if pasting to the same location
  local cut_parent = vim.fn.fnamemodify(cut_state.path, ":h")
  if cut_parent == target_dir then
    require("astrocore").notify("File already in this location", vim.log.levels.WARN)
    return
  end

  -- Compute destination path
  local filename = vim.fn.fnamemodify(cut_state.path, ":t")
  local dest_path = vim.fn.fnamemodify(target_dir .. "/" .. filename, ":p")

  -- Move the file
  local ok, err = os.rename(cut_state.path, dest_path)
  if not ok then
    require("astrocore").notify("Failed to move: " .. (err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  -- Clear cut state
  cut_state.path = nil
  cut_state.original_name = nil

  -- Refresh neo-tree and notify
  require("neo-tree.sources.filesystem").state.tree:render()
  require("astrocore").notify("Moved to: " .. dest_path, vim.log.levels.INFO)
end

local function clear_cut()
  cut_state.path = nil
  cut_state.original_name = nil
end

-- Popup menu definition (commands must be Vim command strings, not functions)
M.menu = {
  {
    label = "Cut",
    command = "<cmd>lua require('plugins.popups.neotree').cut_file()<cr>",
    condition = function()
      return true
      -- return get_node_under_cursor() ~= nil
    end,
  },
  {
    label = "Paste",
    command = "<cmd>lua require('plugins.popups.neotree').paste_file()<cr>",
    condition = function()
      return true
      -- return cut_state.path ~= nil and get_node_under_cursor() ~= nil
    end,
  },
}

-- Export functions
M.cut_file = cut_file
M.paste_file = paste_file
M.clear_cut = clear_cut
M.get_cut_state = function()
  return cut_state
end

-- Clear cut state when neo-tree closes
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(event)
    local bufname = vim.api.nvim_buf_get_name(event.buf)
    if bufname:match("neo%-tree") then
      clear_cut()
    end
  end,
})

return M
