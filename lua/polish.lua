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

-- Fix Home/End keys in insert mode (terminal key code issue)
-- Map both standard and application cursor key modes
vim.keymap.set('i', '<End>', '<C-o>$', { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set('i', '<Home>', '<C-o>^', { noremap = true, silent = true, desc = "Move to first non-blank character" })

-- Alacritty sends these escape sequences in application cursor mode
vim.keymap.set('i', '<Esc>OF', '<C-o>$', { noremap = true, silent = true, desc = "End key (app mode)" })
vim.keymap.set('i', '<Esc>OH', '<C-o>^', { noremap = true, silent = true, desc = "Home key (app mode)" })

-- Also try to catch the sequence that causes <Select>
vim.keymap.set('i', '<Select>', '<C-o>$', { noremap = true, silent = true, desc = "Fix Select as End" })
vim.keymap.set('i', '<Find>', '<C-o>^', { noremap = true, silent = true, desc = "Fix Find as Home" })

-- Enable mouse support
vim.opt.mouse = 'a'
