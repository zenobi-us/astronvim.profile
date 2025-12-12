-- Popup menu rendering logic
--
-- Neovim's menu system is a bit clunky, so we have to do some workarounds
-- to get it to work properly.
--
-- The way it works is that you were expected to have a series of statically defined
-- menus in your vimrc.
-- Defined with a series of :menu commands.
--
-- eg:
--  :amenu PopUp.File.New :echo "New File"<CR>
--  :amenu PopUp.File.Open :echo "Open File"<CR>
--  :amenu PopUp.Edit.Copy :echo "Copy"<CR>
--  :amenu PopUp.Edit.Paste :echo "Paste"<CR>
local astrocore = require "astrocore"

local Constants = require "mousepeasant-popup.constants"
local Predicates = require "mousepeasant-popup.predicate"
local Types = require "mousepeasant-popup.types"
local Log = require "mousepeasant-popup.logging"
local R = {}

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
local function escape_label(label)
  local res = string.gsub(label, " ", [[\ ]])
  res = string.gsub(res, "<", [[\<]])
  res = string.gsub(res, ">", [[\>]])
  return res
end

-- a function that removes all non alphanumeric characters from a string and replaces spaces with underscores
local function slugify(label) return string.gsub(label, "[^%w%s]", ""):gsub("%s+", "_") end

--- Clear all entries from the given menu
---@param menu string
R.clear_menu = function(menu) return "aunmenu " .. menu end

R.label = function(item)
  --merge with R.DEFAULTS if not nil
  local options = vim.tbl_extend("force", Constants.DEFAULTS, item.options or {})

  local width = options.min_menu_item_width

  -- do we show the command in the menu?
  local show_help = options.show_help or false

  -- safely handle missing label
  local label = item.label or ""

  -- calculate the padding from the original text of the label
  local padding = width - #label

  if padding < width then padding = width end

  if item.items ~= nil and options.submenu_indicator ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    return label .. string.rep(" ", padding - #options.submenu_indicator) .. options.submenu_indicator
  end

  if item.command == "<Nop>" or item.command == nil then return label .. string.rep(" ", padding) end

  return label .. string.rep(" ", padding - #item.command) .. (show_help and item.command or "")
end

-- should the menu item render or not
R.should_menu_item_display = function(menu)
  -- if menu has a condition and it's a function,
  -- bail out of rendering it anew,
  -- and just return the menu as is
  if menu.condition ~= nil and type(menu.condition) == "function" then return menu.condition(Predicates) end
  return true
end

-- Create a menu item
--
-- Menu items can be of two kinds:
--
-- - the main PopUp entry
-- - an entry in a submenu
--
-- The main PopUp entry is the one that shows up in the context menu.
-- It's the one that has the label of the context menu.
-- and is the one that has the command that opens the submenu.
--
-- The submenu entries are the ones that show up when you click on the main PopUp entry.
-- They're the ones that have the label of the submenu, and are the ones that have the
-- command that does something.

R.menu_action = function(menu)
  -- if not R.should_menu_item_display(menu) then return {} end

  -- skip if no command is defined
  if not Types.isMenuItemWithCommand(menu) then return {} end

  local entry = {}

  -- create the menu entry for each mode
  for _, mode in ipairs(menu.modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. "." .. escape_label(R.label(menu)) .. " " .. menu.command
    entry[#entry + 1] = cmd
  end

   Log.debug("Created menu action for: " .. menu.label .. " with command: " .. menu.command .. " \n" .. vim.inspect(entry))

  return entry
end

R.menu_popup = function(menu)
  -- if not R.should_menu_item_display(menu) then return {} end
  local entry = {}

  -- generate a popup id
  local popupId = slugify(menu.label)

  -- allows the submenu to be opened with the mouse
  menu.command = "<cmd> popup " .. popupId .. "<cr>"
  local action_cmds = R.menu_action(menu)
  if action_cmds then vim.list_extend(entry, action_cmds) end

  for _, item in ipairs(menu.items) do
    -- anchor all children to this popupid
    item.groupid = popupId
    -- merge with parent options
    item.options = vim.tbl_extend("force", menu.options or {}, item.options or {})
    -- fork to decide if it's a submenu or a menu item
    local item_cmds = R.menu_item(item)
    if item_cmds then vim.list_extend(entry, item_cmds) end
  end

  return entry
end

R.menu_separator = function(menu)
  if not R.should_menu_item_display(menu) then return {} end

  local entry = {}

  -- create the menu entry for each mode
  for _, mode in ipairs(menu.modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. ".-1- <Nop>"
    entry[#entry + 1] = cmd
  end

  return entry
end

R.menu_item = function(menu)
  if not Types.isMenuItem(menu) then return end

  if Types.isMenuItemWithSubmenu(menu) then return R.menu_popup(menu) end

  if Types.isMenuItemWithCommand(menu) then return R.menu_action(menu) end

  if Types.isMenuItemSeparator(menu) then return R.menu_separator(menu) end

   Log.error("Invalid menu item: " .. vim.inspect(menu))
  return nil
end

-- Main entry point
-- all items here are children of the initial "PopUp" menu
-- @param options table
-- @param options.events table
-- @param options.menus table
R.menu = function(groupId, items)
   Log.debug("Group: " .. groupId .. ", Items: " .. vim.inspect(items))

   Log.info("Registering menu group: " .. groupId)

  R.clear_menu(groupId)

  for _, menu in ipairs(items) do
    if Types.isMenuItem(menu) == false then
      astrocore.notify("Invalid menu item in GroupId: " .. groupId .. "\n" .. vim.inspect(menu), vim.log.levels.ERROR)
      return
    end

    -- anchor all children to this GroupId
    menu.groupid = groupId

     Log.debug("Registering menu item: " .. menu.label .. " in group: " .. groupId)
    local cmds = R.menu_item(menu)

    if cmds then
      for _, cmd in ipairs(cmds) do
        vim.cmd(cmd)
      end

       Log.trace(vim.inspect(cmds))
       Log.trace("----")
    end
  end

  -- create autocmd to manage which items are enabled/disabled
  -- vim.api.nvim_create_augroup("MenuPopup", {
  --   callback = function()
  --     -- clear existing menu items
  --     -- vim.cmd(R.clear_menu "PopUp")
  --     -- for each key,value pair in menus
  --   end,
  -- })
end

return R
