-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- wrap long lines
        linebreak = true, -- wrap at word boundaries
        breakindent = true, -- preserve indentation on wrapped lines
        modeline = true, -- enable modeline parsing
        modelines = 5, -- check first/last 5 lines for modelines
        whichwrap = "b,s,<,>,[,]", -- allow arrow keys to wrap across lines
        guicursor = "n-v-c:block,i-ci-ve:ver75,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- thicker insert cursor
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Better buffer split keymaps using fzf-lua picker
        ["<Leader>b\\"] = {
          function()
            local fzf = require "fzf-lua"
            fzf.buffers {
              winopts = { title = "Split Buffer Horizontally" },
              actions = {
                ["default"] = function(selected)
                  if selected and #selected > 0 then
                    local bufnr = tonumber(selected[1]:match "^%s*(%d+)")
                    if bufnr then
                      vim.cmd "split"
                      vim.api.nvim_set_current_buf(bufnr)
                    end
                  end
                end,
              },
            }
          end,
          desc = "Horizontal split buffer",
        },

        ["<Leader>b|"] = {
          function()
            local fzf = require "fzf-lua"
            fzf.buffers {
              winopts = { title = "Split Buffer Vertically" },
              actions = {
                ["default"] = function(selected)
                  if selected and #selected > 0 then
                    local bufnr = tonumber(selected[1]:match "^%s*(%d+)")
                    if bufnr then
                      vim.cmd "vsplit"
                      vim.api.nvim_set_current_buf(bufnr)
                    end
                  end
                end,
              },
            }
          end,
          desc = "Vertical split buffer",
        },

        -- save file
        ["<C-S>"] = { function() vim.cmd.write() end, desc = "Save file" },

        -- close buffer without quitting neovim, show dashboard if last buffer
        -- Uses vim.ui.select (which Snacks overrides) for a nice modal prompt
        ["<C-W>"] = {
          function()
            local buf = vim.api.nvim_get_current_buf()

            -- Get list of normal buffers (not special/hidden ones)
            local normal_bufs = vim.tbl_filter(
              function(b) return vim.bo[b].buflisted and vim.bo[b].buftype == "" end,
              vim.api.nvim_list_bufs()
            )
            local is_last_buffer = #normal_bufs <= 1

            local function close_buffer(save)
              if save then vim.cmd.write() end
              require("snacks").bufdelete { buf = buf, force = true }
              if is_last_buffer then vim.defer_fn(function() require("snacks").dashboard.open() end, 10) end
            end

            -- If buffer is modified, show modal confirmation via vim.ui.select
            if vim.bo[buf].modified then
              local filename = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
              vim.ui.select(
                { "Save and close", "Discard changes", "Cancel" },
                { prompt = "Unsaved changes in " .. filename },
                function(choice)
                  if choice == "Save and close" then
                    close_buffer(true)
                  elseif choice == "Discard changes" then
                    close_buffer(false)
                  end
                  -- Cancel or nil does nothing
                end
              )
            else
              close_buffer(false)
            end
          end,
          desc = "Close buffer",
        },

        -- Word jump with Ctrl+Arrow
        ["<C-Left>"] = { "b", desc = "Jump to previous word start" },
        ["<C-Right>"] = { "w", desc = "Jump to next word start" },

        -- Disable default window resize mappings
        ["<C-Up>"] = false,
        ["<C-Down>"] = false,

        -- Home/End keys (Alacritty sends <Find>/<Select> for these)
        ["<Home>"] = { "^", desc = "Move to first non-blank" },
        ["<End>"] = { "$", desc = "Move to end of line" },
        ["<Find>"] = { "^", desc = "Home key (Alacritty)" },
        ["<Select>"] = { "$", desc = "End key (Alacritty)" },

        -- Delete whole word with Ctrl+Backspace in normal mode
        ["<C-BS>"] = { "db", desc = "Delete word backward" },
        ["\x1b[127;5u"] = { "db", desc = "Delete word backward (Alacritty)" },

        -- Mouse-based LSP navigation
        -- Double-click for goto definition (works in ALL terminals)
        -- Smart: uses gf for markdown links, LSP definition otherwise
        ["<2-LeftMouse>"] = {
          function()
            local ft = vim.bo.filetype

            -- For markdown, check if we're on a link and use gf
            if ft == "markdown" then
              local line = vim.api.nvim_get_current_line()
              local col = vim.fn.col "."

              -- Check if cursor is inside a markdown link: [text](path) or just (path)
              -- Find all link patterns in the line
              local link_path = nil

              -- Pattern for markdown links: [text](path)
              for text, path in line:gmatch "%[([^%]]*)]%(([^%)]+)%)" do
                local start_pos, end_pos = line:find("%[" .. vim.pesc(text) .. "%]%(" .. vim.pesc(path) .. "%)", 1, false)
                if start_pos and col >= start_pos and col <= end_pos then
                  link_path = path
                  break
                end
              end

              -- If we found a link path, navigate to it
              if link_path then
                -- Remove any anchor (#section) from the path
                link_path = link_path:gsub("#.*$", "")
                -- Strip leading ./ from relative paths
                link_path = link_path:gsub("^%./", "")

                if link_path ~= "" then
                  -- Get the directory of the current file and resolve path
                  local current_dir = vim.fn.expand "%:p:h"
                  local full_path = vim.fn.fnamemodify(current_dir .. "/" .. link_path, ":p")

                  if vim.fn.filereadable(full_path) == 1 then
                    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                  else
                    vim.notify("File not found: " .. full_path, vim.log.levels.WARN)
                  end
                  return
                end
              end

              -- If not on a markdown link, try gf (go to file under cursor)
              local ok = pcall(vim.cmd, "normal! gf")
              if ok then return end
            end

            -- Default: use Snacks picker for go to definition
            require("snacks").picker.lsp_definitions()
          end,
          desc = "Goto definition (double-click)",
        },

        -- Ctrl+Click fallback (works if terminal supports it)
        ["<C-LeftMouse>"] = {
          function()
            vim.notify("Ctrl+Click works in your terminal!", vim.log.levels.INFO, { title = "LSP" })
            require("snacks").picker.lsp_definitions()
          end,
          desc = "Goto definition (Ctrl+Click - if supported)",
        },

        -- Grug find in current file on Ctrl+F
        ["<C-f>"] = {
          function()
            local search_term = vim.fn.expand "<cword>"
            require("grug-far").open {
              prefills = {
                search = search_term,
                paths = vim.fn.expand "%",
              },
            }
          end,
          desc = "Grug find in current file",
        },

        -- Grug find in project on Ctrl+Shift+F
        ["<C-S-f>"] = {
          function()
            local search_term = vim.fn.expand "<cword>"
            require("grug-far").open {
              prefills = { search = search_term },
            }
          end,
          desc = "Grug find in project",
        },

        -- Grug find/replace in project on Ctrl+Shift+H
        ["<C-S-h>"] = {
          function()
            local search_term = vim.fn.expand "<cword>"
            require("grug-far").open {
              prefills = { search = search_term },
            }
          end,
          desc = "Grug find/replace in project",
        },

        -- Find icons/emojis using Snacks picker
        ["<Leader>fe"] = {
          function() require("snacks").picker.icons() end,
          desc = "Find icons",
        },

        -- Clone current line (Ctrl+Shift+D)
        ["<C-S-d>"] = {
          function() vim.cmd "copy ." end,
          desc = "Clone current line",
        },

        -- Delete current line (Ctrl+Shift+K)
        ["<C-S-k>"] = {
          function() vim.cmd "delete" end,
          desc = "Delete current line",
        },

        -- Copy to clipboard (Ctrl+C)
        ["<C-c>"] = {
          function() vim.cmd 'normal! "+yy' end,
          desc = "Copy current line",
        },

        -- Cut to clipboard (Ctrl+X)
        ["<C-x>"] = {
          function() vim.cmd 'normal! "+dd' end,
          desc = "Cut current line",
        },

        -- Paste from clipboard (Ctrl+V)
        ["<C-v>"] = {
          function() vim.cmd 'normal! "+p' end,
          desc = "Paste after cursor",
        },

        -- Navigation with Alt arrow keys for back/forward
        ["<A-Left>"] = { "<C-o>", desc = "Go back in navigation history" },
        ["<A-Right>"] = { "<C-i>", desc = "Go forward in navigation history" },

        -- Shift+Arrow keys for text selection
        ["<S-Left>"] = { "v<Left>", desc = "Select to the left" },
        ["<S-Right>"] = { "v<Right>", desc = "Select to the right" },
        ["<S-Up>"] = { "v<Up>", desc = "Select up" },
        ["<S-Down>"] = { "v<Down>", desc = "Select down" },

        -- Undo and Redo
        ["<C-z>"] = { "u", desc = "Undo" },
        ["<C-S-z>"] = { "<C-r>", desc = "Redo" },

        -- Group labels for mini.clue (will auto-generate from keymaps with these prefixes)
        ["<Leader>a"] = { desc = "Alternate/Session" },
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>c"] = { desc = "Code" },
        ["<Leader>d"] = { desc = "Debug/Diff" },
        ["<Leader>f"] = { desc = "Find" },
        ["<Leader>g"] = { desc = "Git" },
        ["<Leader>gw"] = { desc = "Worktree" },
        ["<Leader>h"] = { desc = "Help" },
        ["<Leader>l"] = { desc = "LSP" },
        ["<Leader>s"] = { desc = "Search/Snippet/Split" },
        ["<Leader>t"] = { desc = "Terminal/Test" },
        ["<Leader>tp"] = {
          function()
            if vim.fn.executable "pi" == 1 then
              vim.cmd "TermExec cmd='pi' direction=float"
            else
              vim.notify("'pi' executable not found in PATH", vim.log.levels.ERROR)
            end
          end,
          desc = "Open pi-mono session",
        },
        ["<Leader>u"] = { desc = "UI" },
        ["<Leader>v"] = { desc = "Vertical split" },
        ["<Leader>w"] = { desc = "Window/Workspace" },

        -- LSP group mappings with descriptions
        ["<Leader>li"] = { desc = "Hover information" },
        ["<Leader>lr"] = { desc = "Rename symbol" },
        ["<Leader>lf"] = { desc = "Format buffer" },
        ["<Leader>la"] = { desc = "Code action" },
        ["<Leader>lA"] = { desc = "Source action" },
        ["<Leader>lG"] = { desc = "Search workspace symbols" },
        ["<Leader>lw"] = { "<cmd>Wayfinder<cr>", desc = "Open Wayfinder" },
        ["<Leader>lC"] = { desc = "Refresh code lenses" },
        ["<Leader>lL"] = { desc = "Run code lens" },

        -- Diff keybindings (codediff.nvim)
        ["<Leader>do"] = { "<cmd>CodeDiff<cr>", desc = "Open diff explorer" },
        ["<Leader>df"] = { "<cmd>CodeDiff file HEAD<cr>", desc = "Diff file with HEAD" },
        ["<Leader>dh"] = { "<cmd>CodeDiff file HEAD~1<cr>", desc = "Diff file with HEAD~1" },
        ["<Leader>dm"] = {
          function()
            -- Get default branch and compare with it
            vim.ui.input({ prompt = "Compare with branch: ", default = "main" }, function(branch)
              if branch then vim.cmd("CodeDiff file " .. branch) end
            end)
          end,
          desc = "Diff file with branch",
        },

        -- Git keybindings
        ["<Leader>gP"] = {
          function()
            local target = nil

            -- If this branch has a PR, diff against the PR base branch.
            local pr_base = vim.fn.system("gh pr view --json baseRefName --jq '.baseRefName' 2>/dev/null"):gsub("%s+", "")
            if pr_base ~= "" and vim.v.shell_error == 0 then
              target = pr_base
            end

            -- Otherwise fall back to the repo default branch.
            if not target then
              local default_branch = vim.fn
                .system("gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null")
                :gsub("%s+", "")
              if default_branch ~= "" and vim.v.shell_error == 0 then target = default_branch end
            end

            -- Final fallback.
            target = target or "main"

            -- Prefer origin/<branch> when it exists, otherwise use branch name directly.
            local remote_ref = "origin/" .. target
            local has_remote_ref = vim.fn.system("git show-ref --verify --quiet refs/remotes/" .. remote_ref .. " 2>/dev/null")
            local base = (vim.v.shell_error == 0 and has_remote_ref ~= nil) and remote_ref or target

            require("snacks").picker.git_diff { group = true, base = base }
          end,
          desc = "Git diff vs PR target/default branch",
        },

        ["<Leader>gf"] = {
          function() require("snacks").picker.git_log_file() end,
          desc = "Git history for current file",
        },

        -- Worktree keybindings with descriptions
        ["<Leader>gws"] = { desc = "Switch worktree" },
        ["<Leader>gwn"] = { desc = "New worktree" },
        ["<Leader>gwc"] = { desc = "Create worktree from branch" },
        ["<Leader>gwr"] = { desc = "Remove worktree" },
        ["<Leader>gy"] = { desc = "Get GitHub URL" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        -- Toggle last used toggleterm layout (Ctrl+~)
        ["<C-~>"] = {
          function() require("toggleterm").toggle() end,
          desc = "Toggle last used toggleterm",
        },
      },
      i = {
        -- save file in insert mode without leaving insert mode
        ["<C-S>"] = { function() vim.api.nvim_command "write" end, desc = "Save file" },

        -- Word jump with Ctrl+Arrow in insert mode
        ["<C-Left>"] = { "<C-o>b", desc = "Jump to previous word start" },
        ["<C-Right>"] = { "<C-o>w", desc = "Jump to next word start" },

        -- Delete whole word with Ctrl+Backspace (uses Vim's built-in CTRL-W)
        -- Note: Requires Alacritty to send the escape sequence (see alacritty.toml)
        ["<C-BS>"] = { "<C-w>", desc = "Delete word backward" },
        -- Map the escape sequence that Alacritty sends for Ctrl+Backspace
        ["\x1b[127;5u"] = { "<C-w>", desc = "Delete word backward (Alacritty)" },

        -- Home/End keys (Alacritty sends <Find>/<Select> for these)
        ["<Home>"] = { "<C-o>^", desc = "Move to first non-blank" },
        ["<End>"] = { "<C-o>$", desc = "Move to end of line" },
        ["<Find>"] = { "<C-o>^", desc = "Home key (Alacritty)" },
        ["<Select>"] = { "<C-o>$", desc = "End key (Alacritty)" },

        -- Text selection with Shift+Arrow keys (character/line at a time)
        ["<S-Left>"] = { "<C-o>vh", desc = "Select character left" },
        ["<S-Right>"] = { "<C-o>vl", desc = "Select character right" },
        ["<S-Up>"] = { "<C-o>vk", desc = "Select line up" },
        ["<S-Down>"] = { "<C-o>vj", desc = "Select line down" },

        -- Text selection with Ctrl+Shift+Arrow keys (word/line at a time)
        ["<C-S-Left>"] = { "<C-o>vb", desc = "Select word left" },
        ["<C-S-Right>"] = { "<C-o>vw", desc = "Select word right" },
        ["<C-S-Up>"] = { "<C-o>vk", desc = "Select line up" },
        ["<C-S-Down>"] = { "<C-o>vj", desc = "Select line down" },

        -- Undo/Redo in insert mode
        ["<C-z>"] = { "<C-o>u", desc = "Undo" },
        ["<C-S-z>"] = { "<C-o><C-r>", desc = "Redo" },

        -- Trigger completion dropdown
        ["<C-Space>"] = {
          function() require("cmp").complete() end,
          desc = "Trigger completion",
        },

        -- Copilot keymaps
        ["<Tab>"] = {
          function()
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            else
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n")
            end
          end,
          desc = "Accept Copilot suggestion or tab",
        },

        -- Toggle last used toggleterm layout (Ctrl+~)
        ["<C-~>"] = {
          function() require("toggleterm").toggle() end,
          desc = "Toggle last used toggleterm",
        },

        ["<M-]>"] = {
          function() require("copilot.suggestion").next() end,
          desc = "Next Copilot suggestion",
        },

        ["<M-[>"] = {
          function() require("copilot.suggestion").prev() end,
          desc = "Previous Copilot suggestion",
        },

        ["<C-]>"] = {
          function() require("copilot.suggestion").dismiss() end,
          desc = "Dismiss Copilot suggestion",
        },

        -- Paste from clipboard (Ctrl+V)
        ["<C-v>"] = { "<C-r>+", desc = "Paste from clipboard" },

        -- Copy to clipboard (Ctrl+C)
        ["<C-c>"] = {
          function() vim.cmd 'normal! "+y' end,
          desc = "Copy selection",
        },

        -- Cut to clipboard (Ctrl+X)
        ["<C-x>"] = {
          function() vim.cmd 'normal! "+d' end,
          desc = "Cut selection",
        },

        -- Clone selected lines (Ctrl+Shift+D)
        ["<C-S-d>"] = {
          function() vim.cmd "'<,'>copy '>'" end,
          desc = "Clone selected lines",
        },

        -- Delete selected lines (Ctrl+Shift+K)
        ["<C-S-k>"] = {
          function() vim.cmd "'<,'>delete" end,
          desc = "Delete selected lines",
        },
      },
      v = {
        -- Grug find in current file in visual mode
        ["<C-f>"] = {
          function()
            vim.cmd 'noau normal! "zy'
            local search_term = vim.fn.getreg "z"
            require("grug-far").open {
              prefills = {
                search = search_term,
                paths = vim.fn.expand "%",
              },
            }
          end,
          desc = "Grug find in current file with selection",
        },

        -- Grug find in project in visual mode
        ["<C-S-f>"] = {
          function()
            vim.cmd 'noau normal! "zy'
            local search_term = vim.fn.getreg "z"
            require("grug-far").open { prefills = { search = search_term } }
          end,
          desc = "Grug find in project with selection",
        },

        -- Grug find/replace in project in visual mode
        ["<C-S-h>"] = {
          function()
            vim.cmd 'noau normal! "zy'
            local search_term = vim.fn.getreg "z"
            require("grug-far").open { prefills = { search = search_term } }
          end,
          desc = "Grug find/replace in project with selection",
        },

        -- Clone selected lines (Ctrl+Shift+D)
        ["<C-S-d>"] = {
          function() vim.cmd "'<,'>copy '>'" end,
          desc = "Clone selected lines",
        },

        -- Delete selected lines (Ctrl+Shift+K)
        ["<C-S-k>"] = {
          function() vim.cmd "'<,'>delete" end,
          desc = "Delete selected lines",
        },

        -- Sort selected lines ascending
        ["<Leader>sa"] = {
          function() vim.cmd "'<,'>sort" end,
          desc = "Sort selected lines ascending",
        },

        -- Sort selected lines descending
        ["<Leader>sd"] = {
          function() vim.cmd "'<,'>sort!" end,
          desc = "Sort selected lines descending",
        },

        -- Copy to clipboard (Ctrl+C)
        ["<C-c>"] = {
          function() vim.cmd 'normal! "+y' end,
          desc = "Copy selection",
        },

        -- Cut to clipboard (Ctrl+X)
        ["<C-x>"] = {
          function() vim.cmd 'normal! "+d' end,
          desc = "Cut selection",
        },

        -- Paste over selection (Ctrl+V)
        ["<C-v>"] = {
          function() vim.cmd 'normal! "+p' end,
          desc = "Paste over selection",
        },

        -- Shift+Arrow keys for text selection
        ["<S-Left>"] = { "<Left>", desc = "Select to the left" },
        ["<S-Right>"] = { "<Right>", desc = "Select to the right" },
        ["<S-Up>"] = { "<Up>", desc = "Select up" },
        ["<S-Down>"] = { "<Down>", desc = "Select down" },
      },
      c = {
        -- Delete whole word with Ctrl+Backspace in command mode
        ["<C-BS>"] = { "<C-w>", desc = "Delete word backward" },
        ["\x1b[127;5u"] = { "<C-w>", desc = "Delete word backward (Alacritty)" },
      },
      t = {
        -- Toggle last used toggleterm layout (Ctrl+~)
        ["<C-~>"] = {
          function() require("toggleterm").toggle() end,
          desc = "Toggle last used toggleterm",
        },
      },
    },
    -- Additional setup for complex keybinds and autocommands
    init = function()
      -- Toggle last used toggleterm layout (Ctrl+~) - normal mode
      vim.keymap.set(
        { "n", "i", "t" },
        "<C-~>",
        function() require("toggleterm").toggle() end,
        { noremap = true, silent = true, desc = "Toggle last used toggleterm" }
      )

      -- Load launch.json when nvim-dap-view opens
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dapui_*",
        callback = function()
          local ok, dap_ext = pcall(require, "dap.ext.vscode")
          if ok then dap_ext.load_launchjs() end
        end,
      })

      -- Markdown: gd follows links to local files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          vim.keymap.set("n", "gd", function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.fn.col "."

            -- Check if cursor is inside a markdown link: [text](path)
            local link_path = nil
            for text, path in line:gmatch "%[([^%]]*)]%(([^%)]+)%)" do
              local pattern = "%[" .. vim.pesc(text) .. "%]%(" .. vim.pesc(path) .. "%)"
              local start_pos, end_pos = line:find(pattern)
              if start_pos and col >= start_pos and col <= end_pos then
                link_path = path
                break
              end
            end

            if link_path then
              -- Remove any anchor (#section) from the path
              link_path = link_path:gsub("#.*$", "")
              -- Strip leading ./ from relative paths
              link_path = link_path:gsub("^%./", "")

              if link_path ~= "" then
                -- Get the directory of the current file and resolve path
                local current_dir = vim.fn.expand "%:p:h"
                local full_path = vim.fn.fnamemodify(current_dir .. "/" .. link_path, ":p")

                if vim.fn.filereadable(full_path) == 1 then
                  vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                else
                  vim.notify("File not found: " .. full_path, vim.log.levels.WARN)
                end
                return
              end
            end

            -- Fallback: try gf (go to file under cursor)
            local ok_gf = pcall(vim.cmd, "normal! gf")
            if not ok_gf then
              vim.notify("No link or file under cursor", vim.log.levels.INFO)
            end
          end, { buffer = args.buf, desc = "Follow markdown link" })
        end,
      })

      -- Create custom quit command with confirmation
      local function show_quit_confirm()
        local width = 40
        local height = 7
        local lines = {
          "┌" .. string.rep("─", width - 2) .. "┐",
          "│" .. string.rep(" ", width - 2) .. "│",
          "│" .. string.format("%-" .. (width - 2) .. "s", "  Are you sure?") .. "│",
          "│" .. string.rep(" ", width - 2) .. "│",
          "│" .. string.format("%-" .. (width - 2) .. "s", "  [Y]es    [N]o") .. "│",
          "│" .. string.rep(" ", width - 2) .. "│",
          "└" .. string.rep("─", width - 2) .. "┘",
        }

        -- Calculate centered position
        local ui = vim.api.nvim_list_uis()[1]
        local win_width = ui.width
        local win_height = ui.height
        local col = math.floor((win_width - width) / 2)
        local row = math.floor((win_height - height) / 2)

        -- Create floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local win_opts = {
          relative = "editor",
          width = width,
          height = height,
          col = col,
          row = row,
          style = "minimal",
          border = "none",
        }

        local win = vim.api.nvim_open_win(buf, true, win_opts)

        -- Key mappings for the confirmation
        local function handle_response(response)
          vim.api.nvim_win_close(win, true)
          if response == "yes" then vim.cmd "quit" end
        end

        vim.keymap.set("n", "y", function() handle_response "yes" end, { noremap = true, silent = true, buffer = buf })
        vim.keymap.set("n", "n", function() handle_response "no" end, { noremap = true, silent = true, buffer = buf })
        vim.keymap.set(
          "n",
          "<CR>",
          function() handle_response "yes" end,
          { noremap = true, silent = true, buffer = buf }
        )
        vim.keymap.set(
          "n",
          "<Esc>",
          function() handle_response "no" end,
          { noremap = true, silent = true, buffer = buf }
        )
      end

      vim.api.nvim_create_user_command("Q", function() show_quit_confirm() end, {})
      vim.cmd "cnoreabbrev q Q"

      -- Config reload command
      vim.api.nvim_create_user_command("ReloadConfig", function()
        -- Clear loaded modules to force reload
        for name, _ in pairs(package.loaded) do
          if name:match "^user" or name:match "^custom" or name:match "^polyfill" then package.loaded[name] = nil end
        end
        -- Reload the main config
        vim.cmd.source(vim.env.MYVIMRC)
        vim.notify("Config reloaded!", vim.log.levels.INFO)
      end, {})
    end,
  },
}
