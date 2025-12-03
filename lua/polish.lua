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
