-- This module stores the registered menu items
-- @module core.popup.store
-- @alias M
local M = {}

M.db = {}

--- Register one or more items
M._register = function(...)
  local items = { ... }
  for _, item in ipairs(items) do
    table.insert(M.db, item)
  end
end

---@type fun(menu_item: MenuItem)
M.create_menu = function(menu_item)
  M._register {
    label = menu_item.label,
    command = menu_item.command,
    items = menu_item.items,
    options = menu_item.options,
  }
end

--- Clear all registered menu items
-- @see core.popup.render.clear_menu
-- @usage
-- popup.store.clear()
M.clear = function() M.db = {} end

return M
