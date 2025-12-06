-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Helper function to get search term from selection, word under cursor, or empty
local function get_grug_search_term()
  -- Try to get selected text first
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    -- Visual mode - get selected text
    vim.cmd('noau normal! "zy')
    return vim.fn.getreg('z')
  end
  
  -- Check if we're in insert mode or normal mode
  if vim.fn.col('.') > 1 then
    -- Get word under cursor
    local word = vim.fn.expand('<cword>')
    return word ~= '' and word or ''
  end
  
  return ''
end

-- Grug search on Ctrl+F
vim.keymap.set('n', '<C-f>', function()
  local search_term = vim.fn.expand('<cword>')
  require('grug-far').toggle_instance({
    instanceName = 'main',
    prefills = { search = search_term }
  })
end, { noremap = true, silent = true, desc = 'Toggle grug search' })

-- Grug search in visual mode (use selected text)
vim.keymap.set('v', '<C-f>', function()
  vim.cmd('noau normal! "zy')
  local search_term = vim.fn.getreg('z')
  require('grug-far').toggle_instance({
    instanceName = 'main',
    prefills = { search = search_term }
  })
end, { noremap = true, silent = true, desc = 'Toggle grug search with selection' })

-- Grug search and replace on Ctrl+Shift+F
vim.keymap.set('n', '<C-S-f>', function()
  local search_term = vim.fn.expand('<cword>')
  require('grug-far').toggle_instance({
    instanceName = 'main',
    prefills = { search = search_term }
  })
end, { noremap = true, silent = true, desc = 'Toggle grug search and replace' })

-- Grug search and replace in visual mode (use selected text)
vim.keymap.set('v', '<C-S-f>', function()
  vim.cmd('noau normal! "zy')
  local search_term = vim.fn.getreg('z')
  require('grug-far').open({ prefills = { search = search_term } })
end, { noremap = true, silent = true, desc = 'Open grug search and replace with selection' })

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
