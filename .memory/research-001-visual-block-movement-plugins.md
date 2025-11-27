# Research: Visual Block Movement Plugins

## Objective
Find AstroCommunity plugins that handle moving visual selections up/down with keyboard shortcuts.

## Findings

### 1. mini.move (RECOMMENDED)
**Repository**: `echasnovski/mini.move`  
**AstroCommunity path**: `astrocommunity.motion.mini-move`

**Features**:
- ✅ Pure Lua implementation (modern, fast)
- ✅ Works in Visual AND Normal mode
- ✅ Automatic reindentation for vertical moves
- ✅ Horizontal movement (indent/dedent)
- ✅ Respects `v:count` (prefix with number)
- ✅ Single undo for consecutive moves
- ✅ Maintains cursor position
- ✅ Part of well-maintained mini.nvim ecosystem

**Default keybindings**:
```
<Alt-h>  Move left
<Alt-l>  Move right  
<Alt-j>  Move down
<Alt-k>  Move up
```

**AstroCommunity config** (lua/astrocommunity/motion/mini-move/init.lua:20-30):
```lua
opts = {
  mappings = {
    left = "<A-h>",
    right = "<A-l>",
    down = "<A-j>",
    up = "<A-k>",
    line_left = "<A-h>",
    line_right = "<A-l>",
    line_down = "<A-j>",
    line_up = "<A-k>",
  },
},
```

**Customization for Ctrl+Shift**:
Can override mappings in community.lua to use `<C-S-Up>` instead of `<A-k>`.

---

### 2. vim-move
**Repository**: `matze/vim-move`  
**AstroCommunity path**: `astrocommunity.editing-support.vim-move`

**Features**:
- ✅ Mature plugin (1.2k stars)
- ✅ Vertical and horizontal motions
- ✅ Automatic indentation
- ✅ Single undo for multiple moves
- ⚠️  VimScript (older, slower than Lua)

**Default keybindings**:
```
<A-k>  Move up
<A-j>  Move down
<A-h>  Move left
<A-l>  Move right
```

**Customization**:
```vim
let g:move_key_modifier = 'C'  " Use Ctrl instead of Alt
let g:move_key_modifier_visualmode = 'S'  " Use Shift in visual mode
```

**Issues**:
- AstroCommunity config is minimal (no customization provided)
- VimScript plugin in Lua ecosystem
- Less actively maintained than mini.move

---

### 3. vim-visual-multi (NOT SUITABLE)
**Repository**: `mg979/vim-visual-multi`  
**AstroCommunity path**: `astrocommunity.editing-support.vim-visual-multi`

**Purpose**: Multiple cursors (like VSCode)  
**NOT for line movement** - used for multi-cursor editing only.

---

## Recommendation

**Use `mini.move`** for the following reasons:

1. **Modern Lua implementation** - faster, better integrated with Neovim
2. **Well-maintained** - part of mini.nvim ecosystem (actively developed)
3. **Feature-complete** - handles all edge cases (reindent, cursor position, undo)
4. **Easy customization** - clean Lua config
5. **Already in AstroCommunity** - one line to enable

## Implementation Plan

1. Add to `lua/community.lua`:
```lua
{ import = "astrocommunity.motion.mini-move" },
```

2. Override keybindings in `lua/plugins/user.lua` to use Ctrl+Shift instead of Alt:
```lua
{
  "echasnovski/mini.move",
  opts = {
    mappings = {
      left = "",
      right = "",
      down = "<C-S-Down>",
      up = "<C-S-Up>",
      line_left = "",
      line_right = "",
      line_down = "<C-S-Down>",
      line_up = "<C-S-Up>",
    },
  },
}
```

## Alternative: vim-move

If terminal doesn't support Ctrl+Shift combinations properly, use `vim-move` with Alt keys:

```lua
{ import = "astrocommunity.editing-support.vim-move" },
```

Default Alt+j/k bindings work universally across terminals.

## References

- mini.move: https://github.com/echasnovski/mini.move
- vim-move: https://github.com/matze/vim-move
- AstroCommunity: https://github.com/AstroNvim/astrocommunity

## Status

✅ Research complete - ready for implementation
