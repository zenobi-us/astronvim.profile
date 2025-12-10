
local astrocore = require "astrocore"

local M = {}

M.constants = require "mousepeasant-popup.constants"
M.predicate = require "mousepeasant-popup.predicate"
M.render = require "mousepeasant-popup.render"

M.store = require "mousepeasant-popup.store"

M.render.clear_menu "PopUp"

-- tmp setup function
M.opts = {
  events = { "BufEnter" },
}


---@type fun(opts: PopupOptions)
M.setup = function(opts)
  M.opts = vim.tbl_extend("force", M.constants.DEFAULTS, opts or {})
  astrocore.notify("MousePeasant Popup initialized \n" .. vim.inspect(M.opts))

  -- menus
  local menus = opts.menus or {}
  for _, menu in ipairs(menus) do
    M.store.create_menu(menu)
  end

  M.render.menu {
    events = M.opts.events,
    menus = M.store.db,
  }

end
M.config = M.setup


return M
