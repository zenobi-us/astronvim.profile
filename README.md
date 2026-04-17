# AstroNvim Configuration

> **NOTE:** This is for AstroNvim v5+

A fully-featured [AstroNvim](https://github.com/AstroNvim/AstroNvim) configuration with AI coding, testing, and git utilities.

## Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/<your_user>/<your_repository> ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

---

## Plugins

- **AstroNvim Core**: astrocore, astrolsp, astroui — base IDE framework with LSP integration
- **Search & Navigation**: fzf-lua, Snacks.nvim picker/dashboard — fuzzy finding, startup dashboard, and command/keymap discovery
- **AI Coding**: CodeCompanion — AI pair programming with img-clip for image insertion, GitHub Copilot — AI code suggestions
- **Testing**: neotest + neotest-vitest — run and debug tests inline
- **Git**: octo.nvim, worktrees.nvim, codediff.nvim — GitHub interaction, git worktree management, and VSCode-style diffs
- **Code Quality**: conform, none-ls, mason — formatting, linting, and tool management
- **Language Support**: tombi — TOML language server with JSON schema-aware validation
- **Debugging**: nvim-dap, nvim-dap-vscode-js — debugger integration with VS Code JavaScript adapters
- **Code Search**: grug-far — find and replace with preview
- **UI/UX**: neo-tree, scrollbar, symbol-usage, treesitter — file tree, dashboard polish, scroll position, and symbols
- **Terminal**: toggleterm — floating terminal toggle

## Keymaps


### Keymaps > Quickstart

**Most Common Tasks:**

File Navigation

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Find and open file                      | `<Leader>fc`            |
| Find and open recent file               | `<Leader>fO`            |
| Toggle file explorer                    | `<Leader>e`             |
| Search project (with word under cursor) | `<C-f>`                 |
| Find and replace (with selection)       | `<C-S-f>` (visual mode) |

Testing

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Run nearest test                        | `<Leader>tr`            |

LSP

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Go to definition                        | `gd`                    |
| Rename symbol                           | `<Leader>lr`            |
| Code actions                            | `<Leader>la`            |
| Format file                             | `<Leader>lf`            |

File Editing

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Save file                               | `<C-S>`                 |
| Close buffer                            | `<C-W>`                 |
| Clone line                              | `<C-S-d>`               |
| Delete line                             | `<C-S-k>`               |
| Move Line Up                            | `<C-S-Up>`              |
| Move Line Down                          | `<C-S-Down>`            |

Terminal

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Toggle terminal                         | `<Leader>tf`            |

Git & Diffs

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Switch git worktree                     | `<Leader>gws`           |
| Open diff explorer                      | `<Leader>do`            |
| Diff file with HEAD                     | `<Leader>df`            |

Debugging

| Task                                    | Keymap                  |
| --------------------------------------- | ----------------------- |
| Debug Interface                         | `<Leader>du`            |


### Normal Mode

| Category               | Keymap               | Action                                     |
| ---------------------- | -------------------- | ------------------------------------------ |
| **Buffer Navigation**  | `]b`                 | Next buffer                                |
|                        | `[b`                 | Previous buffer                            |
|                        | `<Leader>bd`         | Close buffer from tabline                  |
|                        | `<Leader>b\`         | Horizontal split buffer                    |
|                        | `<Leader>b\|`        | Vertical split buffer                      |
| **File Editing**       | `<C-S>`              | Save file                                  |
|                        | `<C-W>`              | Close buffer (with unsaved prompt)         |
|                        | `<C-c>`              | Copy current line to clipboard             |
|                        | `<C-x>`              | Cut current line to clipboard              |
|                        | `<C-v>`              | Paste from clipboard                       |
|                        | `<C-S-d>`            | Clone current line                         |
|                        | `<C-S-k>`            | Delete current line                        |
| **Word Navigation**    | `<C-Left>`           | Jump to previous word                      |
|                        | `<C-Right>`          | Jump to next word                          |
|                        | `<C-BS>`             | Delete word backward                       |
| **Line Navigation**    | `<Home>` / `<Find>`  | Move to first non-blank                    |
|                        | `<End>` / `<Select>` | Move to end of line                        |
| **History Navigation** | `<A-Left>`           | Go back in navigation history              |
|                        | `<A-Right>`          | Go forward in navigation history           |
| **Search & Replace**   | `<C-f>`              | Toggle grug-far search (with current word) |
|                        | `<C-S-f>`            | Toggle grug-far search and replace         |
| **Finder**             | `<Leader>fc`         | Find commands                              |
|                        | `<Leader>fk`         | Find keymaps                               |
|                        | `<Leader>fa`         | Find autocmds                              |
| **LSP**                | `gD`                 | Declaration of current symbol              |
|                        | `gd`                 | Definition of current symbol               |
|                        | `gy`                 | Type definition                            |
|                        | `gK`                 | Signature help                             |
|                        | `gl`                 | Show diagnostics in float                  |
|                        | `<Leader>li`         | Hover information                          |
|                        | `<Leader>lh`         | Signature help                             |
|                        | `<Leader>la`         | Code action                                |
|                        | `<Leader>lA`         | Source action                              |
|                        | `<Leader>lf`         | Format buffer                              |
|                        | `<Leader>lr`         | Rename current symbol                      |
|                        | `<Leader>lR`         | Find all references                        |
|                        | `<Leader>lG`         | Search workspace symbols                   |
| **Testing**            | `<Leader>tr`         | Run nearest test                           |
|                        | `<Leader>tf`         | Run test file                              |
|                        | `<Leader>ta`         | Run all tests                              |
|                        | `<Leader>ts`         | Stop test                                  |
|                        | `<Leader>td`         | Debug test                                 |
|                        | `<Leader>to`         | Open test output                           |
|                        | `<Leader>tS`         | Toggle test summary                        |
|                        | `<Leader>tn`         | Jump to next test                          |
|                        | `<Leader>tp`         | Jump to previous test                      |
| **Git Worktrees**      | `<Leader>gws`        | Switch worktree                            |
|                        | `<Leader>gwn`        | Create new worktree                        |
|                        | `<Leader>gwc`        | Create from existing branch                |
|                        | `<Leader>gwr`        | Remove worktree                            |
| **Git Diffs**          | `<Leader>do`         | Open diff explorer                         |
|                        | `<Leader>df`         | Diff file with HEAD                        |
|                        | `<Leader>dh`         | Diff file with HEAD~1                      |
|                        | `<Leader>dm`         | Diff file with branch (interactive)        |
| **Terminal**           | `<C-~>`              | Toggle last used terminal                  |

### Insert Mode

| Keymap                   | Action                           |
| ------------------------ | -------------------------------- |
| `<C-S>`                  | Save file (stay in insert)       |
| `<C-Left>`               | Jump to previous word            |
| `<C-Right>`              | Jump to next word                |
| `<C-BS>`                 | Delete word backward             |
| `<Home>` / `<Find>`      | Move to first non-blank          |
| `<End>` / `<Select>`     | Move to end of line              |
| `<S-Left/Right/Up/Down>` | Select character/line direction  |
| `<C-S-Left/Right>`       | Select word direction            |
| `<Tab>`                  | Accept Copilot suggestion or tab |
| `<M-]>`                  | Next Copilot suggestion          |
| `<M-[>`                  | Previous Copilot suggestion      |
| `<C-]>`                  | Dismiss Copilot suggestion       |
| `<C-c>`                  | Copy selection                   |
| `<C-x>`                  | Cut selection                    |
| `<C-v>`                  | Paste from clipboard             |
| `<C-S-d>`                | Clone selected lines             |
| `<C-S-k>`                | Delete selected lines            |

### Visual Mode

| Keymap    | Action                                   |
| --------- | ---------------------------------------- |
| `<C-f>`   | Toggle grug-far with selection           |
| `<C-S-f>` | Open grug-far and replace with selection |
| `<C-S-d>` | Clone selected lines                     |
| `<C-S-k>` | Delete selected lines                    |
| `<C-c>`   | Copy selection                           |
| `<C-x>`   | Cut selection                            |
| `<C-v>`   | Paste over selection                     |

