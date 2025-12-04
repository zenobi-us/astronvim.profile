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

-- Clone current or selected lines (Ctrl+Shift+D)
-- Normal mode: clone current line
vim.keymap.set('n', '<C-S-d>', function()
  vim.cmd('copy .')
end, { noremap = true, silent = true, desc = 'Clone current line' })

-- Visual mode: clone selected lines
vim.keymap.set('v', '<C-S-d>', function()
  vim.cmd("'<,'>copy '>'")
end, { noremap = true, silent = true, desc = 'Clone selected lines' })

-- Delete line or selected lines (Ctrl+Shift+K)
-- Normal mode: delete current line
vim.keymap.set('n', '<C-S-k>', function()
  vim.cmd('delete')
end, { noremap = true, silent = true, desc = 'Delete current line' })

-- Visual mode: delete selected lines
vim.keymap.set('v', '<C-S-k>', function()
  vim.cmd("'<,'>delete")
end, { noremap = true, silent = true, desc = 'Delete selected lines' })

-- Copy to clipboard (Ctrl+C)
-- Normal mode: copy current line
vim.keymap.set('n', '<C-c>', function()
  vim.cmd('normal! "+yy')
end, { noremap = true, silent = true, desc = 'Copy current line' })

-- Visual mode: copy selected text
vim.keymap.set('v', '<C-c>', function()
  vim.cmd('normal! "+y')
end, { noremap = true, silent = true, desc = 'Copy selection' })

-- Cut to clipboard (Ctrl+X)
-- Normal mode: cut current line
vim.keymap.set('n', '<C-x>', function()
  vim.cmd('normal! "+dd')
end, { noremap = true, silent = true, desc = 'Cut current line' })

-- Visual mode: cut selected text
vim.keymap.set('v', '<C-x>', function()
  vim.cmd('normal! "+d')
end, { noremap = true, silent = true, desc = 'Cut selection' })

-- Paste from clipboard (Ctrl+V)
-- Normal mode: paste after cursor
vim.keymap.set('n', '<C-v>', function()
  vim.cmd('normal! "+p')
end, { noremap = true, silent = true, desc = 'Paste after cursor' })

-- Insert mode: paste from clipboard
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true, desc = 'Paste from clipboard' })

-- Visual mode: paste over selection
vim.keymap.set('v', '<C-v>', function()
  vim.cmd('normal! "+p')
end, { noremap = true, silent = true, desc = 'Paste over selection' })

-- Copilot keymaps
-- Accept Copilot suggestion with Tab
vim.keymap.set('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n')
  end
end, { noremap = true, silent = true, desc = 'Accept Copilot suggestion or tab' })

-- Next Copilot suggestion (Alt+])
vim.keymap.set('i', '<M-]>', function()
  require("copilot.suggestion").next()
end, { noremap = true, silent = true, desc = 'Next Copilot suggestion' })

-- Previous Copilot suggestion (Alt+[)
vim.keymap.set('i', '<M-[>', function()
  require("copilot.suggestion").prev()
end, { noremap = true, silent = true, desc = 'Previous Copilot suggestion' })

-- Dismiss Copilot suggestion (Ctrl+])
vim.keymap.set('i', '<C-]>', function()
  require("copilot.suggestion").dismiss()
end, { noremap = true, silent = true, desc = 'Dismiss Copilot suggestion' })

-- Toggle last used toggleterm layout (Ctrl+~)
vim.keymap.set({ 'n', 'i', 't' }, '<C-~>', function()
  require('toggleterm').toggle()
end, { noremap = true, silent = true, desc = 'Toggle last used toggleterm' })

-- Enable mouse support
vim.opt.mouse = 'a'
