# Task: Test Visual Line Movement with Mouse

## Objective
Verify that Ctrl+Shift+Up/Down works for moving mouse-selected lines

## Test Steps
1. Open nvim with any file containing multiple lines
2. Use mouse to click and drag to select several lines (should enter visual mode)
3. While selection is active, press `Ctrl+Shift+Up` - lines should move up
4. Press `Ctrl+Shift+Down` - lines should move down
5. Verify that indentation is preserved/corrected after movement

## Expected Behavior
- Mouse selection should work (mouse is enabled with `set mouse=a`)
- `Ctrl+Shift+Up` moves selected block up one line
- `Ctrl+Shift+Down` moves selected block down one line
- Visual selection remains active after movement
- Code is automatically reindented after move

## Files Modified
- `lua/polish.lua:36-42` - Mouse support and visual mode mappings

## Implementation Details
- Uses `:m '<-2` to move to 2 lines above visual start
- Uses `:m '>+1` to move to 1 line below visual end
- `gv` reselects visual block
- `=gv` reindents the selection
