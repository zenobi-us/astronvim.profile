---
id: codemap01
title: Neovim Plugin Interaction State Machines
area: codebase-structure
tags: [architecture, plugins, interaction-flows, state-machines]
learned_from: Plugin analysis using codemapper skill
created_at: 2026-01-30T17:50:00+10:30
updated_at: 2026-01-30T17:50:00+10:30
---

# Neovim Plugin Interaction State Machines

## Overview

This document contains ASCII state machine diagrams representing how user interactions flow through each Neovim plugin from start to end. Each diagram shows the entry points (keymaps/events), intermediate states, and exit conditions.

## Core Plugins

### astrocore.lua - Core Configuration & Keymaps

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                    (Normal/Insert Mode)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │              KEYMAP TRIGGERED                        │
        │  - <C-S>: Save file                                  │
        │  - <C-W>: Close buffer                               │
        │  - <Leader>bd: Close buffer from tabline             │
        │  - ]b/[b: Navigate buffers                           │
        │  - <C-Left>/<C-Right>: Word navigation               │
        │  - <Find>/<Select>: Home/End keys                    │
        │  - <Leader>b\: Horizontal split buffer               │
        │  - <Leader>b|: Vertical split buffer                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           ACTION EXECUTION                           │
        │  - Save: Write buffer to disk                        │
        │  - Close: Check if modified → Modal confirm          │
        │  - Navigate: Switch buffer tab                       │
        │  - Split: Open fzf-lua picker → Select buffer        │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │         COMPLETION (if applicable)                   │
        │  - Buffer closed                                     │
        │  - Dashboard shown (if last buffer)                  │
        │  - File saved                                        │
        │  - Buffer switched                                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### neo-tree.lua - File Explorer

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLOSED STATE                              │
│                   (Neo-tree not visible)                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ <Leader>e (toggle)
        ┌─────────────────────────────────────────────────────┐
        │               EXPLORER OPEN                          │
        │  Sources: filesystem, document_symbols               │
        │  Mode: Normal (auto-switched by buffermodes)         │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           NAVIGATION STATE                           │
        │  - j/k: Move up/down                                 │
        │  - Enter: Open file/expand directory                 │
        │  - a: Add file/directory                             │
        │  - d: Delete file/directory                          │
        │  - r: Rename file/directory                          │
        │  - Tab: Switch source (filesystem ↔ document_symbols)│
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            FILE SELECTED                             │
        │  - Open in current window                            │
        │  - Return focus to editor                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ <Leader>e or q
                      Return to CLOSED STATE
```

### fzf-lua - Fuzzy Finder

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                    (Editor focused)                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Trigger keymap
        ┌─────────────────────────────────────────────────────┐
        │              PICKER LAUNCHED                         │
        │  - <Leader>sf: Find files                            │
        │  - <Leader>sg: Live grep                             │
        │  - <Leader>sb: Buffers                               │
        │  - <Leader>sh: Help tags                             │
        │  - Buffer split keymaps                              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           INTERACTIVE SEARCH                         │
        │  - Type to filter results                            │
        │  - Up/Down: Navigate results                         │
        │  - Ctrl+C/Esc: Cancel                                │
        │  - Enter: Select item                                │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            SELECTION ACTION                          │
        │  - Open file in buffer                               │
        │  - Split buffer horizontally/vertically              │
        │  - Insert text (for grep/help)                       │
        │  - Close picker                                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### snacks.nvim - Dashboard & Picker

```
┌─────────────────────────────────────────────────────────────────┐
│                     DASHBOARD STATE                              │
│         (Shown on startup or last buffer close)                  │
│  - Pokemon terminal art (Glalie)                                 │
│  - Quick action keys                                             │
│  - Startup info                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Open file / Enter command
        ┌─────────────────────────────────────────────────────┐
        │               EDITOR STATE                           │
        │                                                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Command palette keymap
        ┌─────────────────────────────────────────────────────┐
        │              PICKER INTERFACE                        │
        │  - <Leader>fc: Find commands                         │
        │  - <Leader>fk: Find keymaps                          │
        │  - <Leader>fa: Find autocmds                         │
        │  - Layout: Telescope preset (list left, preview right)│
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           INTERACTIVE SELECTION                      │
        │  - Type to filter                                    │
        │  - Navigate with j/k or arrows                       │
        │  - Enter/o: Confirm selection                        │
        │  - Esc: Cancel                                       │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            ACTION EXECUTION                          │
        │  - Execute selected command                          │
        │  - Trigger selected keymap                           │
        │  - Show autocmd info                                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to EDITOR STATE

                              │
                              ▼ vim.ui.select() called
        ┌─────────────────────────────────────────────────────┐
        │            MODAL CONFIRMATION                        │
        │  - Used for "Close buffer with unsaved changes"      │
        │  - Options: Save/Discard/Cancel                      │
        │  - Navigate with j/k or numbers                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                Return to previous state (based on choice)
```

## AI & Completion Plugins

### copilot.lua - AI Code Suggestions

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                    (Insert mode active)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Auto-trigger on typing
        ┌─────────────────────────────────────────────────────┐
        │           SUGGESTION GENERATED                       │
        │  - Ghost text appears inline                         │
        │  - Gray dimmed preview of completion                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           USER DECISION                              │
        │  - <C-Right>: Accept suggestion                      │
        │  - <C-Down>: Next suggestion                         │
        │  - <C-Up>: Previous suggestion                       │
        │  - <C-Backspace>: Dismiss suggestion                 │
        │  - Keep typing: Dismiss implicitly                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            COMPLETION                                │
        │  - If accepted: Insert suggestion into buffer        │
        │  - If dismissed: Clear suggestion, continue editing  │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### emoji-picker.lua - Emoji Selection

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                   (Markdown file open)                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ <Leader>se
        ┌─────────────────────────────────────────────────────┐
        │          TELESCOPE EMOJI PICKER                      │
        │  - Search emoji by name/keyword                      │
        │  - Preview emoji in telescope window                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SEARCH & FILTER                            │
        │  - Type emoji name (e.g., "smile", "rocket")         │
        │  - Navigate results with j/k                         │
        │  - Enter: Select emoji                               │
        │  - Esc: Cancel                                       │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            INSERTION                                 │
        │  - Insert emoji at cursor position                   │
        │  - Close picker                                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE

        ┌─────────────────────────────────────────────────────┐
        │         ALTERNATE PATH: nvim-cmp                     │
        │  - Typing in insert mode                             │
        │  - Emoji suggestions appear in completion menu       │
        │  - Select via <C-n>/<C-p> and <CR>                   │
        └─────────────────────────────────────────────────────┘
```

## Git Integration Plugins

### gitlinker.lua - Generate GitHub Permalinks

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│              (File in git repository open)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ <Leader>gy or <Leader>go
        ┌─────────────────────────────────────────────────────┐
        │           PERMALINK GENERATION                       │
        │  - Detect current git remote (GitHub/GitLab/etc)     │
        │  - Get current file path and line numbers            │
        │  - Generate URL with commit hash/branch              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            URL ACTIONS                               │
        │  - Copy URL to clipboard (+ register)                │
        │  - Open URL in browser                               │
        │    • WSL: Use cmd.exe /c start                       │
        │    • Linux: Use xdg-open                             │
        │  - Show notification with URL                        │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### octo.nvim - GitHub Issues & PRs

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                   (Editor focused)                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ :Octo <command>
        ┌─────────────────────────────────────────────────────┐
        │           OCTO COMMAND MODE                          │
        │  Commands:                                           │
        │  - :Octo issue list                                  │
        │  - :Octo pr list                                     │
        │  - :Octo pr create                                   │
        │  - :Octo issue create                                │
        │  - :Octo pr checkout <number>                        │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │          TELESCOPE PICKER                            │
        │  (for list commands)                                 │
        │  - Show issues/PRs with preview                      │
        │  - Filter and search                                 │
        │  - Select to open                                    │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            OCTO BUFFER                               │
        │  - Special buffer showing issue/PR details           │
        │  - Markdown format                                   │
        │  - Edit comments inline                              │
        │  - Add/modify labels, assignees                      │
        │  - Save changes back to GitHub                       │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Close buffer
                      Return to IDLE STATE
```

## Editor Enhancement Plugins

### toggleterm.lua - Terminal Management

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLOSED STATE                              │
│                  (Terminal not visible)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ <C-\> or :ToggleTerm
        ┌─────────────────────────────────────────────────────┐
        │           TERMINAL OPEN                              │
        │  - Floating or split terminal                        │
        │  - Auto-switch to insert mode (buffermodes)          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           TERMINAL ACTIVE                            │
        │  - Execute shell commands                            │
        │  - <C-\> to toggle visibility                        │
        │  - Multiple terminals available (numbered)           │
        │  - Normal terminal keybindings work                  │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ <C-\> or :ToggleTerm
        ┌─────────────────────────────────────────────────────┐
        │            TERMINAL HIDDEN                           │
        │  - Process continues in background                   │
        │  - Can be toggled back visible                       │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ :ToggleTerm or reopen
                      Return to TERMINAL OPEN
```

### buffermodes.nvim - Auto Mode Switching

```
┌─────────────────────────────────────────────────────────────────┐
│                    BUFFER CREATED/ENTERED                        │
│                   (BufEnter event fired)                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           MODE DETECTION                             │
        │  - Check buffer filetype                             │
        │  - Look up in buffer_modes config:                   │
        │    • terminal → insert                               │
        │    • toggleterm → insert                             │
        │    • neo-tree → normal                               │
        │    • sidekick_terminal → insert                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            MODE SWITCH                               │
        │  - If current mode ≠ target mode:                    │
        │    • Execute mode switch command                     │
        │    • Update internal state                           │
        │  - If match: No action                               │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            CORRECT MODE ACTIVE                       │
        │  - User in appropriate mode for buffer type          │
        │  - Continues until buffer switch                     │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ BufLeave event
                      Return to BUFFER CREATED/ENTERED
```

### conform.nvim - Code Formatting

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                   (File being edited)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Trigger format
        ┌─────────────────────────────────────────────────────┐
        │           FORMAT TRIGGER                             │
        │  Manual:                                             │
        │  - <Leader>lf: Format buffer                         │
        │  - :Format command                                   │
        │  Automatic:                                          │
        │  - On save (if autoformat enabled)                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           FORMATTER SELECTION                        │
        │  - Check filetype                                    │
        │  - Look up formatters_by_ft config:                  │
        │    • js/ts → prettier                                │
        │    • markdown → cbfmt                                │
        │    • sh/bash/zsh → shfmt                             │
        │  - Fall back to LSP if no formatter                  │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            FORMATTING EXECUTION                      │
        │  - Run formatter on buffer/range                     │
        │  - Async operation (non-blocking)                    │
        │  - Preserve cursor position                          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            COMPLETION                                │
        │  - Apply formatting changes                          │
        │  - Show notification if errors                       │
        │  - Buffer remains in modified state                  │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE

        ┌─────────────────────────────────────────────────────┐
        │         TOGGLE AUTOFORMAT                            │
        │  - <Leader>uf: Toggle buffer autoformat              │
        │  - <Leader>uF: Toggle global autoformat              │
        │  - Notification shows current state                  │
        └─────────────────────────────────────────────────────┘
```

### treesitter.lua - Syntax Parsing

```
┌─────────────────────────────────────────────────────────────────┐
│                        FILE OPENED                               │
│                   (BufRead event fired)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           PARSER INITIALIZATION                      │
        │  - Detect file language                              │
        │  - Load appropriate treesitter parser                │
        │  - Parse file into AST                               │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            CONTINUOUS PARSING                        │
        │  - Monitor buffer changes                            │
        │  - Incremental re-parsing on edits                   │
        │  - Update AST in real-time                           │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            FEATURES ENABLED                          │
        │  - Syntax highlighting (contextual)                  │
        │  - Code folding (based on AST)                       │
        │  - Text objects (function, class, etc)               │
        │  - Indentation (language-aware)                      │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Buffer closed
                      Return to FILE OPENED (for next file)
```

## Testing & Debugging Plugins

### neotest.lua - Test Runner

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                 (Test file open/closed)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Test command
        ┌─────────────────────────────────────────────────────┐
        │           TEST DISCOVERY                             │
        │  - Scan for test files/functions                     │
        │  - Parse test structure via treesitter               │
        │  - Build test tree                                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           TEST EXECUTION                             │
        │  - Run selected test(s)                              │
        │  - Capture output in real-time                       │
        │  - Show inline diagnostics                           │
        │  - Update test status icons                          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │            RESULTS DISPLAY                           │
        │  - ✓ Pass: Green checkmark                           │
        │  - ✗ Fail: Red X with error details                  │
        │  - Summary window (optional)                         │
        │  - Jump to failed test                               │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Close results or run again
                      Return to IDLE STATE
```

### nvim-dap-ui.lua - Debug UI

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                  (Debugging not active)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Start debugging session
        ┌─────────────────────────────────────────────────────┐
        │           DAP UI OPENED                              │
        │  - Scopes window (variables)                         │
        │  - Breakpoints window                                │
        │  - Stack traces window                               │
        │  - Console window (REPL)                             │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           ACTIVE DEBUGGING                           │
        │  - Step over/into/out                                │
        │  - Continue/pause execution                          │
        │  - Inspect variables                                 │
        │  - Evaluate expressions in REPL                      │
        │  - Set/remove breakpoints                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SESSION END                                │
        │  - Program terminates or user stops                  │
        │  - Close debug UI windows                            │
        │  - Return to normal editing                          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

## Utility Plugins

### autopairs.lua - Auto-close Pairs

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                    (Insert mode active)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Type opening char: ( { [ " '
        ┌─────────────────────────────────────────────────────┐
        │           PAIR INSERTED                              │
        │  - Insert opening character                          │
        │  - Auto-insert closing character                     │
        │  - Place cursor between pair                         │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Type closing char when already present
        ┌─────────────────────────────────────────────────────┐
        │           SKIP DUPLICATE                             │
        │  - Don't insert duplicate closing char               │
        │  - Move cursor past existing closing char            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Press backspace on opening char
        ┌─────────────────────────────────────────────────────┐
        │           DELETE PAIR                                │
        │  - Delete opening character                          │
        │  - Also delete closing character                     │
        │  - Smart: only if nothing between pair               │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### mini-move.lua - Move Lines/Blocks

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│               (Normal or Visual mode)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Alt+h/j/k/l
        ┌─────────────────────────────────────────────────────┐
        │           MOVE OPERATION                             │
        │  Normal mode:                                        │
        │  - Alt+j: Move line down                             │
        │  - Alt+k: Move line up                               │
        │  - Alt+h: Move character left                        │
        │  - Alt+l: Move character right                       │
        │  Visual mode:                                        │
        │  - Move entire selection                             │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           REINDENT & UPDATE                          │
        │  - Move text to new position                         │
        │  - Re-indent based on context                        │
        │  - Update visual selection (if applicable)           │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### mini-clue.lua - Key Hint Display

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                  (Waiting for keypress)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Press <Leader> or other trigger key
        ┌─────────────────────────────────────────────────────┐
        │           TIMEOUT STARTED                            │
        │  - Wait configurable delay (e.g., 500ms)             │
        │  - User may complete mapping before timeout          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Timeout expires
        ┌─────────────────────────────────────────────────────┐
        │           HINT WINDOW DISPLAYED                      │
        │  - Show available key continuations                  │
        │  - Group by category (buffer, search, etc)           │
        │  - Display description for each mapping              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ User presses key or Esc
        ┌─────────────────────────────────────────────────────┐
        │           ACTION TAKEN                               │
        │  - If valid key: Execute mapping                     │
        │  - If Esc: Cancel and close hint window              │
        │  - Clear hint display                                │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

### worktrees.lua - Git Worktree Management

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                 (In git repository)                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ :Worktree command
        ┌─────────────────────────────────────────────────────┐
        │           WORKTREE MANAGER                           │
        │  Commands:                                           │
        │  - List worktrees                                    │
        │  - Create new worktree                               │
        │  - Switch to worktree                                │
        │  - Delete worktree                                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Select worktree
        ┌─────────────────────────────────────────────────────┐
        │           WORKTREE SWITCH                            │
        │  - Change working directory                          │
        │  - Update buffer paths                               │
        │  - Refresh file tree                                 │
        │  - Update git status                                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Create new worktree
        ┌─────────────────────────────────────────────────────┐
        │           WORKTREE CREATION                          │
        │  - Prompt for branch name                            │
        │  - Prompt for directory path                         │
        │  - Create worktree directory                         │
        │  - Checkout branch in worktree                       │
        │  - Optionally switch to new worktree                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

## Language Server Plugins

### astrolsp.lua - LSP Configuration

```
┌─────────────────────────────────────────────────────────────────┐
│                        FILE OPENED                               │
│                   (Supported language)                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           LSP CLIENT START                           │
        │  - Detect language                                   │
        │  - Start appropriate LSP server                      │
        │  - Attach client to buffer                           │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           LSP ACTIVE                                 │
        │  Features:                                           │
        │  - Diagnostics (errors/warnings)                     │
        │  - Hover documentation (K)                           │
        │  - Go to definition (gd)                             │
        │  - Find references (gr)                              │
        │  - Rename symbol (<Leader>lr)                        │
        │  - Code actions (<Leader>la)                         │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ User triggers LSP action
        ┌─────────────────────────────────────────────────────┐
        │           REQUEST TO SERVER                          │
        │  - Send request to LSP server                        │
        │  - Wait for response (async)                         │
        │  - Show loading indicator                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           RESPONSE HANDLING                          │
        │  - Parse LSP response                                │
        │  - Display results (picker/inline)                   │
        │  - Apply changes if applicable                       │
        │  - Update diagnostics                                │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Buffer closed
                      Return to FILE OPENED (for next file)
```

### mason.lua - LSP/Tool Installer

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                   (Editor running)                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ :Mason command
        ┌─────────────────────────────────────────────────────┐
        │           MASON UI OPENED                            │
        │  - List installed packages                           │
        │  - List available packages                           │
        │  - Show package details                              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           PACKAGE MANAGEMENT                         │
        │  - i: Install package under cursor                   │
        │  - X: Uninstall package                              │
        │  - u: Update package                                 │
        │  - U: Update all packages                            │
        │  - g?: Show help                                     │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Select install
        ┌─────────────────────────────────────────────────────┐
        │           INSTALLATION PROCESS                       │
        │  - Download package                                  │
        │  - Show progress in real-time                        │
        │  - Install dependencies                              │
        │  - Notify on completion/error                        │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Close Mason UI
                      Return to IDLE STATE
```

### symbol-usage.lua - Symbol Reference Count

```
┌─────────────────────────────────────────────────────────────────┐
│                        FILE OPENED                               │
│                   (LSP attached)                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SYMBOL DETECTION                           │
        │  - Identify symbols in buffer                        │
        │  - Request reference count from LSP                  │
        │  - Parse treesitter AST                              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           VIRTUAL TEXT DISPLAY                       │
        │  - Show "N references" above symbol                  │
        │  - Gray dimmed text (virtual text)                   │
        │  - Update on buffer changes                          │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Buffer modified
        ┌─────────────────────────────────────────────────────┐
        │           REFRESH CYCLE                              │
        │  - Debounced re-query                                │
        │  - Update reference counts                           │
        │  - Re-render virtual text                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Buffer closed
                      Return to FILE OPENED (for next file)
```

## Code Quality Plugins

### none-ls.lua - Additional Linters/Formatters

```
┌─────────────────────────────────────────────────────────────────┐
│                        FILE OPENED                               │
│                (Supported by none-ls source)                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SOURCE REGISTRATION                        │
        │  - Register linters (eslint, shellcheck, etc)        │
        │  - Register formatters (prettier, black, etc)        │
        │  - Register code actions                             │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           CONTINUOUS LINTING                         │
        │  - Run linters on buffer changes                     │
        │  - Display diagnostics inline                        │
        │  - Update diagnostic list                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ User requests format
        ┌─────────────────────────────────────────────────────┐
        │           FORMAT EXECUTION                           │
        │  - Run registered formatter                          │
        │  - Apply changes to buffer                           │
        │  - Show errors if any                                │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Buffer closed
                      Return to FILE OPENED (for next file)
```

### luasnip.lua - Snippet Engine

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                    (Insert mode)                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Type snippet trigger + Tab
        ┌─────────────────────────────────────────────────────┐
        │           SNIPPET EXPANSION                          │
        │  - Detect snippet trigger                            │
        │  - Expand snippet template                           │
        │  - Position cursor at first placeholder              │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           PLACEHOLDER NAVIGATION                     │
        │  - Tab: Jump to next placeholder                     │
        │  - Shift+Tab: Jump to previous placeholder           │
        │  - Type to fill current placeholder                  │
        │  - Placeholders can have defaults                    │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Complete all placeholders
        ┌─────────────────────────────────────────────────────┐
        │           SNIPPET COMPLETED                          │
        │  - Exit snippet mode                                 │
        │  - Return to normal insert mode                      │
        │  - Snippet fully expanded                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to IDLE STATE
```

## Visual Enhancement Plugins

### astroui.lua - UI Components

```
┌─────────────────────────────────────────────────────────────────┐
│                     NEOVIM STARTUP                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           UI INITIALIZATION                          │
        │  - Load colorscheme                                  │
        │  - Setup statusline                                  │
        │  - Setup winbar                                      │
        │  - Setup tabline                                     │
        │  - Configure icons                                   │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           PERSISTENT STATE                           │
        │  - Statusline: Always visible, shows mode/git/lsp    │
        │  - Winbar: Shows file path/breadcrumbs               │
        │  - Tabline: Shows buffer tabs with icons             │
        │  - Auto-updates on events                            │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           DYNAMIC UPDATES                            │
        │  - Mode changes → Update statusline color            │
        │  - Git changes → Update branch/diff in statusline    │
        │  - LSP events → Update diagnostics in statusline     │
        │  - Buffer switch → Update winbar/tabline             │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Neovim exit
                      UI Components tear down
```

### codediff.lua - VSCode-style Diffs

```
┌─────────────────────────────────────────────────────────────────┐
│                        IDLE STATE                                │
│                  (Git repository file)                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ Open diff view
        ┌─────────────────────────────────────────────────────┐
        │           DIFF VIEW CREATED                          │
        │  - Split window (side-by-side)                       │
        │  - Left: Original (HEAD)                             │
        │  - Right: Modified (working copy)                    │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           TWO-TIER HIGHLIGHTING                      │
        │  Line-level:                                         │
        │  - Red/Green background for changed lines            │
        │  Character-level:                                    │
        │  - Darker shade for exact character changes          │
        │  - More precise change visualization                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           DIFF NAVIGATION                            │
        │  - ]c: Next change                                   │
        │  - [c: Previous change                               │
        │  - do: Obtain diff (get change from other side)      │
        │  - dp: Put diff (put change to other side)           │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Close diff view
                      Return to IDLE STATE
```

### astrodash.lua - Enhanced Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│                     NEOVIM STARTUP                               │
│                   (No files opened)                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           DASHBOARD RENDERED                         │
        │  - ASCII art header (customizable)                   │
        │  - Quick action buttons                              │
        │  - Recent files list                                 │
        │  - Project shortcuts                                 │
        │  - Footer with info                                  │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           USER INTERACTION                           │
        │  - Number keys: Quick actions                        │
        │  - j/k: Navigate items                               │
        │  - Enter: Select item                                │
        │  - e: New file                                       │
        │  - q: Quit Neovim                                    │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Select action or open file
        ┌─────────────────────────────────────────────────────┐
        │           DASHBOARD EXIT                             │
        │  - Hide dashboard buffer                             │
        │  - Open selected file/action                         │
        │  - Return to dashboard if last buffer closed         │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Enter EDITOR STATE
```

### codesettings.lua - Per-project Settings

```
┌─────────────────────────────────────────────────────────────────┐
│                        PROJECT OPENED                            │
│                   (Directory changed)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SETTINGS DETECTION                         │
        │  - Look for .nvim.lua or .nvimrc                     │
        │  - Check for .editorconfig                           │
        │  - Scan for project-specific configs                 │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SETTINGS APPLICATION                       │
        │  - Load project settings file                        │
        │  - Execute Lua config (sandboxed)                    │
        │  - Apply overrides:                                  │
        │    • Tab width                                       │
        │    • LSP settings                                    │
        │    • Formatter preferences                           │
        │    • Project-specific mappings                       │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────────────────┐
        │           SETTINGS ACTIVE                            │
        │  - Project settings override global                  │
        │  - Apply to all buffers in project                   │
        │  - Persist until directory change                    │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼ Leave project directory
        ┌─────────────────────────────────────────────────────┐
        │           SETTINGS RESET                             │
        │  - Restore global settings                           │
        │  - Clear project overrides                           │
        └─────────────────────────────────────────────────────┘
                              │
                              ▼
                      Return to PROJECT OPENED (for new project)
```

## Summary

This document provides comprehensive state machine diagrams for all Neovim plugins in the configuration. Each diagram shows:

1. **Entry points**: How users initiate interaction (keymaps, events, commands)
2. **State transitions**: The flow of interaction through different states
3. **Actions**: What happens at each stage
4. **Exit conditions**: How the interaction completes and returns to idle/previous state

These diagrams serve as a reference for understanding the plugin ecosystem and how user interactions flow through the editor.
