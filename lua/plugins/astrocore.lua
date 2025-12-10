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
        wrap = false, -- sets vim.opt.wrap
        modeline = true, -- enable modeline parsing
        modelines = 5, -- check first/last 5 lines for modelines
        whichwrap = "b,s,<,>,[,]", -- allow arrow keys to wrap across lines
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

        -- save file
        ["<C-S>"] = { function() vim.cmd.write() end, desc = "Save file" },

        -- close buffer without quitting neovim, show dashboard if last buffer
        -- Uses vim.ui.select (which Snacks overrides) for a nice modal prompt
        ["<C-W>"] = {
          function()
            local buf = vim.api.nvim_get_current_buf()
            
            -- Get list of normal buffers (not special/hidden ones)
            local normal_bufs = vim.tbl_filter(function(b)
              return vim.bo[b].buflisted and vim.bo[b].buftype == ""
            end, vim.api.nvim_list_bufs())
            local is_last_buffer = #normal_bufs <= 1
            
            local function close_buffer(save)
              if save then
                vim.cmd.write()
              end
              require("snacks").bufdelete({ buf = buf, force = true })
              if is_last_buffer then
                vim.defer_fn(function()
                  require("snacks").dashboard.open()
                end, 10)
              end
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
          desc = "Close buffer"
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

          -- Ctrl+Click to goto definition
          ["<C-LeftMouse>"] = { function() vim.lsp.buf.definition() end, desc = "Goto definition" },

          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          -- ["<Leader>b"] = { desc = "Buffers" },

          -- setting a mapping to false will disable it
          -- ["<C-S>"] = false,
        },
       i = {
         -- save file in insert mode without leaving insert mode
         ["<C-S>"] = { function() vim.api.nvim_command("write") end, desc = "Save file" },

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
         ["<S-Left>"] = { "<C-o>v<C-o>h", desc = "Select character left" },
         ["<S-Right>"] = { "<C-o>v<C-o>l", desc = "Select character right" },
         ["<S-Up>"] = { "<C-o>v<C-o>k", desc = "Select line up" },
         ["<S-Down>"] = { "<C-o>v<C-o>j", desc = "Select line down" },

         -- Text selection with Ctrl+Shift+Arrow keys (word/line at a time)
         ["<C-S-Left>"] = { "<C-o>v<C-o>b", desc = "Select word left" },
         ["<C-S-Right>"] = { "<C-o>v<C-o>w", desc = "Select word right" },
         ["<C-S-Up>"] = { "<C-o>v<C-o>k", desc = "Select line up" },
         ["<C-S-Down>"] = { "<C-o>v<C-o>j", desc = "Select line down" },
       },
      c = {
        -- Delete whole word with Ctrl+Backspace in command mode
        ["<C-BS>"] = { "<C-w>", desc = "Delete word backward" },
        ["\x1b[127;5u"] = { "<C-w>", desc = "Delete word backward (Alacritty)" },
      },
    },
  },
}
