# Neovim Configuration Summary

## Configuration Location
All key mappings are in `lua/plugins/astrocore.lua` under the `mappings` section.

## Resolved Issues

### Terminal Key Codes (Alacritty)
Alacritty sends non-standard key codes that require explicit mappings:
- `<Find>` → Home key
- `<Select>` → End key

**Solution** (astrocore.lua):
- Insert mode: `<Find>`/`<Home>` → `<C-o>^`, `<Select>`/`<End>` → `<C-o>$`
- Normal mode: `<Find>`/`<Home>` → `^`, `<Select>`/`<End>` → `$`

### Arrow Key Line Wrapping
Arrow keys now wrap across lines in insert mode.

**Solution**: `whichwrap = "b,s,<,>,[,]"` in astrocore.lua options

### Close Buffer (Ctrl+W)
Closes buffer without quitting Neovim. Shows dashboard when last buffer closes.
Uses `vim.ui.select` (Snacks picker) for unsaved changes confirmation modal.

**Solution** (astrocore.lua:80-118):
- Detects modified buffers, shows modal via `vim.ui.select`
- Options: "Save and close", "Discard changes", "Cancel"
- Uses `Snacks.bufdelete({ force = true })` after user choice
- Opens dashboard if closing last buffer

### Ctrl+Backspace Word Deletion
Deletes whole word in insert/command mode.

**Solution** (astrocore.lua):
- `<C-BS>` → `<C-w>`
- Also maps Alacritty escape sequence `\x1b[127;5u`

**Alacritty config** (`~/.config/alacritty/alacritty.toml`):
```toml
{ key = "Back", mods = "Control", chars = "\u001b[127;5u" }
```

### Line Numbers
Sequential (absolute) line numbers by default.

**Solution**: `relativenumber = false` in astrocore.lua options

### Other Mappings
- `<C-S>` - Save file (normal + insert mode)
- `<C-Left>`/`<C-Right>` - Word jump (normal + insert mode)
- Mouse support enabled: `vim.opt.mouse = 'a'` in polish.lua

## Plugins

### Snacks.nvim (lua/plugins/user.lua)
- Dashboard with Pokemon terminal art
- Picker with `ui_select = true` for modal confirmations

### vscode-diff.nvim (lua/plugins/vscode-diff.lua)
VSCode-style side-by-side diffs with two-tier highlighting.

## Pending

### AI Autocomplete
Researched options in AstroCommunity:
- **codeium-nvim** - Free option
- **supermaven-nvim** - Best performance
- **copilot** - Industry standard

User to choose which to enable.
