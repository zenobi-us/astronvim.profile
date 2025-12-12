local astrocore = require "astrocore"

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
  -- create the menu entries
  -- top level key,value pairs are Record<GroupID,MenuItem[]>
  for GroupId, MenuItems in pairs(options.menus) do
    if not GroupId or GroupId == "" then
      astrocore.notify("Menu GroupId is required.", vim.log.levels.ERROR)
      return
    end
    -- menus
    M.render.menu(GroupId, MenuItems)
  end
end

M.config = M.setup

return M
