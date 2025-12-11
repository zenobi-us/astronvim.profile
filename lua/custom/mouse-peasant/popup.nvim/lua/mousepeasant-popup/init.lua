local M = {}

M.constants = require "mousepeasant-popup.constants"
M.predicate = require "mousepeasant-popup.predicate"
M.render = require "mousepeasant-popup.render"

M.render.clear_menu "PopUp"

-- tmp setup function
M.opts = {
  events = { "BufEnter" },
  menus = {},
}

--- @param opts PopupOptions
M.setup = function(opts)
  local options = vim.tbl_extend("force", M.constants.DEFAULTS, opts or {})

  -- menus
  local menus = options.menus or {}

  M.render.menu {
    events = options.events,
    menus = menus,
  }
end

M.config = M.setup

return M
