-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Incremental search with highlighting on Ctrl+F
vim.keymap.set('n', '<C-f>', function()
  -- Start search mode with / which provides:
  -- 1. Live highlighting as you type
  -- 2. Jump to first match automatically
  -- 3. All matches highlighted
  vim.cmd('set hlsearch')
  vim.cmd('set incsearch')
  vim.fn.feedkeys('/', 'n')
end, { noremap = true, silent = true })

-- Optional: Also configure visual mode search
vim.keymap.set('v', '<C-f>', function()
  vim.cmd('set hlsearch')
  vim.cmd('set incsearch')
  vim.fn.feedkeys('/', 'n')
end, { noremap = true, silent = true })

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
