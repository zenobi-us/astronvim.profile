---@type LazySpec
return {
  -- Configure which-key to show LSP keymaps
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
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
      vim.keymap.set('n', '<C-LeftMouse>', function()
        vim.lsp.buf.definition()
      end, { noremap = true, silent = true })
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

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
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
