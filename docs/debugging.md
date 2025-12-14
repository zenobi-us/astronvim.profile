# Debugging with nvim-dap

This configuration includes debugging support via [nvim-dap](https://github.com/mfussenegger/nvim-dap) and [nvim-dap-view](https://github.com/mfussenegger/nvim-dap-view), integrated through AstroCommunity.

## Overview

- **nvim-dap**: Debug Adapter Protocol implementation for Neovim
- **nvim-dap-view**: UI for viewing breakpoints, call stacks, variables, and REPL
- **Launch.json support**: Native support for VS Code's `.vscode/launch.json` format

## Getting Started

### 1. Create a Launch Configuration

Create a `.vscode/launch.json` file in your project root. Example for Python:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal"
    }
  ]
}
```

### 2. Install Language Adapter

For Python debugging, install `debugpy`:
```bash
pip install debugpy
```

For Node.js, install `node-debug2-adapter`:
```bash
npm install node-debug2-adapter -g
```

### 3. Start Debugging

Basic debugging commands:

| Command | Action |
| --- | --- |
| `:DapContinue` | Start/continue debugging |
| `:DapToggleBreakpoint` | Set/unset breakpoint on current line |
| `:DapStepOver` | Step over |
| `:DapStepInto` | Step into |
| `:DapStepOut` | Step out |
| `:DapTerminate` | Stop debugging |

**Sources:** [nvim-dap README - Usage](https://github.com/mfussenegger/nvim-dap/blob/master/README.md#usage)

### 4. Automatic UI

When you run `:DapContinue`, the dapui windows open automatically with:
- **Scopes**: View and inspect local and global variables
- **Stacks**: Navigate through threads and stack frames
- **Watches**: Monitor expressions during debugging
- **REPL**: Evaluate code in the context of the debugged program

**Sources:** [nvim-dap-ui README - Configuration](https://github.com/rcarriga/nvim-dap-ui/blob/master/README.md#configuration)

## How It Works

### Launch.json Auto-loading

When the dapui windows open, an autocommand automatically loads your `.vscode/launch.json` file:

```lua
-- lua/plugins/astrocore.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dapui_*",
  callback = function()
    local ok, dap_ext = pcall(require, "dap.ext.vscode")
    if ok then
      dap_ext.load_launchjs()
    end
  end,
})
```

nvim-dap has built-in support for VS Code's `launch.json` format via the `dap.ext.vscode` module. The `.vscode/launch.json` files are automatically discovered and read when you start a debug session.

This allows you to:
1. Share launch configurations with VS Code users
2. Keep debugging configs in version control
3. Use team-wide standard debug setups

**Sources:** [nvim-dap docs - VS Code Launch Configuration](https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L1) (see `:help dap-launch.json`)

## UI Controls

Once debugging starts, use these keybindings in the dapui windows:

| Keymap | Action |
| --- | --- |
| `<Leader>du` | Toggle debugger UI visibility |
| `<Leader>dE` | Add expression to watch |

## Configuration Files

- `lua/community.lua`: Imports nvim-dap and nvim-dap-view from AstroCommunity
- `lua/plugins/astrocore.lua`: Autocommand to load launch.json on dapui open

## Troubleshooting

### Launch.json not loading
- Ensure `.vscode/launch.json` exists in the directory where you opened nvim
- Check that the file is valid JSON (use `jq` to validate)
- Verify the debug adapter for your language is installed

### Adapter not found
- Install the appropriate debug adapter for your language
- Check nvim-dap documentation for adapter setup: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

### UI not appearing
- Run `:DapContinue` to trigger the UI
- Check nvim-dap-view is properly loaded via `:Lazy` command

## Sources & References

### Core Documentation
- [nvim-dap README](https://github.com/mfussenegger/nvim-dap/blob/master/README.md)
- [nvim-dap Vim Help](https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt) - Run `:help dap.txt` in Neovim
- [nvim-dap-ui README](https://github.com/rcarriga/nvim-dap-ui/blob/master/README.md)
- [nvim-dap-view README](https://github.com/mfussenegger/nvim-dap-view/blob/main/README.md)

### Adapter Configuration
- [nvim-dap Wiki - Debug Adapter Installation](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)
- [nvim-dap Supported Languages](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)

### VS Code Integration
- [VS Code Launch Configuration](https://code.visualstudio.com/docs/editor/debugging)
- nvim-dap Launch.json Support: `:help dap-launch.json` in Neovim

### AstroCommunity
- [AstroCommunity Debugging Modules](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/debugging)
- [nvim-dap-view AstroCommunity Module](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/debugging/nvim-dap-view)
