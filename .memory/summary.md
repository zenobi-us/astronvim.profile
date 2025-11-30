# Neovim Configuration Summary

## Issue 1 (RESOLVED) - Terminal Key Codes
- End key in insert mode was inserting "<Select>" 
- Home key in insert mode was inserting "<Find>"
- Using Alacritty terminal
- AstroNvim-based configuration

### Root Cause
Alacritty terminal sends non-standard key codes (`<Select>` for End, `<Find>` for Home) that Neovim doesn't automatically recognize. This required explicit key mappings.

### Solution Implemented
Added explicit key mappings in polish.lua to handle terminal key code issues:
- Mapped `<Select>` (what Alacritty sends for End) to `<C-o>$` (move to end of line)
- Mapped `<Find>` (what Alacritty sends for Home) to `<C-o>^` (move to first non-blank)
- Also added standard `<End>` and `<Home>` mappings
- Added escape sequence mappings for application cursor mode

The fix uses `<C-o>` to execute a single normal mode command without leaving insert mode.

## Issue 2 (RESOLVED) - Visual Mode Line Movement
- User wants to use mouse to select lines and move them with Ctrl+Shift+Up/Down
- Requires mouse support and visual mode mappings

### Solution Implemented (lua/polish.lua:36-42)
- Enabled mouse support: `vim.opt.mouse = 'a'`
- Added `<C-S-Up>` in visual mode: moves selected lines up with `:m '<-2<CR>gv=gv`
- Added `<C-S-Down>` in visual mode: moves selected lines down with `:m '>+1<CR>gv=gv`
- The `gv=gv` reselects and reindents after move
- Verified working by user with story.md test file

## Issue 3 (RESOLVED) - Close Buffer Without Quitting
- `Ctrl+W` was mapped to `vim.cmd.quit()` which quits Neovim entirely
- User wanted to close the current buffer tab without exiting Neovim
- Enhanced: When closing the last buffer, show dashboard instead of empty screen

### Root Cause
`vim.cmd.quit()` closes the window, not the buffer. When the last window closes, Neovim quits regardless of remaining buffers.

### Solution Implemented (lua/plugins/astrocore.lua:80-102)
- Changed from `vim.cmd.quit()` to `require("astrocore.buffer").close()`
- Detects if closing the last normal buffer (filters special buffers)
- When last buffer closes, automatically opens Snacks.nvim dashboard
- Uses `vim.defer_fn` with 10ms delay to ensure buffer closes before dashboard opens
- Handles edge cases like modified buffers and last buffer scenarios
- Verified working by user

## Issue 4 (COMPLETED) - VSCode Diff Plugin Installation
- User wanted to install vscode-diff.nvim plugin
- Plugin not in AstroCommunity repository

### Solution Implemented (lua/plugins/vscode-diff.lua)
- Created new plugin file for vscode-diff.nvim
- Added nui.nvim dependency
- Configured with default settings (colorscheme-aware highlights)
- Plugin provides VSCode-style side-by-side diffs with two-tier highlighting
- Auto-downloads pre-built C binaries (no compiler required)
