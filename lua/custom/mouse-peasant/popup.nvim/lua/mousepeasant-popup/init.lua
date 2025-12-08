local M = {}
M.constants = require "user.core.popup.constants"
M.predicate = require "user.core.popup.predicate"
M.render = require "user.core.popup.render"

M.store = require("user.core.popup.store").store
M.register = require("user.core.popup.store").register

M.render.clear_menu "PopUp"

-- tmp setup function
M.opts = {}
---@type fun(opts: PopupOptions)
M.setup = function(opts)
  M.opts = vim.tbl_extend("force", M.constants.DEFAULTS, opts or {})

  -- menus
  local menus = opts.menus or {}
  for _, menu in ipairs(menus) do
    M.create_menu(menu)
  end
end
M.config = M.setup

return M
