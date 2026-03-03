-- Plugin: graphql.nvim
-- Description: GraphQL syntax highlighting and language support (Apollo compatible)
-- URL: https://www.apollographql.com/docs/ide-support/vim
---@type LazySpec
return {
  -- Tree-sitter parser for GraphQL syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "graphql" })
      end
    end,
  },

  -- File type detection for .graphql and .gql files
  {
    "AstroNvim/astrocore",
    opts = {
      filetypes = {
        extension = {
          graphql = "graphql",
          gql = "graphql",
        },
      },
    },
  },
}
