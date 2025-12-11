-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Configure clipboard for WSL with win32yank
if vim.env.WSL_DISTRO_NAME then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

-- Helper function to get search term from selection, word under cursor, or empty
local function get_grug_search_term()
  -- Try to get selected text first
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode - get selected text
    vim.cmd 'noau normal! "zy'
    return vim.fn.getreg "z"
  end

  -- Check if we're in insert mode or normal mode
  if vim.fn.col "." > 1 then
    -- Get word under cursor
    local word = vim.fn.expand "<cword>"
    return word ~= "" and word or ""
  end

  return ""
end

-- Grug search on Ctrl+F
vim.keymap.set("n", "<C-f>", function()
  local search_term = vim.fn.expand "<cword>"
  require("grug-far").toggle_instance {
    instanceName = "main",
    prefills = { search = search_term },
  }
end, { noremap = true, silent = true, desc = "Toggle grug search" })

-- Grug search in visual mode (use selected text)
vim.keymap.set("v", "<C-f>", function()
  vim.cmd 'noau normal! "zy'
  local search_term = vim.fn.getreg "z"
  require("grug-far").toggle_instance {
    instanceName = "main",
    prefills = { search = search_term },
  }
end, { noremap = true, silent = true, desc = "Toggle grug search with selection" })

-- Grug search and replace on Ctrl+Shift+F
vim.keymap.set("n", "<C-S-f>", function()
  local search_term = vim.fn.expand "<cword>"
  require("grug-far").toggle_instance {
    instanceName = "main",
    prefills = { search = search_term },
  }
end, { noremap = true, silent = true, desc = "Toggle grug search and replace" })

-- Grug search and replace in visual mode (use selected text)
vim.keymap.set("v", "<C-S-f>", function()
  vim.cmd 'noau normal! "zy'
  local search_term = vim.fn.getreg "z"
  require("grug-far").open { prefills = { search = search_term } }
end, { noremap = true, silent = true, desc = "Open grug search and replace with selection" })

-- Clone current or selected lines (Ctrl+Shift+D)
-- Normal mode: clone current line
vim.keymap.set(
  "n",
  "<C-S-d>",
  function() vim.cmd "copy ." end,
  { noremap = true, silent = true, desc = "Clone current line" }
)

-- Visual mode: clone selected lines
vim.keymap.set(
  "v",
  "<C-S-d>",
  function() vim.cmd "'<,'>copy '>'" end,
  { noremap = true, silent = true, desc = "Clone selected lines" }
)

-- Delete line or selected lines (Ctrl+Shift+K)
-- Normal mode: delete current line
vim.keymap.set(
  "n",
  "<C-S-k>",
  function() vim.cmd "delete" end,
  { noremap = true, silent = true, desc = "Delete current line" }
)

-- Visual mode: delete selected lines
vim.keymap.set(
  "v",
  "<C-S-k>",
  function() vim.cmd "'<,'>delete" end,
  { noremap = true, silent = true, desc = "Delete selected lines" }
)

-- Copy to clipboard (Ctrl+C)
-- Normal mode: copy current line
vim.keymap.set(
  "n",
  "<C-c>",
  function() vim.cmd 'normal! "+yy' end,
  { noremap = true, silent = true, desc = "Copy current line" }
)

-- Visual mode: copy selected text
vim.keymap.set(
  "v",
  "<C-c>",
  function() vim.cmd 'normal! "+y' end,
  { noremap = true, silent = true, desc = "Copy selection" }
)

-- Cut to clipboard (Ctrl+X)
-- Normal mode: cut current line
vim.keymap.set(
  "n",
  "<C-x>",
  function() vim.cmd 'normal! "+dd' end,
  { noremap = true, silent = true, desc = "Cut current line" }
)

-- Visual mode: cut selected text
vim.keymap.set(
  "v",
  "<C-x>",
  function() vim.cmd 'normal! "+d' end,
  { noremap = true, silent = true, desc = "Cut selection" }
)

-- Paste from clipboard (Ctrl+V)
-- Normal mode: paste after cursor
vim.keymap.set(
  "n",
  "<C-v>",
  function() vim.cmd 'normal! "+p' end,
  { noremap = true, silent = true, desc = "Paste after cursor" }
)

-- Insert mode: paste from clipboard
vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Visual mode: paste over selection
vim.keymap.set(
  "v",
  "<C-v>",
  function() vim.cmd 'normal! "+p' end,
  { noremap = true, silent = true, desc = "Paste over selection" }
)

-- Copilot keymaps
-- Accept Copilot suggestion with Tab
vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n")
  end
end, { noremap = true, silent = true, desc = "Accept Copilot suggestion or tab" })

-- Next Copilot suggestion (Alt+])
vim.keymap.set(
  "i",
  "<M-]>",
  function() require("copilot.suggestion").next() end,
  { noremap = true, silent = true, desc = "Next Copilot suggestion" }
)

-- Previous Copilot suggestion (Alt+[)
vim.keymap.set(
  "i",
  "<M-[>",
  function() require("copilot.suggestion").prev() end,
  { noremap = true, silent = true, desc = "Previous Copilot suggestion" }
)

-- Dismiss Copilot suggestion (Ctrl+])
vim.keymap.set(
  "i",
  "<C-]>",
  function() require("copilot.suggestion").dismiss() end,
  { noremap = true, silent = true, desc = "Dismiss Copilot suggestion" }
)

-- Toggle last used toggleterm layout (Ctrl+~)
vim.keymap.set(
  { "n", "i", "t" },
  "<C-~>",
  function() require("toggleterm").toggle() end,
  { noremap = true, silent = true, desc = "Toggle last used toggleterm" }
)

-- Enable mouse support
vim.opt.mouse = 'a'

-- Quit confirmation popup
local function show_quit_confirm()
  local width = 40
  local height = 7
  local lines = {
    '┌' .. string.rep('─', width - 2) .. '┐',
    '│' .. string.rep(' ', width - 2) .. '│',
    '│' .. string.format('%-' .. (width - 2) .. 's', '  Are you sure?') .. '│',
    '│' .. string.rep(' ', width - 2) .. '│',
    '│' .. string.format('%-' .. (width - 2) .. 's', '  [Y]es    [N]o') .. '│',
    '│' .. string.rep(' ', width - 2) .. '│',
    '└' .. string.rep('─', width - 2) .. '┘',
  }

  -- Calculate centered position
  local ui = vim.api.nvim_list_uis()[1]
  local win_width = ui.width
  local win_height = ui.height
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'none',
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Key mappings for the confirmation
  local function handle_response(response)
    vim.api.nvim_win_close(win, true)
    if response == 'yes' then
      vim.cmd 'quit'
    end
  end

  vim.keymap.set('n', 'y', function()
    handle_response 'yes'
  end, { noremap = true, silent = true, buffer = buf })

  vim.keymap.set('n', 'n', function()
    handle_response 'no'
  end, { noremap = true, silent = true, buffer = buf })

  vim.keymap.set('n', '<CR>', function()
    handle_response 'yes'
  end, { noremap = true, silent = true, buffer = buf })

  vim.keymap.set('n', '<Esc>', function()
    handle_response 'no'
  end, { noremap = true, silent = true, buffer = buf })
end

-- Create a custom quit command with confirmation
vim.api.nvim_create_user_command('Q', function()
  show_quit_confirm()
end, {})

-- Abbreviate :q to :Q to show the confirmation
vim.cmd 'cnoreabbrev q Q'

-- Navigation with Alt arrow keys for back/forward
-- Alt+Left to go back in navigation history
vim.keymap.set('n', '<A-Left>', '<C-o>', { noremap = true, silent = true })

-- Alt+Right to go forward in navigation history
vim.keymap.set('n', '<A-Right>', '<C-i>', { noremap = true, silent = true })

-- Ctrl+LeftMouse to go to definition
-- Position cursor at click, then go to definition
vim.keymap.set('n', '<C-LeftMouse>', function()
  -- Click positions the cursor first, then we go to definition
  vim.cmd 'normal! <LeftMouse>'
  vim.schedule(function()
    vim.lsp.buf.definition()
  end)
end, { noremap = true, silent = true })

-- Auto-enter insert mode in sidekick_terminal buffers
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'sidekick_terminal',
  callback = function()
    vim.cmd 'startinsert'
  end,
})
vim.opt.mouse = "a"

-- Config reload command
vim.api.nvim_create_user_command("ReloadConfig", function()
  -- Clear loaded modules to force reload
  for name, _ in pairs(package.loaded) do
    if name:match "^user" or name:match "^custom" or name:match "^polyfill" then package.loaded[name] = nil end
  end
  -- Reload the main config
  vim.cmd.source(vim.env.MYVIMRC)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, {})
