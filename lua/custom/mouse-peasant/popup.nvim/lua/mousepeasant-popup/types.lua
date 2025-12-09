---@class MenuOptions
---@field condition? fun(): boolean  A function that returns true if the menu item should be displayed

---@class MenuItemWithSubItems
---@field label string
---@field items MenuItem[]
---@field options? MenuOptions
---@field type '"menu"'

---@class MenuItemWithCommand
---@field label string
---@field command function
---@field options? MenuOptions
---@field type '"command"'

---@alias MenuItem MenuItemWithSubItems|MenuItemWithCommand

---@class PopupOptions
---@field menus MenuItem[] List of menu items to register
