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
  if not R.should_menu_item_display(menu) then return {} end

  -- skip if no command is defined
  if not menu.command then return {} end
  local entry = {}

  -- create the menu entry for each mode
  for _, mode in ipairs(menu.modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. "." .. escape_label(R.label(menu)) .. " " .. menu.command
    entry[#entry + 1] = cmd
  end

  return entry
end

R.menu_popup = function(menu)
  if not R.should_menu_item_display(menu) then return {} end
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
  if menu.separator then
    return R.menu_separator(menu)
  elseif menu == nil then
    return
  elseif menu.items ~= nil then
    return R.menu_popup(menu)
  else
    return R.menu_action(menu)
  end
end

-- Main entry point
-- all items here are children of the initial "PopUp" menu
-- @param options table
-- @param options.events table
-- @param options.menus table
R.menu = function(options)
  options = options or {}
  local events = options.events or { "BufEnter" }
  local menus = options.menus or {}

  -- Flatten menus if they're nested arrays
  local flattened = {}
  for i, menu in ipairs(menus) do
    if type(menu) == "table" and menu[1] ~= nil and type(menu[1]) == "table" then
      -- This is an array of menu items, wrap it as a submenu group
      table.insert(flattened, {
        label = menu.label or ("Menu " .. i),
        items = menu,
        options = menu.options,
      })
    else
      -- This is a single menu, add it
      table.insert(flattened, menu)
    end
  end

  vim.api.nvim_create_autocmd(events, {
    callback = function()
      local entries = {}

      table.insert(entries, R.clear_menu "PopUp")

      for _, menu in ipairs(flattened) do
        menu.groupid = "PopUp"
        local menu_cmds = R.menu_item(menu)
        if menu_cmds then vim.list_extend(entries, menu_cmds) end
      end

      local pretty_entries = table.concat(entries, "\n  ")
      astrocore.notify(
        "Rendering popup menu with "
          .. #entries
          .. " entries."
          .. "\n"
          .. "DEFINITION:"
          .. "\n"
          .. vim.inspect(menus)
          .. "\n"
          .. "FLATTENED:"
          .. vim.inspect(flattened)
          .. "\n"
          .. "ENTRIES:"
          .. "\n"
          .. pretty_entries,
        vim.log.levels.DEBUG
      )

      vim.cmd(pretty_entries)
    end,
  })
end

return R
