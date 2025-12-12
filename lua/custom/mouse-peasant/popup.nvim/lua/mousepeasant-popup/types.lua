---@class MenuOptions
---@field condition? fun(): boolean  A function that returns true if the menu item should be displayed

---@class MenuItemBase
---@field label string
---@field options? MenuOptions

---@class MenuItemWithSubItems: MenuItemBase
---@field items MenuItem[]

---@class MenuItemSeparator
---@field separator true

---@class MenuItemWithCommand: MenuItemBase
---@field command function

---@alias MenuItem MenuItemWithSubItems|MenuItemWithCommand|MenuItemSeparator

---@class PopupOptions
---@field menus MenuItem[] List of menu items to register
---

local M = {}

---@param item MenuItem
M.isMenuItemWithSubmenu = function(item) return item.items ~= nil end

---@param item MenuItem
M.isMenuItemWithCommand = function(item) return item.command ~= nil end

---@param item MenuItem
M.isMenuItemSeparator = function(item) return item.separator == true end

---@param item MenuItem
M.isMenuItem = function(item)
  return M.isMenuItemWithSubmenu(item) or M.isMenuItemWithCommand(item) or M.isMenuItemSeparator(item)
end

---@param options MenuOptions
M.isMenuOptions = function(options) return options ~= nil and type(options) == "table" end

return M
