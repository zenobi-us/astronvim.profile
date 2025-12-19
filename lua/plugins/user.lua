---@type LazySpec
return {
  -- Configure which-key to show LSP keymaps
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        width = 120,
        height = 30,
        border = "rounded",
      },
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fg", desc = "Find in files" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>fh", desc = "Find help tags" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "GitHub" },
        { "<leader>ghc", group = "Commits" },
        { "<leader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
        { "<leader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
        { "<leader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
        { "<leader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
        { "<leader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
        { "<leader>ghi", group = "Issues" },
        { "<leader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
        { "<leader>ghl", group = "Litee" },
        { "<leader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
        { "<leader>ghp", group = "Pull Request" },
        { "<leader>ghpc", "<cmd>GHClosePR<cr>", desc = "Close" },
        { "<leader>ghpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
        { "<leader>ghpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
        { "<leader>ghpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
        { "<leader>ghpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
        { "<leader>ghpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
        { "<leader>ghpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
        { "<leader>ghpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
        { "<leader>ghr", group = "Review" },
        { "<leader>ghrb", "<cmd>GHStartReview<cr>", desc = "Begin" },
        { "<leader>ghrc", "<cmd>GHCloseReview<cr>", desc = "Close" },
        { "<leader>ghrd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
        { "<leader>ghre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
        { "<leader>ghrs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
        { "<leader>ghrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
        { "<leader>ght", group = "Threads" },
        { "<leader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
        { "<leader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next" },
        { "<leader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
        { "<leader>gw", group = "Worktree" },
        { "<leader>gws", desc = "Switch worktree" },
        { "<leader>gwn", desc = "New worktree" },
        { "<leader>gwc", desc = "Create worktree from existing branch" },
        { "<leader>gwr", desc = "Remove worktree" },
        { "<leader>gy", desc = "Get GitHub URL" },
        { "<leader>l", group = "LSP" },
        { "<leader>la", desc = "Code action" },
        { "<leader>lA", desc = "Source action" },
        { "<leader>lf", desc = "Format buffer" },
        { "<leader>lG", desc = "Search workspace symbols" },
        { "<leader>lh", desc = "Signature help" },
        { "<leader>li", desc = "Hover information" },
        { "<leader>lL", desc = "Run code lens" },
        { "<leader>ll", desc = "Refresh code lenses" },
        { "<leader>lr", desc = "Rename symbol" },
        { "<leader>lR", desc = "Find all references" },
      },
    },
  },

  -- Ctrl+Click for goto definition
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.keymap.set("n", "<C-LeftMouse>", function() vim.lsp.buf.definition() end, { noremap = true, silent = true })
    end,
  },

  -- Customize mini.move keybindings
  {
    "echasnovski/mini.move",
    opts = {
      mappings = {
        -- Use Ctrl+Shift+Arrow keys for all directions
        left = "<C-S-Left>",
        right = "<C-S-Right>",
        up = "<C-S-Up>",
        down = "<C-S-Down>",
        line_left = "<C-S-Left>",
        line_right = "<C-S-Right>",
        line_up = "<C-S-Up>",
        line_down = "<C-S-Down>",
      },
    },
  },

  -- Shift+Arrow keys for selections in normal and insert mode
  {
    "folke/which-key.nvim",
    init = function()
      -- Normal mode: Shift+Arrow selects text
      vim.keymap.set("n", "<S-Left>", "v<Left>", { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Right>", "v<Right>", { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Up>", "v<Up>", { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Down>", "v<Down>", { noremap = true, silent = true })

      -- Insert mode: Shift+Arrow selects text and exits insert mode
      vim.keymap.set("i", "<S-Left>", "<Esc>v<Left>", { noremap = true, silent = true })
      vim.keymap.set("i", "<S-Right>", "<Esc>v<Right>", { noremap = true, silent = true })
      vim.keymap.set("i", "<S-Up>", "<Esc>v<Up>", { noremap = true, silent = true })
      vim.keymap.set("i", "<S-Down>", "<Esc>v<Down>", { noremap = true, silent = true })
    end,
  },

  -- Buffer mode manager - automatically switch to insert/normal mode based on buffer type
  {
    "mouse-peasant/buffermodes.nvim",
    dir = vim.env.HOME .. "/.config/nvim/lua/custom/mouse-peasant/buffermodes.nvim",
    opts = {
      debug = false,
      buffer_modes = {
        terminal = "insert",
        toggleterm = "insert",
        sidekick_terminal = "insert",
        ["neo-tree"] = "normal",
      },
    },
  },
  -- @NOTE: Disabled for now - conflicts with other popup menus
  --
  -- {
  --   "mouse-peasant/popup.nvim",
  --   dependencies = {
  --     "nvim-neo-tree/neo-tree.nvim",
  --   },
  --   dir = vim.env.HOME .. "/.config/nvim/lua/custom/mouse-peasant/popup.nvim",
  --   config = function(opts)
  --     require("mousepeasant-popup").setup {
  --       menus = {
  --         PopUp = {
  --           unpack(require("plugins.popups.neotree").get_menus()),
  --         },
  --       },
  --     }
  --     -- setup node tracking for neotree
  --   end,
  -- },
  --
  --
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    opts = {
      source_selector = {
        winbar = false,
        statusline = false,
      },
      sources = { "filesystem", "document_symbols" },
    },
  },

  -- == Examples of Adding Plugins ==

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "mise x -- pokemon-go-colorscripts --name glalie --no-title",
            random = 10,
            pane = 1,
            indent = 19,
            height = 20,
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      -- Enable picker with vim.ui.select override for nice modal prompts
      picker = {
        ui_select = true,
      },
    },
  },

  -- Disable built-in alpha dashboard
  { "goolord/alpha-nvim", enabled = false },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- Generate GitHub permalinks for code selections
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local gitlinker = require "gitlinker"

      -- Detect if running in WSL
      local function is_wsl()
        local version_file = io.open("/proc/version", "r")
        if version_file then
          local version = version_file:read "*a"
          version_file:close()
          return version:lower():match "microsoft" ~= nil
        end
        return false
      end

      -- Configure gitlinker with WSL-aware browser opener
      gitlinker.setup {
        callbacks = {
          ["github.com"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
          ["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
          ["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
          ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
          ["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
          ["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
          ["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
          ["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
          ["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
          ["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
        },
        opts = {
          action_callback = function(url)
            -- Copy to clipboard
            vim.fn.setreg("+", url)
            -- Open in browser (WSL-aware)
            if is_wsl() then
              -- Use Windows browser opener from WSL
              vim.fn.jobstart({ "cmd.exe", "/c", "start", url }, { detach = true })
            else
              -- Use default opener on native Linux
              vim.fn.jobstart({ "xdg-open", url }, { detach = true })
            end
            vim.notify("Copied URL to clipboard and opened in browser: " .. url)
          end,
        },
      }

      vim.keymap.set(
        { "n", "v" },
        "<leader>gy",
        function() require("gitlinker").get_buf_range_url "n" end,
        { silent = true, desc = "Get GitHub URL for selection" }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>go",
        function() require("gitlinker").get_buf_range_url "n" end,
        { silent = true, desc = "Open buffer in GitHub" }
      )
    end,
  },

  -- Git file history viewer
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup()
      vim.keymap.set("n", "<leader>gfh", "<cmd>DiffviewFileHistory %<cr>", { silent = true, desc = "File history" })
    end,
  },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  -- Configure Copilot to use a specific Node.js version from mise
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.fn.system("mise which --tool node@latest node"):gsub("\n", ""),
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-Right>",
          accept_word = false,
          accept_line = false,
          next = "<C-Down>",
          prev = "<C-Up>",
          dismiss = "<C-Backspace>",
        },
      },
      filetypes = {
        yaml = true,
        yml = true,
        markdown = true,
      },
    },
  },

  -- Integrate Copilot with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("copilot_cmp").setup() end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
